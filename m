Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1DLTfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:35:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:40351 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab1DLTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:35:27 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/5] usb/gadget: rename bos to get_bos_descr in composite
Date: Tue, 12 Apr 2011 21:34:53 +0200
Message-Id: <1302636896-12717-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/composite.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index a94b7b7..d12e75a4 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -604,7 +604,7 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
  * descriptor and its device capabilities descriptors. The BOS
  * descriptor should be supported by a SuperSpeed device.
  */
-static int bos(struct usb_composite_dev *cdev)
+static int get_bos_descr(struct usb_composite_dev *cdev)
 {
 	struct usb_ext_cap_descriptor	*usb_ext;
 	struct usb_ss_cap_descriptor	*ss_cap;
@@ -1194,7 +1194,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			break;
 		case USB_DT_BOS:
 			if (gadget_is_superspeed(gadget)) {
-				value = bos(cdev);
+				value = get_bos_descr(cdev);
 				value = min(w_length, (u16) value);
 			}
 			break;
-- 
1.7.4

