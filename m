Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323Ab2CUVk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:40:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40497 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965076Ab2CUVku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:40:50 -0400
Message-ID: <1332366097.3858.54.camel@key-ThinkPad-W510>
Subject: [PATCH 16/17] powerpc: crypto: Build files for the nx device driver
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 21 Mar 2012 16:41:37 -0500
In-Reply-To: <1332365297.3858.5.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032121-7182-0000-0000-00000116A694
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files support configuring and building the nx device driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/Makefile           |    1 +
 arch/powerpc/crypto/nx/Makefile |   11 +++++++++++
 drivers/crypto/Kconfig          |   18 ++++++++++++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/crypto/nx/Makefile

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index b8b105c..4977c65 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -159,6 +159,7 @@ core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
 core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
+drivers-$(CONFIG_CRYPTO_DEV_NX) += arch/powerpc/crypto/nx/
 
 # Default to zImage, override when needed
 all: zImage
diff --git a/arch/powerpc/crypto/nx/Makefile b/arch/powerpc/crypto/nx/Makefile
new file mode 100644
index 0000000..39a283f
--- /dev/null
+++ b/arch/powerpc/crypto/nx/Makefile
@@ -0,0 +1,11 @@
+obj-$(CONFIG_CRYPTO_DEV_NX) += nx-crypto.o
+nx-crypto-objs := nx.o \
+		  nx_sysfs.o \
+		  nx-aes-cbc.o \
+		  nx-aes-ecb.o \
+		  nx-aes-gcm.o \
+		  nx-aes-ccm.o \
+		  nx-aes-ctr.o \
+		  nx-aes-xcbc.o \
+		  nx-sha256.o \
+		  nx-sha512.o
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 6d16b4b..f438ca5 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -293,4 +293,22 @@ config CRYPTO_DEV_S5P
 	  Select this to offload Samsung S5PV210 or S5PC110 from AES
 	  algorithms execution.
 
+
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
-- 
1.7.1


