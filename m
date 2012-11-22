Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab2KVT5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:57:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030259Ab2KVTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:51 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 39/46] staging: line6: drop amp/effects dump request triggers
Date: Thu, 22 Nov 2012 20:49:18 +0100
Message-Id: <1353613765-18690-40-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the driver no longer needs to keep state of device parameters it
is no longer necessary to refresh state when messages that affect other
parameters are sent.  Drop the code to trigger a dump when amp/effects
are changed.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 157ef68..aa3a547 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -174,12 +174,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 		/* intentionally no break here! */
 
 	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
-		if ((buf[1] == POD_amp_model_setup) ||
-		    (buf[1] == POD_effect_setup))
-			/* these also affect other settings */
-			line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
-						 LINE6_DUMP_CURRENT);
-
 		break;
 
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
@@ -288,9 +282,6 @@ void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
 {
 	if (line6_transmit_parameter(&pod->line6, param, value) == 0)
 		pod_store_parameter(pod, param, value);
-
-	if ((param == POD_amp_model_setup) || (param == POD_effect_setup))	/* these also affect other settings */
-		line6_invalidate_current(&pod->dumpreq);
 }
 
 /*
-- 
1.8.0

