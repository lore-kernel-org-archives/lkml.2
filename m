Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2F0T2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:28:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54868 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2F0T1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:06 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 3/9] staging: line6: changed interface of line6_pod_transmit_parameter()
Date: Wed, 27 Jun 2012 21:25:57 +0200
Message-Id: <1340825163-32568-4-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjusted interface of line6_pod_transmit_parameter() to take changes of
line6_transmit_parameter() into account

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pod.c |    2 +-
 drivers/staging/line6/pod.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 4dadc57..8667aaf 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -419,7 +419,7 @@ static void pod_send_channel(struct usb_line6_pod *pod, int value)
 	Transmit PODxt Pro control parameter.
 */
 void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
-				  int value)
+				  u8 value)
 {
 	if (line6_transmit_parameter(&pod->line6, param, value) == 0)
 		pod_store_parameter(pod, param, value);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 18b9d08..47e0d1a 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -200,6 +200,6 @@ extern void line6_pod_midi_postprocess(struct usb_line6_pod *pod,
 				       unsigned char *data, int length);
 extern void line6_pod_process_message(struct usb_line6_pod *pod);
 extern void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
-					 int value);
+					 u8 value);
 
 #endif
-- 
1.7.7.6

