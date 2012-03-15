Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031277Ab2COWtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:49:42 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:45760 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761635Ab2COWti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:49:38 -0400
Message-ID: <4F627201.3080100@xenotime.net>
Date: Thu, 15 Mar 2012 15:49:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: camellia-x86_64 - module init/exit functions
 should be static
References: <4F620F37.4070404@xenotime.net> <20120315201151.11667.63183.stgit@localhost6.localdomain6>
In-Reply-To: <20120315201151.11667.63183.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 01:11 PM, Jussi Kivilinna wrote:

> This caused conflict with twofish-x86_64-3way when compiled into kernel,
> same function names and not static.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/x86/crypto/camellia_glue.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
> index 1ca36a9..3306dc0 100644
> --- a/arch/x86/crypto/camellia_glue.c
> +++ b/arch/x86/crypto/camellia_glue.c
> @@ -1925,7 +1925,7 @@ static int force;
>  module_param(force, int, 0);
>  MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
>  
> -int __init init(void)
> +static int __init init(void)
>  {
>  	if (!force && is_blacklisted_cpu()) {
>  		printk(KERN_INFO
> @@ -1938,7 +1938,7 @@ int __init init(void)
>  	return crypto_register_algs(camellia_algs, ARRAY_SIZE(camellia_algs));
>  }
>  
> -void __exit fini(void)
> +static void __exit fini(void)
>  {
>  	crypto_unregister_algs(camellia_algs, ARRAY_SIZE(camellia_algs));
>  }
> 



-- 
~Randy
