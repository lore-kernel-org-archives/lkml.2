Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2FQU0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:26:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46776 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab2FQUZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:25:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 1/5] thinkpad_acpi: Drop pm_message_t arguments from suspend routines
Date: Sun, 17 Jun 2012 22:27:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
References: <201206172226.42729.rjw@sisk.pl>
In-Reply-To: <201206172226.42729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172227.23591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Multiple suspend routines in drivers/platform/x86/thinkpad_acpi.c
use take pm_message_t arguments that aren't used by any of them.
Make those routines take no arguments as that's what they should do.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/thinkpad_acpi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/platform/x86/thinkpad_acpi.c
===================================================================
--- linux.orig/drivers/platform/x86/thinkpad_acpi.c
+++ linux/drivers/platform/x86/thinkpad_acpi.c
@@ -277,7 +277,7 @@ struct ibm_struct {
 	int (*write) (char *);
 	void (*exit) (void);
 	void (*resume) (void);
-	void (*suspend) (pm_message_t state);
+	void (*suspend) (void);
 	void (*shutdown) (void);
 
 	struct list_head all_drivers;
@@ -931,7 +931,7 @@ static int tpacpi_suspend_handler(struct
 				 &tpacpi_all_drivers,
 				 all_drivers) {
 		if (ibm->suspend)
-			(ibm->suspend)(state);
+			(ibm->suspend)();
 	}
 
 	return 0;
@@ -3758,7 +3758,7 @@ static void hotkey_notify(struct ibm_str
 	}
 }
 
-static void hotkey_suspend(pm_message_t state)
+static void hotkey_suspend(void)
 {
 	/* Do these on suspend, we get the events on early resume! */
 	hotkey_wakeup_reason = TP_ACPI_WAKEUP_NONE;
@@ -6329,7 +6329,7 @@ static int __init brightness_init(struct
 	return 0;
 }
 
-static void brightness_suspend(pm_message_t state)
+static void brightness_suspend(void)
 {
 	tpacpi_brightness_checkpoint_nvram();
 }
@@ -6748,7 +6748,7 @@ static struct snd_kcontrol_new volume_al
 	.get = volume_alsa_mute_get,
 };
 
-static void volume_suspend(pm_message_t state)
+static void volume_suspend(void)
 {
 	tpacpi_volume_checkpoint_nvram();
 }
@@ -8107,7 +8107,7 @@ static void fan_exit(void)
 	flush_workqueue(tpacpi_wq);
 }
 
-static void fan_suspend(pm_message_t state)
+static void fan_suspend(void)
 {
 	int rc;
 

