Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2G3XMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 19:12:10 -0400
Received: from mx2.netapp.com ([216.240.18.37]:39497 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab2G3XMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 19:12:07 -0400
X-IronPort-AV: E=Sophos;i="4.77,681,1336374000"; 
   d="scan'208";a="669833077"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] SUNRPC: return negative value in case rpcbind client
 creation error
Thread-Topic: [PATCH] SUNRPC: return negative value in case rpcbind client
 creation error
Thread-Index: AQHNbqi8Mfyga7emzkO2K/bN5EhJlA==
Date: Mon, 30 Jul 2012 23:12:05 +0000
Message-ID: <1343689924.8362.4.camel@lade.trondhjem.org>
References: <20120720114849.23572.91010.stgit@localhost.localdomain>
In-Reply-To: <20120720114849.23572.91010.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6F8E7BA06E78441ADC4079E3CEBB60E@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6UNCRRR007315

On Fri, 2012-07-20 at 15:57 +0400, Stanislav Kinsbursky wrote:
> Without this patch kernel will panic on LockD start, because lockd_up() checks
> lockd_up_net() result for negative value.
> >From my pow it's better to return negative value from rpcbind routines instead
> of replacing all such checks like in lockd_up().
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  net/sunrpc/rpcb_clnt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
> index 92509ff..a70acae 100644
> --- a/net/sunrpc/rpcb_clnt.c
> +++ b/net/sunrpc/rpcb_clnt.c
> @@ -251,7 +251,7 @@ static int rpcb_create_local_unix(struct net *net)
>  	if (IS_ERR(clnt)) {
>  		dprintk("RPC:       failed to create AF_LOCAL rpcbind "
>  				"client (errno %ld).\n", PTR_ERR(clnt));
> -		result = -PTR_ERR(clnt);
> +		result = PTR_ERR(clnt);
>  		goto out;
>  	}
>  
> @@ -298,7 +298,7 @@ static int rpcb_create_local_net(struct net *net)
>  	if (IS_ERR(clnt)) {
>  		dprintk("RPC:       failed to create local rpcbind "
>  				"client (errno %ld).\n", PTR_ERR(clnt));
> -		result = -PTR_ERR(clnt);
> +		result = PTR_ERR(clnt);
>  		goto out;
>  	}

Who is supposed to carry this patch? Is it Bruce or is it me?

Cheers
  Trond

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
