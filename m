Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab2DYSzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:55:00 -0400
Received: from mx2.netapp.com ([216.240.18.37]:18024 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab2DYSy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:54:58 -0400
X-IronPort-AV: E=Sophos;i="4.75,481,1330934400"; 
   d="scan'208";a="643431590"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v2] SUNRPC: skip dead but not buried clients on PipeFS
 events
Thread-Topic: [PATCH v2] SUNRPC: skip dead but not buried clients on PipeFS
 events
Thread-Index: AQHNIxTn/SFFkm36aUWQVPW+0yWgXw==
Date: Wed, 25 Apr 2012 18:54:55 +0000
Message-ID: <1335380095.15862.26.camel@lade.trondhjem.org>
References: <20120420141042.7205.62608.stgit@localhost6.localdomain6>
	 <20120425173005.GD751@fieldses.org>
In-Reply-To: <20120425173005.GD751@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9BF71DEE9A73C4CA2D4C46692124478@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3PItClI008939

On Wed, 2012-04-25 at 13:30 -0400, J. Bruce Fields wrote:
> On Fri, Apr 20, 2012 at 06:11:02PM +0400, Stanislav Kinsbursky wrote:
> > v2: atomic_inc_return() was replaced by atomic_inc_not_zero().
> > 
> > These clients can't be safely dereferenced if their counter in 0.
> 
> I'm pretty confused by how these notifiers work....
> 
> rpc_release_client decrements cl_count to zero temporarily, to have it
> immediately re-incremented by rpc_free_auth.
> 
> So if we're called concurrently with rpc_release_client then it's sort
> of random whether someone gets this callback.
> 
> Is that a problem?

Not really. If we re-increment the client->cl_count in rpc_free_auth()
then it would be so that we can send off a bunch of NULL rpc calls to
destroy existing RPCSEC_GSS contexts. We shouldn't need to do any more
upcalls in pipefs.

If we care, we could simply move the call to rpc_unregister_client()
into rpc_free_auth() so that the pipefs notifier doesn't see us, or we
could set a flag to have it ignore us.

> Also, is this an existing bug?  (In which case Trond should take it
> now.)


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
