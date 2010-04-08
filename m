Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab0DHRT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:19:56 -0400
Received: from tex.lwn.net ([70.33.254.29]:46501 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab0DHRQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:56 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 08/16] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
Date: Thu,  8 Apr 2010 11:15:38 -0600
Message-Id: <1270746946-12467-9-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

The i2c transactions involved in detecting LVDS (9 seconds) and TMDS
(16 seconds) add an extra 25 seconds to viafb load time on the XO-1.5.

[jc: minor merge conflict fixed]
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/video/via/hw.c  |    4 ++++
 drivers/video/via/lcd.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 7be462e..47ba09a 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2054,6 +2054,10 @@ static void init_gfx_chip_info(struct pci_dev *pdev,
 
 static void init_tmds_chip_info(void)
 {
+#ifdef CONFIG_OLPC_XO_1_5
+	if (machine_is_olpc())
+		return;
+#endif
 	viafb_tmds_trasmitter_identify();
 
 	if (INTERFACE_NONE == viaparinfo->chip_info->tmds_chip_info.
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index e0e2310..37a9746 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -208,6 +208,10 @@ static bool lvds_identify_integratedlvds(void)
 
 int viafb_lvds_trasmitter_identify(void)
 {
+#ifdef CONFIG_OLPC_XO_1_5
+	if (machine_is_olpc())
+		return FAIL;
+#endif
 	viaparinfo->shared->i2c_stuff.i2c_port = I2CPORTINDEX;
 	if (viafb_lvds_identify_vt1636()) {
 		viaparinfo->chip_info->lvds_chip_info.i2c_port = I2CPORTINDEX;
-- 
1.7.0.1

