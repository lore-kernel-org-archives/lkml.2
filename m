Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2L2Vv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 16:51:58 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:42956 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2L2Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 16:51:52 -0500
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH] drivers/platform/x86/thinkpad_acpi.c: Handle HKEY event 0x6040
Date: Sat, 29 Dec 2012 22:51:49 +0100
Message-Id: <1356817910-20890-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAD77+gROUfVX=9LPZc6_jf=2Bc_iaf5FW5Z2efwESzORNrq9dQ@mail.gmail.com>
References: <CAD77+gROUfVX=9LPZc6_jf=2Bc_iaf5FW5Z2efwESzORNrq9dQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle HKEY event generated on AC power change. The current message
asks users to submit data related to this event which leads to
a lot of confusion and noise on the mailing list.

The following is a list affected models and 'Message-Id'
from ibm-acpi-devel@lists.sourceforge.net of people who saw this
event when either plugging or unplugging the AC adapter or
docking or undocking their laptop.

X120e - CAAAujb5v9dHdbdxDVvhNJoG4UrZC1TgKqeB_zGpAy7q8kZHMEQ@mail.gmail.com
X121e - 20120817143459.GB3462@x1.osrc.amd.com
X220  - Confirmed by Richard Hartmann
X220i - 4F406274.7070807@gmail.com
X220t - 4F489F5B.9040705@cs.tu-berlin.de
X230  - CAKx4u7kqvVH0-gstomsiVYdGC0i6=bGxzaQ8sq9gbg76TGme3w@mail.gmail.com
T420  - 9c848ee30b006737d0534d906bab0cf6@niklaas-baudet.net
T420s - 20120608080824.GS25324@hexapodia.org
W520  - 20121008181050.GF2549@ericlaptop.home.christensenplace.us

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 75dd651..15e2bba 100644
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
@@ -3629,6 +3628,12 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 			 "a sensor reports something is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
+	case TP_HKEY_EV_AC_CHANGED:
+		/* X120e, X121e, X220, X220i, X220t, X230, T420, T420s, W520:
+		 * AC status changed; can be triggered by plugging or
+		 * unplugging AC adapter, docking or undocking. */
+
+		/* fallthrough */
 
 	case TP_HKEY_EV_KEY_NUMLOCK:
 	case TP_HKEY_EV_KEY_FN:
-- 
1.7.10.4

