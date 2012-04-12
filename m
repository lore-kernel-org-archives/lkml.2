Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab2DLPje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:39:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47674 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab2DLPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:39:30 -0400
Message-ID: <1334245166.18090.38.camel@key-ThinkPad-W510>
Subject: [PATCH v3 16/17] powerpc: crypto: Build files for the nx device
 driver
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        key@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 12 Apr 2012 10:39:26 -0500
In-Reply-To: <1334242825.18090.4.camel@key-ThinkPad-W510>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041215-7408-0000-0000-00000426B67E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files support configuring and building the nx device driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/Makefile      |    1 +
 drivers/crypto/Kconfig     |   17 +++++++++++++++++
 drivers/crypto/nx/Makefile |   11 +++++++++++
 3 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/nx/Makefile

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 6524c6e..16e1bd7 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -160,6 +160,7 @@ core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 core-$(CONFIG_PERF_EVENTS)	+= arch/powerpc/perf/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
+drivers-$(CONFIG_CRYPTO_DEV_NX) += drivers/crypto/nx/
 
 # Default to zImage, override when needed
 all: zImage
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab9abb4..4319248 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -295,4 +295,21 @@ config CRYPTO_DEV_TEGRA_AES
 	  To compile this driver as a module, choose M here: the module
 	  will be called tegra-aes.
 
+config CRYPTO_DEV_NX
+	tristate "Support for Power7+ in-Nest cryptographic accleration"
+	depends on PPC64 && IBMVIO
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_CCM
+	select CRYPTO_GCM
+	select CRYPTO_AUTHENC
+	select CRYPTO_XCBC
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	help
+	  Support for Power7+ in-Nest cryptographic acceleration. This
+	  module supports acceleration for AES and SHA2 algorithms. If you
+	  choose 'M' here, this module will be called nx_crypto.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
new file mode 100644
index 0000000..411ce59
--- /dev/null
+++ b/drivers/crypto/nx/Makefile
@@ -0,0 +1,11 @@
+obj-$(CONFIG_CRYPTO_DEV_NX) += nx-crypto.o
+nx-crypto-objs := nx.o \
+		  nx_debugfs.o \
+		  nx-aes-cbc.o \
+		  nx-aes-ecb.o \
+		  nx-aes-gcm.o \
+		  nx-aes-ccm.o \
+		  nx-aes-ctr.o \
+		  nx-aes-xcbc.o \
+		  nx-sha256.o \
+		  nx-sha512.o
-- 
1.7.1


