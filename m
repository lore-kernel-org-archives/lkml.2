Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1GAJiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:38:23 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:40132 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab1GAJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:29 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/16] asus-wmi: fix keyboard backlight detection
Date: Fri,  1 Jul 2011 11:34:34 +0200
Message-Id: <1309512881-2901-10-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 2ab83d1..332103b 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -395,8 +395,9 @@ static int kbd_led_read(struct asus_wmi *asus, int *level, int *env)
 	retval = asus_wmi_get_devstate_bits(asus, ASUS_WMI_DEVID_KBD_BACKLIGHT,
 					    0xFFFF);
 
+	/* Unknown status is considered as off */
 	if (retval == 0x8000)
-		retval = -ENODEV;
+		retval = 0;
 
 	if (retval >= 0) {
 		if (level)
-- 
1.7.3.4

