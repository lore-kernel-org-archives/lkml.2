Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab0DOVBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:01:43 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:44936 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab0DOVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WKBJMktzo1F2ehn2Ct1gklWcG+xFjbwNkKewTPgj8YVrSNnqePQxVk0QN2wgOr5c86
         +VZE3x6ie4ZIREz1lUQrwQNYfe1Wwfdg9IsXUhJJ8BjXXcaWm7ULI6t7L9qisF0howI2
         ky8ouFouK1DpbrknYmKBSOtsHevaJjtkoNWVs=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: dream: smd: smd_qmi: fix code style issues
Date: Thu, 15 Apr 2010 17:01:37 -0400
Message-Id: <1271365297-26805-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some code style issues detected with the checkpatch.pl
script, like not necessary braces {} in some if and else statements and
include a KERN_INFO facility level in a printk() function.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/smd/smd_qmi.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dream/smd/smd_qmi.c b/drivers/staging/dream/smd/smd_qmi.c
index 9e9067f..76fce51 100644
--- a/drivers/staging/dream/smd/smd_qmi.c
+++ b/drivers/staging/dream/smd/smd_qmi.c
@@ -211,11 +211,10 @@ static int qmi_send(struct qmi_ctxt *ctxt, struct qmi_msg *msg)
 
 	qmi_dump_msg(msg, "send");
 
-	if (msg->service == QMI_CTL) {
+	if (msg->service == QMI_CTL)
 		hlen = QMUX_HEADER - 1;
-	} else {
+	else
 		hlen = QMUX_HEADER;
-	}
 
 	/* QMUX length is total header + total payload - IFC selector */
 	len = hlen + msg->size - 1;
@@ -248,11 +247,10 @@ static int qmi_send(struct qmi_ctxt *ctxt, struct qmi_msg *msg)
 	/* len + 1 takes the interface selector into account */
 	r = smd_write(ctxt->ch, msg->tlv - hlen, len + 1);
 
-	if (r != len) {
+	if (r != len)
 		return -1;
-	} else {
+	else
 		return 0;
-	}
 }
 
 static void qmi_process_ctl_msg(struct qmi_ctxt *ctxt, struct qmi_msg *msg)
@@ -376,7 +374,7 @@ static void qmi_process_broadcast_wds_msg(struct qmi_ctxt *ctxt,
 static void qmi_process_wds_msg(struct qmi_ctxt *ctxt,
 				struct qmi_msg *msg)
 {
-	printk("wds: %04x @ %02x\n", msg->type, msg->client_id);
+	printk(KERN_INFO "wds: %04x @ %02x\n", msg->type, msg->client_id);
 	if (msg->client_id == ctxt->wds_client_id) {
 		qmi_process_unicast_wds_msg(ctxt, msg);
 	} else if (msg->client_id == 0xff) {
@@ -504,9 +502,8 @@ static void qmi_notify(void *priv, unsigned event)
 	case SMD_EVENT_DATA: {
 		int sz;
 		sz = smd_cur_packet_size(ctxt->ch);
-		if ((sz > 0) && (sz <= smd_read_avail(ctxt->ch))) {
+		if ((sz > 0) && (sz <= smd_read_avail(ctxt->ch)))
 			queue_work(qmi_wq, &ctxt->read_work);
-		}
 		break;
 	}
 	case SMD_EVENT_OPEN:
-- 
1.5.6.3

