Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab0DPRAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:00:36 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:47794 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab0DPRAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=n49EhHLclsY4YNRQRk4oq9434wLECtTDvTVSEGureyUu04+HNh3rh9GUV7tL6kl2b4
         RDdY+h73XQ4/Wlr5vld54XyekDVAWdh0lgJFad8MLjpD5/VbzMbLSb1ld5EA3pQHmeeD
         psbPY2TBS21cCwWYqSlMiLHt+fki5VvJ9UhTA=
Subject: [PATCH] hid: Add mappings for a few keys found on Logitech MX3200
From: Lorenzo Castelli <lcastelli@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 19:00:31 +0200
Message-ID: <1271437231.3040.26.camel@lorenzo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keys are added to the generic wireless mappings in case other
keyboards use them. Note that the product ID for the MX3200 is the same
as USB_DEVICE_ID_S510_RECEIVER_2.

Signed-off-by: Lorenzo Castelli <lcastelli@gmail.com>
---
I tried to choose the most meaningful keys without adding new ones. I'm
not sure if this is the best approach though.
---
 drivers/hid/hid-lg.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 3677c90..f6433d8 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -126,6 +126,9 @@ static int lg_wireless_mapping(struct hid_input *hi, struct hid_usage *usage,
 	case 0x1004: lg_map_key_clear(KEY_VIDEO);		break;
 	case 0x1005: lg_map_key_clear(KEY_AUDIO);		break;
 	case 0x100a: lg_map_key_clear(KEY_DOCUMENTS);		break;
+	/* The following two entries are Playlist 1 and 2 on the MX3200 */
+	case 0x100f: lg_map_key_clear(KEY_FN_1);		break;
+	case 0x1010: lg_map_key_clear(KEY_FN_2);		break;
 	case 0x1011: lg_map_key_clear(KEY_PREVIOUSSONG);	break;
 	case 0x1012: lg_map_key_clear(KEY_NEXTSONG);		break;
 	case 0x1013: lg_map_key_clear(KEY_CAMERA);		break;
@@ -137,6 +140,7 @@ static int lg_wireless_mapping(struct hid_input *hi, struct hid_usage *usage,
 	case 0x1019: lg_map_key_clear(KEY_PROG1);		break;
 	case 0x101a: lg_map_key_clear(KEY_PROG2);		break;
 	case 0x101b: lg_map_key_clear(KEY_PROG3);		break;
+	case 0x101c: lg_map_key_clear(KEY_CYCLEWINDOWS);	break;
 	case 0x101f: lg_map_key_clear(KEY_ZOOMIN);		break;
 	case 0x1020: lg_map_key_clear(KEY_ZOOMOUT);		break;
 	case 0x1021: lg_map_key_clear(KEY_ZOOMRESET);		break;
@@ -147,6 +151,11 @@ static int lg_wireless_mapping(struct hid_input *hi, struct hid_usage *usage,
 	case 0x1029: lg_map_key_clear(KEY_SHUFFLE);		break;
 	case 0x102a: lg_map_key_clear(KEY_BACK);		break;
 	case 0x102b: lg_map_key_clear(KEY_CYCLEWINDOWS);	break;
+	case 0x102d: lg_map_key_clear(KEY_WWW);			break;
+	/* The following two are 'Start/answer call' and 'End/reject call'
+	   on the MX3200 */
+	case 0x1031: lg_map_key_clear(KEY_OK);			break;
+	case 0x1032: lg_map_key_clear(KEY_CANCEL);		break;
 	case 0x1041: lg_map_key_clear(KEY_BATTERY);		break;
 	case 0x1042: lg_map_key_clear(KEY_WORDPROCESSOR);	break;
 	case 0x1043: lg_map_key_clear(KEY_SPREADSHEET);		break;

