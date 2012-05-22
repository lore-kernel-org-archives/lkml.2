Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab2EVOhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:37:55 -0400
Received: from mx2.netapp.com ([216.240.18.37]:12201 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968Ab2EVOhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:37:53 -0400
X-IronPort-AV: E=Sophos;i="4.75,639,1330934400"; 
   d="scan'208";a="649424025"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v3] NFS: put net on idr allocation failure
Thread-Topic: [PATCH v3] NFS: put net on idr allocation failure
Thread-Index: AQHNN/FpgjfuYDvE0UGXu8PQk8QqApbWVlWA
Date: Tue, 22 May 2012 14:37:41 +0000
Message-ID: <1337697459.4269.7.camel@lade.trondhjem.org>
References: <20120522073709.20602.33027.stgit@localhost.localdomain>
	 <20120522080307.21303.60025.stgit@localhost.localdomain>
In-Reply-To: <20120522080307.21303.60025.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCE5AE40A55B884181C7A59C08221083@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4MEbxim017738

On Tue, 2012-05-22 at 12:03 +0400, Stanislav Kinsbursky wrote:
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  fs/nfs/client.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index 44cd70f..ae29d4f 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -176,8 +176,10 @@ static struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_
>  
>  #ifdef CONFIG_NFS_V4
>  	err = nfs_get_cb_ident_idr(clp, cl_init->minorversion);
> -	if (err)
> +	if (err) {
> +		put_net(clp->net);
>  		goto error_cleanup;
> +	}
>  
>  	spin_lock_init(&clp->cl_lock);
>  	INIT_DELAYED_WORK(&clp->cl_renewd, nfs4_renew_state);
> 

Let's just move the actual get_net() call to the end of the function.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
