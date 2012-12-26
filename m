Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2LZSPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 13:15:08 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41762 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2LZSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 13:15:06 -0500
X-Greylist: delayed 1380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 13:15:05 EST
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH] drivers/platform/x86/thinkpad_acpi.c: Handle HKEY event 0x6040
Date: Wed, 26 Dec 2012 18:46:13 +0100
Message-Id: <1356543973-18459-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle HKEY event generated on AC power change. The current message
asks users to submit data related to this event which leads to
a lot of confusion and noise on the mailing list.

The following is a list of causes, affected models, and 'message-id'
from ibm-acpi-devel@lists.sourceforge.net :

AC plug/unplug:

X120e - CAAAujb5v9dHdbdxDVvhNJoG4UrZC1TgKqeB_zGpAy7q8kZHMEQ@mail.gmail.com
x121e - 20120817143459.GB3462@x1.osrc.amd.com
X220  - Confirmed by Richard Hartmann
X220i - 4F406274.7070807@gmail.com
X220t - 4F489F5B.9040705@cs.tu-berlin.de
X230  - CAKx4u7kqvVH0-gstomsiVYdGC0i6=bGxzaQ8sq9gbg76TGme3w@mail.gmail.com
T420  - 9c848ee30b006737d0534d906bab0cf6@niklaas-baudet.net
T420s - 20120608080824.GS25324@hexapodia.org
W520  - 20121008181050.GF2549@ericlaptop.home.christensenplace.us

Lid closed/openend:

X220  - 4F4124DF.5030205@gmail.com
        Could not be confirmed by author

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 75dd651..2645084 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -209,9 +209,8 @@ enum tpacpi_hkey_event_t {
 	TP_HKEY_EV_ALARM_SENSOR_XHOT	= 0x6022, /* sensor critically hot */
 	TP_HKEY_EV_THM_TABLE_CHANGED	= 0x6030, /* thermal table changed */
 
-	TP_HKEY_EV_UNK_6040		= 0x6040, /* Related to AC change?
-						     some sort of APM hint,
-						     W520 */
+	/* AC-related events */
+	TP_HKEY_EV_AC_CHANGED		= 0x6040, /* AC status changed */
 
 	/* Misc */
 	TP_HKEY_EV_RFKILL_CHANGED	= 0x7000, /* rfkill switch changed */
@@ -3629,6 +3628,13 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 			 "a sensor reports something is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
+	case TP_HKEY_EV_AC_CHANGED:
+		pr_info("AC status has changed\n");
+		/* X120e, x121e, X220, X220i, X220t, X230, T420, T420s, W520:
+		 * AC status changed; can be triggered by plugging or
+		 * unplugging AC adapter, docking or undocking, or closing
+		 * or opening the lid. */
+		break;
 
 	case TP_HKEY_EV_KEY_NUMLOCK:
 	case TP_HKEY_EV_KEY_FN:
-- 
1.7.10.4

