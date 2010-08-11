Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0HKU1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:27:54 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48327 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755823Ab0HKU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:27:52 -0400
To: Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: [PATCH] matroxfb: fix incorrect use of memcpy_toio()
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 11 Aug 2010 22:27:42 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008112227.44990.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of memcpy_toio() in matroxfb that broke in 2.6.34 on x86.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc2/drivers/video/matrox/matroxfb_base.h	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/matrox/matroxfb_base.h	2010-08-03 18:13:46.000000000 +0200
@@ -151,13 +151,13 @@ static inline void mga_writel(vaddr_t va
 static inline void mga_memcpy_toio(vaddr_t va, const void* src, int len) {
 #if defined(__alpha__) || defined(__i386__) || defined(__x86_64__)
 	/*
-	 * memcpy_toio works for us if:
+	 * iowrite32_rep works for us if:
 	 *  (1) Copies data as 32bit quantities, not byte after byte,
 	 *  (2) Performs LE ordered stores, and
 	 *  (3) It copes with unaligned source (destination is guaranteed to be page
 	 *      aligned and length is guaranteed to be multiple of 4).
 	 */
-	memcpy_toio(va.vaddr, src, len);
+	iowrite32_rep(va.vaddr, src, len >> 2);
 #else
         u_int32_t __iomem* addr = va.vaddr;
 


-- 
Ondrej Zary
