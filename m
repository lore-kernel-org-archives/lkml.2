Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1KHRIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:08:25 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:50671 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1KHRIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:08:20 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] rtc-cmos: fix broken NVRAM bank 2 writing
Date: Tue, 8 Nov 2011 18:07:48 +0100
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111081807.52484.linux@rainbow-software.org>
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
