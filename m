Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921Ab0KQQR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:17:57 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48241 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868Ab0KQQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:17:56 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/7] sst: remove rest of aava bits and aava related code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:57:57 +0000
Message-ID: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

This removes the remaining bit of aava dependent and related bits from driver

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid.h            |    5 --
 drivers/staging/intel_sst/intelmid_v1_control.c |   50 -----------------------
 drivers/staging/intel_sst/intelmid_v2_control.c |    2 -
 3 files changed, 1 insertions(+), 56 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid.h b/drivers/staging/intel_sst/intelmid.h
index 81e7448..0ce1031 100644
--- a/drivers/staging/intel_sst/intelmid.h
+++ b/drivers/staging/intel_sst/intelmid.h
@@ -178,9 +178,4 @@ extern struct snd_kcontrol_new snd_intelmad_controls_mrst[];
 extern struct snd_kcontrol_new snd_intelmad_controls_mfld[];
 extern struct snd_pmic_ops *intelmad_vendor_ops[];
 
-/* This is an enabler hook as the platform detection logic isn't yet
-   present and depends on some firmware and DMI support to detect AAVA
-   devices. It will vanish once the AAVA platform support is merged */
-#define is_aava()	0
-
 #endif /* __INTELMID_H */
diff --git a/drivers/staging/intel_sst/intelmid_v1_control.c b/drivers/staging/intel_sst/intelmid_v1_control.c
index 9de86b2..3cc459b 100644
--- a/drivers/staging/intel_sst/intelmid_v1_control.c
+++ b/drivers/staging/intel_sst/intelmid_v1_control.c
@@ -132,56 +132,6 @@ static int mx_init_card(void)
 	return sst_sc_reg_access(sc_access, PMIC_WRITE, 47);
 }
 
-static int mx_init_capture_card(void)
-{
-	struct sc_reg_access sc_access[] = {
-		{0x206, 0x5a, 0x0},
-		{0x207, 0xbe, 0x0},
-		{0x208, 0x90, 0x0},
-		{0x209, 0x32, 0x0},
-		{0x20e, 0x22, 0x0},
-		{0x210, 0x84, 0x0},
-		{0x223, 0x20, 0x0},
-		{0x226, 0xC0, 0x0},
-	};
-
-	int retval = 0;
-
-	retval = sst_sc_reg_access(sc_access, PMIC_WRITE, 8);
-	if (0 != retval) {
-		/* pmic communication fails */
-		pr_debug("sst: pmic commn failed\n");
-		return retval;
-	}
-
-	pr_debug("sst: Capture configuration complete!!\n");
-	return 0;
-}
-
-static int mx_init_playback_card(void)
-{
-	struct sc_reg_access sc_access[] = {
-		{0x206, 0x00, 0x0},
-		{0x207, 0x00, 0x0},
-		{0x208, 0x00, 0x0},
-		{0x209, 0x51, 0x0},
-		{0x20e, 0x51, 0x0},
-		{0x210, 0x21, 0x0},
-		{0x223, 0x01, 0x0},
-	};
-	int retval = 0;
-
-	retval = sst_sc_reg_access(sc_access, PMIC_WRITE, 9);
-	if (0 != retval) {
-		/* pmic communication fails */
-		pr_debug("sst: pmic commn failed\n");
-		return retval;
-	}
-
-	pr_debug("sst: Playback configuration complete!!\n");
-	return 0;
-}
-
 static int mx_enable_audiodac(int value)
 {
 	struct sc_reg_access sc_access[3];
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 3a7de76..0ad11eb 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -871,7 +871,7 @@ static int nc_set_selected_input_dev(u8 value)
 		sc_access[2].mask = MASK6;
 		sc_access[3].reg_addr = 0x109;
 		sc_access[3].mask = MASK6;
-		sc_access[3].value = 0x40;
+		sc_access[3].value = 0x00;
 		num_val = 4;
 		break;
 	default:

