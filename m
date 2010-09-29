Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0I2L2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:28:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:21845 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0I2L2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:28:47 -0400
Message-ID: <4CA322DA.90705@parallels.com>
Date: Wed, 29 Sep 2010 15:28:26 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (Was:
 linux-next: build warning after merge of the final tree)
References: <20100929140238.c987caac.sfr@canb.auug.org.au> <20100929141657.3c076eb7.sfr@canb.auug.org.au>
In-Reply-To: <20100929141657.3c076eb7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This actually causes a build failure on a sparc32 defconfig build:
> 
> `rpcauth_remove_module' referenced in section `.init.text' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> 
> I applied the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 29 Sep 2010 14:07:07 +1000
> Subject: [PATCH] sunrpc: fix up section mismatch
> 
> Fixes:
> 
> `rpcauth_remove_module' referenced in section `.init.text' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Oops :(

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> ---
>  include/linux/sunrpc/auth.h |    4 ++--
>  net/sunrpc/auth.c           |    2 +-
>  net/sunrpc/auth_generic.c   |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
> index 5bbc447..b202475 100644
> --- a/include/linux/sunrpc/auth.h
> +++ b/include/linux/sunrpc/auth.h
> @@ -122,8 +122,8 @@ extern const struct rpc_authops	authnull_ops;
>  int __init		rpc_init_authunix(void);
>  int __init		rpc_init_generic_auth(void);
>  int __init		rpcauth_init_module(void);
> -void __exit		rpcauth_remove_module(void);
> -void __exit		rpc_destroy_generic_auth(void);
> +void			rpcauth_remove_module(void);
> +void			rpc_destroy_generic_auth(void);
>  void 			rpc_destroy_authunix(void);
>  
>  struct rpc_cred *	rpc_lookup_cred(void);
> diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
> index e9eaaf7..2c0d9e6 100644
> --- a/net/sunrpc/auth.c
> +++ b/net/sunrpc/auth.c
> @@ -658,7 +658,7 @@ out1:
>  	return err;
>  }
>  
> -void __exit rpcauth_remove_module(void)
> +void rpcauth_remove_module(void)
>  {
>  	rpc_destroy_authunix();
>  	rpc_destroy_generic_auth();
> diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
> index 43162bb..e010a01 100644
> --- a/net/sunrpc/auth_generic.c
> +++ b/net/sunrpc/auth_generic.c
> @@ -158,7 +158,7 @@ int __init rpc_init_generic_auth(void)
>  	return rpcauth_init_credcache(&generic_auth);
>  }
>  
> -void __exit rpc_destroy_generic_auth(void)
> +void rpc_destroy_generic_auth(void)
>  {
>  	rpcauth_destroy_credcache(&generic_auth);
>  }

