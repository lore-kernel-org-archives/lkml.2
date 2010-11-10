Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0KJSBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:01:16 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44768 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab0KJSBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86, mrst: Add audio driver bindings
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Nov 2010 17:40:48 +0000
Message-ID: <20101110174044.11340.78008.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

This patch adds the sound card bindings for Moorestown (pmic_audio) and
the Medfield platform (msic_audio) as IPC devices. This ensures they will be
created at the right time.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index a3fe2fd..f2bc945 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -499,6 +499,11 @@ static void __init *lis331dl_platform_data(void *info)
 	return &intr2nd_pdata;
 }
 
+static void __init *no_platform_data(void *info)
+{
+	return NULL;
+}
+
 static const struct devs_id __initconst device_ids[] = {
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
@@ -506,6 +511,8 @@ static const struct devs_id __initconst device_ids[] = {
 	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
 	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
+	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
 	{},
 };
 

