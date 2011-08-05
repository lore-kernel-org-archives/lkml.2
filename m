Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab1HEVqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:46:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752177Ab1HEVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:46:32 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18IFwQvQsEI//01b3g4jCMAQPWgZ64YBqi0dukVfG
	qyZwEM9bbKJk/x
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/6] viafb: remove superfluous mode lookup
Date: Fri,  5 Aug 2011 22:05:12 +0000
Message-Id: <1312581912-4198-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the result is not used anywhere there is no need to perform the
lookup at all.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index bddae58..3eaf607 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1735,7 +1735,6 @@ static struct viafb_pm_hooks viafb_fb_pm_hooks = {
 int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 {
 	u32 default_xres, default_yres;
-	struct VideoModeTable *vmode_entry;
 	struct fb_var_screeninfo default_var;
 	int rc;
 	u32 viafb_par_length;
@@ -1808,7 +1807,6 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 	}
 
 	parse_mode(viafb_mode, &default_xres, &default_yres);
-	vmode_entry = viafb_get_mode(default_xres, default_yres);
 	if (viafb_SAMM_ON == 1)
 		parse_mode(viafb_mode1, &viafb_second_xres,
 			&viafb_second_yres);
-- 
1.6.3.2

