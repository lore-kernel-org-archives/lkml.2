Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2KVTwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:52:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238Ab2KVTv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:56 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 42/46] staging: line6: drop unused pod atomic_flags field
Date: Thu, 22 Nov 2012 20:49:21 +0100
Message-Id: <1353613765-18690-43-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 11 -----------
 drivers/staging/line6/pod.h |  5 -----
 2 files changed, 16 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index e892b4a..f8257be 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -132,15 +132,6 @@ static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
 }
 
 /*
-	Handle SAVE button.
-*/
-static void pod_save_button_pressed(struct usb_line6_pod *pod, int type,
-				    int index)
-{
-	set_bit(POD_SAVE_PRESSED, &pod->atomic_flags);
-}
-
-/*
 	Process a completely received message.
 */
 void line6_pod_process_message(struct usb_line6_pod *pod)
@@ -166,7 +157,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		set_bit(POD_CHANNEL_DIRTY, &pod->atomic_flags);
 		line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
 					 LINE6_DUMP_CURRENT);
 		break;
@@ -196,7 +186,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 				break;
 
 			case POD_SYSEX_SAVE:
-				pod_save_button_pressed(pod, buf[6], buf[7]);
 				break;
 
 			case POD_SYSEX_STORE:
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 52534ca..843eb4e 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -84,11 +84,6 @@ struct usb_line6_pod {
 	int startup_progress;
 
 	/**
-		Some atomic flags.
-	*/
-	unsigned long atomic_flags;
-
-	/**
 		Serial number of device.
 	*/
 	int serial_number;
-- 
1.8.0

