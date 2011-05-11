Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1EKQNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:13:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1EKQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J+GFvA1FFSyfLOIWAp9iaewGbS1Mv9eahSjsQ0ox7G5kZ0SvwuCiiMozTL0lhqPY/w
         O9Zm4TI1VZRMNTq+KzmwJ+Gpq8xkzJnm3rt/O7r8i/pT6rwxUwiytlDIbWZKbz1AaCQK
         J/Q+3rEMt3J1nnk4Yf+idRO6u8mjnTcntmb54=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/12] staging: usbip: stub.h: reorganize
Date: Wed, 11 May 2011 01:54:22 -0700
Message-Id: <0c69d5dca8343610c9bdeee5f2f5823341f44e13.1305103213.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a few functions around for better organization and add missing
parameter names in function declarations.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub.h |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index a3adc2c..2cc596e 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -86,21 +86,22 @@ struct bus_id_priv {
 	char shutdown_busid;
 };
 
+/* stub_priv is allocated from stub_priv_cache */
 extern struct kmem_cache *stub_priv_cache;
 
-/* stub_tx.c */
-void stub_complete(struct urb *);
-int stub_tx_loop(void *data);
-
 /* stub_dev.c */
 extern struct usb_driver stub_driver;
 
-/* stub_rx.c */
-int stub_rx_loop(void *data);
-void stub_enqueue_ret_unlink(struct stub_device *, __u32, __u32);
-
 /* stub_main.c */
 struct bus_id_priv *get_busid_priv(const char *busid);
 int del_match_busid(char *busid);
-
 void stub_device_cleanup_urbs(struct stub_device *sdev);
+
+/* stub_rx.c */
+int stub_rx_loop(void *data);
+
+/* stub_tx.c */
+void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
+			     __u32 status);
+void stub_complete(struct urb *urb);
+int stub_tx_loop(void *data);
-- 
1.7.5.1

