Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1EKQfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:35:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36564 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab1EKQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EoYPqgvc5ay4ZANG2ybqDgI0lejKEySJN8pJd07EYgVf9UqxIQArRjOnzCcum6oayv
         u0Xy9G9tk/u7oqZgipEb5vBrf6LpCTyK+PFSLG/oP5lH6rmvZ+ouKrvB0ULbJR4eIgir
         0yktvK+xGt+NyXis5Crvu+xuirgTxhjP8brPg=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/12] staging: usbip: vhci.h: reorganize
Date: Wed, 11 May 2011 01:54:23 -0700
Message-Id: <cf3104ab782e4017b0953845c32bf9d4b002ad8e.1305103213.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split function declarations by source file.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index 691cf74..d5bc8e7 100644
--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -106,16 +106,18 @@ struct vhci_hcd {
 
 extern struct vhci_hcd *the_controller;
 extern struct attribute_group dev_attr_group;
+#define hardware (&the_controller->pdev.dev)
 
 /* vhci_hcd.c */
 void rh_port_connect(int rhport, enum usb_device_speed speed);
 void rh_port_disconnect(int rhport);
-int vhci_rx_loop(void *data);
-int vhci_tx_loop(void *data);
 
+/* vhci_rx.c */
 struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum);
+int vhci_rx_loop(void *data);
 
-#define hardware (&the_controller->pdev.dev)
+/* vhci_tx.c */
+int vhci_tx_loop(void *data);
 
 static inline struct vhci_device *port_to_vdev(__u32 port)
 {
-- 
1.7.5.1

