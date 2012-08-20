Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2HTQLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:11:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47764 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab2HTQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:11:39 -0400
X-IronPort-AV: E=Sophos;i="4.77,797,1336374000"; 
   d="scan'208";a="678560129"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] NFS: put net in case of idr allocation failure
Thread-Topic: [PATCH] NFS: put net in case of idr allocation failure
Thread-Index: AQHNftnzS2JpF0kpjEaI7x0W8CcmZpdjVJEA
Date: Mon, 20 Aug 2012 16:11:37 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA93BF311@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120820134350.27917.55176.stgit@localhost.localdomain>
In-Reply-To: <20120820134350.27917.55176.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <99348CE7766AA3439E46D1A2AA15A77E@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7KGBlce014135

On Mon, 2012-08-20 at 17:43 +0400, Stanislav Kinsbursky wrote:
> Put net reference we got in nfs_alloc_client() on error path.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  fs/nfs/nfs4client.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
> index cbcdfaf..b895629 100644
> --- a/fs/nfs/nfs4client.c
> +++ b/fs/nfs/nfs4client.c
> @@ -74,6 +74,7 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
>  	return clp;
>  
>  error:
> +	put_net(clp->cl_net);
>  	kfree(clp);
>  	return ERR_PTR(err);
>  }


No, that isn't anywhere near sufficient.

The correct thing to do here is to replace the kfree with a call to
nfs_free_client(), which will also clean up the allocation of
cl_hostname, put the module, etc.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
