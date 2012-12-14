Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2LNKcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:32:39 -0500
Received: from pmx.elettra.trieste.it ([140.105.206.203]:58757 "EHLO
	pmx.elettra.trieste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2LNKch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:32:37 -0500
From: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
Subject: crypto: omap-aes - fix a build error
Date: Fri, 14 Dec 2012 11:32:35 +0100
Message-Id: <1355481155-28621-1-git-send-email-alessio.bogani@elettra.trieste.it>
X-Mailer: git-send-email 1.7.9.5
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.12.14.100630
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_900_999 0, FROM_NAME_PHRASE 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __SXL_SIG_ERROR_SERVFAIL , __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS_NOANSWER '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
  CC      init/version.o
  LD      init/built-in.o
drivers/built-in.o:(.data+0xbc6c): undefined reference to `crypto_ablkcipher_type'
drivers/built-in.o:(.data+0xbd4c): undefined reference to `crypto_ablkcipher_type'

The omap-aes driver uses crypto_ablkcipher_type symbol without selecting it.

Signed-off-by: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
---
 drivers/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f6644f5..b04d78f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -254,6 +254,7 @@ config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
 	help
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
-- 
1.7.9.5

