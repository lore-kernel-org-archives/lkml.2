Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1HHJhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:37:05 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:46473 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1HHJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:37:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: gadget: net2272 - Correct includes
Date: Mon,  8 Aug 2011 11:36:51 +0200
Message-Id: <1312796211-14938-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/irq.h> states:

 * Please do not include this file in generic code.  There is currently
 * no requirement for any architecture to implement anything held
 * within this file.

prefetch() and prefetchw() need <linux/prefetch.h> on m68k:

drivers/usb/gadget/net2272.c: In function ‘net2272_write_fifo’:
drivers/usb/gadget/net2272.c:468: error: implicit declaration of function ‘prefetch’
drivers/usb/gadget/net2272.c: In function ‘net2272_read_fifo’:
drivers/usb/gadget/net2272.c:574: error: implicit declaration of function ‘prefetchw’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/net2272.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 7c7b0e1..ab98ea9 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -27,13 +27,13 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
-#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/prefetch.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
-- 
1.7.0.4

