Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258Ab2KVTvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030227Ab2KVTvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:33 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 28/46] staging: line6: drop tuner param filtering
Date: Thu, 22 Nov 2012 20:49:07 +0100
Message-Id: <1353613765-18690-29-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pod_set_system_param_int() helper function is only used to set the
monitor level.  Previously it was also used to control the tuner and has
special checks.  These checks can now be dropped, along with the tuner
constants.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index db9c905..157ef68 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -40,10 +40,6 @@ enum {
 
 enum {
 	POD_monitor_level  = 0x04,
-	POD_tuner_mute     = 0x13,
-	POD_tuner_freq     = 0x15,
-	POD_tuner_note     = 0x16,
-	POD_tuner_pitch    = 0x17,
 	POD_system_invalid = 0x10000
 };
 
@@ -298,19 +294,7 @@ void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
 }
 
 /*
-	Identify system parameters related to the tuner.
-*/
-static bool pod_is_tuner(int code)
-{
-	return
-	    (code == POD_tuner_mute) ||
-	    (code == POD_tuner_freq) ||
-	    (code == POD_tuner_note) || (code == POD_tuner_pitch);
-}
-
-/*
 	Send system parameter (from integer).
-	@param tuner non-zero, if code refers to a tuner parameter
 */
 static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
 				    int code)
@@ -318,11 +302,6 @@ static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
 	char *sysex;
 	static const int size = 5;
 
-	if (((pod->prog_data.control[POD_tuner] & 0x40) == 0)
-	    && pod_is_tuner(code))
-		return -EINVAL;
-
-	/* send value to tuner: */
 	sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_SYSTEM, size);
 	if (!sysex)
 		return -ENOMEM;
-- 
1.8.0

