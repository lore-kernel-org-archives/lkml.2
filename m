Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1FENZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 09:25:38 -0400
Received: from plane.gmane.org ([80.91.229.3]:59205 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1FENZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 09:25:37 -0400
X-Greylist: delayed 1107 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jun 2011 09:25:37 EDT
From: Andreas Schwab <schwab@linux-m68k.org>
To: Al Viro 
	<public-viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@plane.gmane.org>
Cc: public-linux-nfs-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Chuck Lever 
	<public-chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@plane.gmane.org>,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org
Subject: Re: [PATCH] fix return values of rpcb_create_local()
References: <20110605130207.GE11521@ZenIV.linux.org.uk>
X-Yow: Have my two-tone, 1958 Nash METRO brought around..
Date: Sun, 05 Jun 2011 15:06:50 +0200
In-Reply-To: <20110605130207.GE11521@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 5 Jun 2011 14:02:07 +0100")
Message-ID: <m2tyc4whp1.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> writes:

> diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
> index 9a80a92..5efaf5f 100644
> --- a/net/sunrpc/rpcb_clnt.c
> +++ b/net/sunrpc/rpcb_clnt.c
> @@ -193,7 +193,7 @@ static int rpcb_create_local_unix(void)
>  	if (IS_ERR(clnt)) {
>  		dprintk("RPC:       failed to create AF_LOCAL rpcbind "
>  				"client (errno %ld).\n", PTR_ERR(clnt));
> -		result = -PTR_ERR(clnt);
> +		result = PTR_ERR(clnt);
>  		goto out;
>  	}
>  
> @@ -242,7 +242,7 @@ static int rpcb_create_local_net(void)
>  	if (IS_ERR(clnt)) {
>  		dprintk("RPC:       failed to create local rpcbind "
>  				"client (errno %ld).\n", PTR_ERR(clnt));
> -		result = -PTR_ERR(clnt);
> +		result = PTR_ERR(clnt);

Proabably the dprintk argument should be negated as well.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

