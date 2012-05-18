Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030704Ab2ERCwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40514 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933617Ab2ERCwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:39 -0400
Message-Id: <20120518023259.911762607@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Clouter <alex@digriz.org.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 41/53] crypto: mv_cesa requires on CRYPTO_HASH to build
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab9abb4..dd414d9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -164,6 +164,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
-- 
1.7.10



