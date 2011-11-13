Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1KMWVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 17:21:07 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:50490 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab1KMWVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 17:21:05 -0500
To: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] rtc-cmos: fix broken NVRAM bank 2 writing
Cc: rtc-linux@googlegroups.com,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Sun, 13 Nov 2011 23:20:31 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111132320.34420.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix writing to NVRAM bank 2 in rtc-cmos driver. It never worked since its
introduction in 2.6.28 because of a typo.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-3.1-orig/drivers/rtc/rtc-cmos.c	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1/drivers/rtc/rtc-cmos.c	2011-11-08 17:43:29.000000000 +0100
@@ -164,7 +164,7 @@ static inline unsigned char cmos_read_ba
 static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
 {
 	outb(addr, RTC_PORT(2));
-	outb(val, RTC_PORT(2));
+	outb(val, RTC_PORT(3));
 }
 
 #else


-- 
Ondrej Zary
