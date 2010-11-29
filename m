Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0K2O50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:57:26 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34168 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0K2O5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:57:24 -0500
Date: Mon, 29 Nov 2010 22:57:17 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: linux-next: Tree for November 29
Message-ID: <20101129145717.GA20232@gondor.apana.org.au>
References: <20101129140335.19800705.sfr@canb.auug.org.au> <AANLkTikiZoNM9zpXw3wSK7-uqh+ZYMpJ+wg0wPpBs_kx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikiZoNM9zpXw3wSK7-uqh+ZYMpJ+wg0wPpBs_kx@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 09:47:38AM +0000, Zimny Lech wrote:
> Ave
> 
> 2010/11/29 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101126:
> 
> 
> Setup is 14188 bytes (padded to 14336 bytes).
> System is 1267 kB
> CRC 61cea148
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 537 modules
> ERROR: "sock_no_mmap" [crypto/algif_skcipher.ko] undefined!

I hope this patch fixes it for you.

commit 7451708f39db19a8303bb7fb95f00aca9f673cb5
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Nov 29 22:56:03 2010 +0800

    crypto: af_alg - Add dependency on NET
    
    Add missing dependency on NET since we require sockets for our
    interface.
    
    Should really be a select but kconfig doesn't like that:
    
    net/Kconfig:6:error: found recursive dependency: NET -> NETWORK_FILESYSTEMS -> AFS_FS -> AF_RXRPC -> CRYPTO -> CRYPTO_USER_API_HASH -> CRYPTO_USER_API -> NET
    
    Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 467491d..96b0e55 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -848,6 +848,7 @@ config CRYPTO_USER_API
 
 config CRYPTO_USER_API_HASH
 	tristate "User-space interface for hash algorithms"
+	depends on NET
 	select CRYPTO_HASH
 	select CRYPTO_USER_API
 	help
@@ -856,6 +857,7 @@ config CRYPTO_USER_API_HASH
 
 config CRYPTO_USER_API_SKCIPHER
 	tristate "User-space interface for symmetric key cipher algorithms"
+	depends on NET
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_USER_API
 	help

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
