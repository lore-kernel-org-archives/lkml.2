Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031306Ab2COWuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:50:24 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55118 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031162Ab2COWtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:49:42 -0400
Message-ID: <4F627205.4070606@xenotime.net>
Date: Thu, 15 Mar 2012 15:49:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: twofish-x86_64-3way - module init/exit functions
 should be static
References: <4F620F37.4070404@xenotime.net> <20120315201157.11667.30754.stgit@localhost6.localdomain6>
In-Reply-To: <20120315201157.11667.30754.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 01:11 PM, Jussi Kivilinna wrote:

> This caused conflict with camellia-x86_64 when compiled into kernel, same
> function names and not static.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/x86/crypto/twofish_glue_3way.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
> index 408fc0c..922ab24 100644
> --- a/arch/x86/crypto/twofish_glue_3way.c
> +++ b/arch/x86/crypto/twofish_glue_3way.c
> @@ -668,7 +668,7 @@ static int force;
>  module_param(force, int, 0);
>  MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
>  
> -int __init init(void)
> +static int __init init(void)
>  {
>  	if (!force && is_blacklisted_cpu()) {
>  		printk(KERN_INFO
> @@ -681,7 +681,7 @@ int __init init(void)
>  	return crypto_register_algs(tf_algs, ARRAY_SIZE(tf_algs));
>  }
>  
> -void __exit fini(void)
> +static void __exit fini(void)
>  {
>  	crypto_unregister_algs(tf_algs, ARRAY_SIZE(tf_algs));
>  }
> 



-- 
~Randy
