Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab1FKAbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 20:31:41 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:34513 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab1FKAbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 20:31:40 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1307752277!25404254!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fb.h: ARM uses __raw_{read/write}
Date: Fri, 10 Jun 2011 17:31:08 -0700
User-Agent: KMail/1.9.9
CC: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101731.08578.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM provides __raw_{read/write}* functions for memory access. These
should be used instead of the default '(*(volatile' stuff to make sure the
memory accesses are typesafe (void __iomem *).

This also fixes a number of sparse warning like:

  warning: cast removes address space of expression

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <linux@arm.linux.org.uk>

---

diff --git a/include/linux/fb.h b/include/linux/fb.h
index 6a82748..a040e92e 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -937,7 +937,7 @@ static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
 #define fb_memcpy_fromfb sbus_memcpy_fromio
 #define fb_memcpy_tofb sbus_memcpy_toio
 
-#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__) || defined(__bfin__)
+#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__) || defined(__bfin__) || defined(__arm__)
 
 #define fb_readb __raw_readb
 #define fb_readw __raw_readw
