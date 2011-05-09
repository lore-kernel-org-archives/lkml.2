Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1EIDwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 23:52:09 -0400
Received: from mta21.charter.net ([216.33.127.81]:63463 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1EIDwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 23:52:06 -0400
X-Greylist: delayed 87767 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 May 2011 23:52:06 EDT
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=G_DfZ8gQysUA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=_R1c4qHVM5-1kNPhj4EA:9 a=NabyN_p_6vFTsNmlzEYA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: gregkh@suse.de
Cc: mfuzzey@gmail.com, tom.leiming@gmail.com, ak@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] usb: fix warning in usbtest module v2
Date: Sun,  8 May 2011 22:51:43 -0500
Message-Id: <1304913103-3086-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110508225847.GA12750@suse.de>
References: <20110508225847.GA12750@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On amd64 unsigned is not as wide as pointer and this causes a compiler 
warning. Switching to unsigned long corrects the problem.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/usb/misc/usbtest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 388cc12..a5b505a 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -268,9 +268,9 @@ static inline void simple_fill_buf(struct urb *urb)
 	}
 }
 
-static inline unsigned buffer_offset(void *buf)
+static inline unsigned long buffer_offset(void *buf)
 {
-	return (unsigned)buf & (ARCH_KMALLOC_MINALIGN - 1);
+	return (unsigned long)buf & (ARCH_KMALLOC_MINALIGN - 1);
 }
 
 static int check_guard_bytes(struct usbtest_dev *tdev, struct urb *urb)
@@ -329,7 +329,7 @@ static int simple_check_buf(struct usbtest_dev *tdev, struct urb *urb)
 
 static void simple_free_urb(struct urb *urb)
 {
-	unsigned offset = buffer_offset(urb->transfer_buffer);
+	unsigned long offset = buffer_offset(urb->transfer_buffer);
 
 	if (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)
 		usb_free_coherent(
-- 
1.7.2.5

