Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0GaUzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 16:55:41 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50845 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756527Ab0GaUzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 16:55:39 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH 1/3] cyber2000fb: fix machine hang on module load
Date: Sat, 31 Jul 2010 22:55:27 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007312255.30729.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing two CyberPro 2000 based PCI cards on x86 and the machine always
hanged completely when the cyber2000fb module was loaded. It seems that the
card hangs when some registers are accessed too quickly after writing RAMDAC
control register. With this patch, both card work.

Add delay after RAMDAC control register write to prevent hangs on module load.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc2-orig/drivers/video/cyber2000fb.c	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-27 23:12:37.000000000 +0200
@@ -436,6 +436,8 @@ static void cyber2000fb_write_ramdac_ctr
 	cyber2000fb_writeb(i | 4, 0x3cf, cfb);
 	cyber2000fb_writeb(val, 0x3c6, cfb);
 	cyber2000fb_writeb(i, 0x3cf, cfb);
+	/* prevent card lock-up observed on x86 with CyberPro 2000 */
+	cyber2000fb_readb(0x3cf, cfb);
 }
 
 static void cyber2000fb_set_timing(struct cfb_info *cfb, struct par_info *hw)



-- 
Ondrej Zary
