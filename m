Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946424Ab2ERXEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:04:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946408Ab2ERXE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:26 -0400
Message-Id: <20120518211602.717259775@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Clouter <alex@digriz.org.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 36/54] crypto: mv_cesa requires on CRYPTO_HASH to build
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Clouter <alex@digriz.org.uk>

commit 1ebfefcf37a6e308266a8d786e8cfea0a454058c upstream.

Without CRYPTO_HASH being selected, mv_cesa has a lot of hooks
into undefined exports.
----
  MODPOST 81 modules
  Kernel: arch/arm/boot/Image is ready
  AS      arch/arm/boot/compressed/head.o
  GZIP    arch/arm/boot/compressed/piggy.gzip
  CC      arch/arm/boot/compressed/misc.o
  CC      arch/arm/boot/compressed/decompress.o
ERROR: "crypto_ahash_type" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_final" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_register_ahash" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_unregister_ahash" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_update" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_digest" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_setkey" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_alloc_shash" [drivers/crypto/mv_cesa.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
----

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -173,6 +173,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion


