Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1BZJWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:22:50 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:51360 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1BZJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:22:47 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/14] asus-wmi: handle "unknown status" bit
Date: Sat, 26 Feb 2011 10:20:34 +0100
Message-Id: <1298712045-17671-6-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index d0f0931..39ce3c1 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -92,6 +92,7 @@ MODULE_LICENSE("GPL");
 
 /* DSTS masks */
 #define ASUS_WMI_DSTS_STATUS_BIT	0x00000001
+#define ASUS_WMI_DSTS_UNKNOWN_BIT	0x00000002
 #define ASUS_WMI_DSTS_PRESENCE_BIT	0x00010000
 #define ASUS_WMI_DSTS_BRIGHTNESS_MASK	0x000000FF
 #define ASUS_WMI_DSTS_MAX_BRIGTH_MASK	0x0000FF00
@@ -270,6 +271,11 @@ static int asus_wmi_get_devstate_bits(u32 dev_id, u32 mask)
 	if (!(retval & ASUS_WMI_DSTS_PRESENCE_BIT))
 		return -ENODEV;
 
+	if (mask == ASUS_WMI_DSTS_STATUS_BIT) {
+		if (retval & ASUS_WMI_DSTS_UNKNOWN_BIT)
+			return -ENODEV;
+	}
+
 	return retval & mask;
 }
 
-- 
1.7.4

