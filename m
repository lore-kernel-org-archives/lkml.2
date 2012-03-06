Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320Ab2CFCt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 21:49:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48912 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241Ab2CFCt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 21:49:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.232.102 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH][linux-next][RESEND] usb/gadget/pch_udc: Fix compile error
Date: Tue,  6 Mar 2012 11:49:04 +0900
Message-Id: <1331002144-30113-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20120305164308.GE2459@kroah.com>
References: <20120305164308.GE2459@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg's e-mail address was old. So, I resend it.

Though I've tested this patch,
http://marc.info/?l=linux-usb&m=132825305710285&w=2,
I've received the following reports.
http://kisskb.ellerman.id.au/kisskb/buildresult/5771890/
http://kisskb.ellerman.id.au/kisskb/buildresult/5771905/

So, I added header file for these symbols.
Using this patch, this compile error must be disappeared.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/usb/gadget/pch_udc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 350dbcd..6530706 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -16,6 +16,7 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/gpio.h>
+#include <linux/irq.h>
 
 /* GPIO port for VBUS detecting */
 static int vbus_gpio_port = -1;		/* GPIO port number (-1:Not used) */
-- 
1.7.7.6

