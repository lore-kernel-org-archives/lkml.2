Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2BGOL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:11:56 -0500
Received: from mx2.netapp.com ([216.240.18.37]:19954 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab2BGOLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:11:54 -0500
X-IronPort-AV: E=Sophos;i="4.73,377,1325491200"; 
   d="scan'208";a="623217740"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 4/4] NFS: make nfs_client_lock per net ns
Thread-Topic: [PATCH 4/4] NFS: make nfs_client_lock per net ns
Thread-Index: AczZ9Ei2i4I+lTkhQfy3u0kf/qtH3QL7kr6AAACjUYAAABaAAA==
Date: Tue, 7 Feb 2012 14:11:46 +0000
Message-ID: <1328623906.4124.10.camel@lade.trondhjem.org>
References: <20120123172631.29637.17188.stgit@localhost6.localdomain6>
	 <1328622659.4124.3.camel@lade.trondhjem.org>
	 <4F31308B.1090002@parallels.com>
In-Reply-To: <4F31308B.1090002@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D2668105108354AA4FC32BEB96DAC00@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Feb 2012 14:11:48.0223 (UTC) FILETIME=[6E2430F0:01CCE5A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q17EC2j8028667

On Tue, 2012-02-07 at 18:09 +0400, Stanislav Kinsbursky wrote:
> 07.02.2012 17:51, Myklebust, Trond Ğ¿Ğ¸ÑˆĞµÑ‚:
> > 8<-------------------------------------------------------------------------
> >  From 5a489156da4fd15dd143f2b21dd9657b97dcef88 Mon Sep 17 00:00:00 2001
> > From: Trond Myklebust<Trond.Myklebust@netapp.com>
> > Date: Tue, 7 Feb 2012 00:05:11 -0500
> > Subject: [PATCH] NFS: Initialise the nfs_net->nfs_client_lock
> >
> > Ensure that we initialise the nfs_net->nfs_client_lock spinlock.
> > Also ensure that nfs_server_remove_lists() doesn't try to
> > dereference server->nfs_client before that is initialised.
> >
> 
> Sorry.
> Patch looks nice. Except one notice below.
> 
> > Signed-off-by: Trond Myklebust<Trond.Myklebust@netapp.com>
> > Cc: Stanislav Kinsbursky<skinsbursky@parallels.com>
> > ---
> >   fs/nfs/client.c |    6 +++++-
> >   1 files changed, 5 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> > index 1a5cd49..f0dacad 100644
> > --- a/fs/nfs/client.c
> > +++ b/fs/nfs/client.c
> > @@ -1055,8 +1055,11 @@ static void nfs_server_insert_lists(struct nfs_server *server)
> >   static void nfs_server_remove_lists(struct nfs_server *server)
> >   {
> >   	struct nfs_client *clp = server->nfs_client;
> > -	struct nfs_net *nn = net_generic(clp->net, nfs_net_id);
> > +	struct nfs_net *nn;
> >
> > +	if (clp == NULL)
> > +		return;
> > +	nn = net_generic(clp->net, nfs_net_id);
> >   	spin_lock(&nn->nfs_client_lock);
> >   	list_del_rcu(&server->client_link);
> >   	if (clp&&  list_empty(&clp->cl_superblocks))
> 
> This check for clp != NULL can be removed.
> 

Yep... I'll add that in...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
