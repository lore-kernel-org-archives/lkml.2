Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0DRSWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:22:20 -0400
Received: from tex.lwn.net ([70.33.254.29]:35350 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab0DRSVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:21:35 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 09/11] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
Date: Sun, 18 Apr 2010 12:21:11 -0600
Message-Id: <1271614873-5952-10-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271614873-5952-1-git-send-email-corbet@lwn.net>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

The i2c transactions involved in detecting LVDS (9 seconds) and TMDS
(16 seconds) add an extra 25 seconds to viafb load time on the XO-1.5.

[jc: minor merge conflict fixed, removed ifdefs]
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/video/via/hw.c  |    7 +++++++
 drivers/video/via/lcd.c |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 4aff0f7..bd5d5ce 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2037,6 +2037,13 @@ static void init_gfx_chip_info(struct pci_dev *pdev,
 
 static void init_tmds_chip_info(void)
 {
+	/*
+	 * OLPC XO 1.5 systems are wired differently, so there is
+	 * no point in them here.
+	 */
+	if (machine_is_olpc())
+		return;
+
 	viafb_tmds_trasmitter_identify();
 
 	if (INTERFACE_NONE == viaparinfo->chip_info->tmds_chip_info.
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index b656e59..ce3f4b6 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -173,6 +173,13 @@ static bool lvds_identify_integratedlvds(void)
 
 int viafb_lvds_trasmitter_identify(void)
 {
+	/*
+	 * OLPC XO 1.5 systems are wired differently, so there is
+	 * no point in them here.
+	 */
+	if (machine_is_olpc())
+		return FAIL;
+
 	viaparinfo->shared->i2c_stuff.i2c_port = I2CPORTINDEX;
 	if (viafb_lvds_identify_vt1636()) {
 		viaparinfo->chip_info->lvds_chip_info.i2c_port = I2CPORTINDEX;
-- 
1.7.0.1

