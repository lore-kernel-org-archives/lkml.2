Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1KLU2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 15:28:01 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:39483 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1KLU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 15:28:00 -0500
Subject: [PATCH] [TRIVIAL] crypto: drop selects of bogus Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 21:27:55 +0100
Message-ID: <1321129675.27598.105.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 2cdc6899a8 ("crypto: ghash - Add GHASH digest algorithm for
GCM") and 0e1227d356 ("crypto: ghash - Add PCLMULQDQ accelerated
implementation") added "select CRYPTO_SHASH" to two entries. That
Kconfig symbol doesn't exist. These two selects are nops. Drop them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "yes "" | make config" before and after applying this patch.
Identical .config files were generated, as was expected.

 crypto/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 527a857..ae9c3ce 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -329,7 +329,6 @@ config CRYPTO_CRC32C_INTEL
 
 config CRYPTO_GHASH
 	tristate "GHASH digest algorithm"
-	select CRYPTO_SHASH
 	select CRYPTO_GF128MUL
 	help
 	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
@@ -477,7 +476,6 @@ config CRYPTO_WP512
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
 	depends on X86 && 64BIT
-	select CRYPTO_SHASH
 	select CRYPTO_CRYPTD
 	help
 	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
-- 
1.7.4.4



