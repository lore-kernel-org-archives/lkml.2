Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1DXCXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:23:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36000 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757394Ab1DXCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:23:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/VzMxdJnvVGOxbg5TylSMp3b8y4G6ujIUbQEj+d6
	WdBq1k6Un1k4we
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/2] viafb: fix OLPC XO 1.5 device connection
Date: Sun, 24 Apr 2011 02:39:22 +0000
Message-Id: <1303612763-8852-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303612763-8852-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303612763-8852-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the devices connected on OLPC. The OLPC panel seems
to be connected to DVP1 and LVDS2 for some reasons and if not both
are handled correct the display does not work correct or not at all.
This patch prevents regressions on the OLPC where it worked by
accident but would break in future as the driver did not know the
correct devices connected. This might also fix hardware scaling.
Hopefully the OLPC is the only device with such a requirement but it
will be certainly better to actually know what devices are actually
connected and to not work by accident.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 980e263..b8f0110 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/via-core.h>
+#include <asm/olpc.h>
 #include "global.h"
 
 static struct pll_config cle266_pll_config[] = {
@@ -875,6 +876,10 @@ void viafb_set_iga_path(void)
 				viaparinfo->chip_info->
 				lvds_chip_info2.output_interface);
 	}
+
+	/* looks like the OLPC has its display wired to DVP1 and LVDS2 */
+	if (machine_is_olpc())
+		viaparinfo->shared->iga2_devices = VIA_DVP1 | VIA_LVDS2;
 }
 
 static void set_color_register(u8 index, u8 red, u8 green, u8 blue)
-- 
1.6.3.2

