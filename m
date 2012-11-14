Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018Ab2KNOcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:32:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46593 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661Ab2KNOcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:32:48 -0500
From: Mathias Leblanc <mathias.leblanc@st.com>
To: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Jean-Luc Blanc <jean-luc.blanc@st.com>,
        Mathias Leblanc <mathias.leblanc@st.com>
Subject: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C BUILD STUFF
Date: Wed, 14 Nov 2012 15:31:44 +0100
Message-Id: <1352903504-3364-3-git-send-email-mathias.leblanc@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352903504-3364-1-git-send-email-mathias.leblanc@st.com>
References: <1352903504-3364-1-git-send-email-mathias.leblanc@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * STMicroelectronics version 1.2.0, Copyright (C) 2010
 * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
 * This is free software, and you are welcome to redistribute it
 * under certain conditions.

This is the driver for TPM chip from ST Microelectronics.

If you have a TPM security chip from STMicroelectronics working with
an I2C, in menuconfig or .config choose the tpm driver on
device --> tpm and activate the protocol of your choice before compiling
the kernel.
The driver will be accessible from within Linux.

Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS

Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
---
 drivers/char/tpm/Kconfig  |   10 ++++++++++
 drivers/char/tpm/Makefile |    1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 915875e..765d1c7 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -81,4 +81,14 @@ config TCG_IBMVTPM
 	  will be accessible from within Linux.  To compile this driver
 	  as a module, choose M here; the module will be called tpm_ibmvtpm.
 
+config TCG_ST33_I2C
+        tristate "STMicroelectronics ST33 I2C TPM"
+        depends on I2C
+        depends on GPIOLIB
+        ---help---
+        If you have a TPM security chip from STMicroelectronics working with
+        an I2C bus say Yes and it will be accessible from within Linux.
+        To compile this driver as a module, choose M here; the module will be
+        called tpm_stm_st33_i2c.
+
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 5b3fc8b..4b04262 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
 obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
 obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
 obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
+obj-$(CONFIG_TCG_ST33_I2C) += tpm_stm_st33_i2c.o
-- 
1.7.9.5

