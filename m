Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1JNJIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:08:42 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51519 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab1JNJIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:37 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 3/8] asus-laptop: allow boot time control of Pegatron ALS sensor
Date: Fri, 14 Oct 2011 11:13:37 +0200
Message-Id: <1318583622-23518-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Ross <andy.ross@windriver.com>

Signed-off-by: Andy Ross <andy.ross@windriver.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index afed9ff..e892a43 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -85,6 +85,7 @@ static int wlan_status = 1;
 static int bluetooth_status = 1;
 static int wimax_status = -1;
 static int wwan_status = -1;
+static int als_status;
 
 module_param(wlan_status, int, 0444);
 MODULE_PARM_DESC(wlan_status, "Set the wireless status on boot "
@@ -106,6 +107,11 @@ MODULE_PARM_DESC(wwan_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
 
+module_param(als_status, int, 0444);
+MODULE_PARM_DESC(als_status, "Set the ALS status on boot "
+		 "(0 = disabled, 1 = enabled). "
+		 "default is 0");
+
 /*
  * Some events we use, same for all Asus
  */
@@ -1472,7 +1478,7 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	asus->ledd_status = 0xFFF;
 
 	/* Set initial values of light sensor and level */
-	asus->light_switch = 0;	/* Default to light sensor disabled */
+	asus->light_switch = !!als_status;
 	asus->light_level = 5;	/* level 5 for sensor sensitivity */
 
 	if (asus->is_pega_lucid) {
-- 
1.7.3.4

