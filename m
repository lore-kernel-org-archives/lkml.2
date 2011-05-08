Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1EHDns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 23:43:48 -0400
Received: from que11.charter.net ([209.225.8.21]:53043 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab1EHDnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 23:43:47 -0400
X-Authority-Analysis: v=1.1 cv=gc/P+WrVRtedj6PMvZ6mDc68C/6j+WqWb169mGdAQGo=
 c=1 sm=1 a=Gql2hI2DjhoA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=P-uzt6Qb_GO9aR6tmGwA:9 a=p-m43PMWjNqU6fa-06sA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <gregory.dietsche@cuw.edu>
To: gregkh@suse.de
Cc: mfuzzey@gmail.com, tom.leiming@gmail.com, ak@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <gregory.dietsche@cuw.edu>
Subject: [PATCH] usb: fix warning in usbtest module
Date: Sat,  7 May 2011 22:27:44 -0500
Message-Id: <1304825264-26853-1-git-send-email-gregory.dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On amd64 unsigned is not as wide as pointer and this causes
a compiler warning. Switching to uintptr_t fixes the problem
in an arch independent manner.

Signed-off-by: Greg Dietsche <gregory.dietsche@cuw.edu>
---
 drivers/usb/misc/usbtest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 388cc12..c6b2082 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -268,9 +268,9 @@ static inline void simple_fill_buf(struct urb *urb)
 	}
 }
 
-static inline unsigned buffer_offset(void *buf)
+static inline uintptr_t buffer_offset(void *buf)
 {
-	return (unsigned)buf & (ARCH_KMALLOC_MINALIGN - 1);
+	return (uintptr_t)buf & (ARCH_KMALLOC_MINALIGN - 1);
 }
 
 static int check_guard_bytes(struct usbtest_dev *tdev, struct urb *urb)
@@ -329,7 +329,7 @@ static int simple_check_buf(struct usbtest_dev *tdev, struct urb *urb)
 
 static void simple_free_urb(struct urb *urb)
 {
-	unsigned offset = buffer_offset(urb->transfer_buffer);
+	uintptr_t offset = buffer_offset(urb->transfer_buffer);
 
 	if (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)
 		usb_free_coherent(
-- 
1.7.2.5

