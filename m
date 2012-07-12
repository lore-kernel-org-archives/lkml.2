Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2GLXvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:51:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360Ab2GLWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jose Miguel Goncalves <jose.goncalves@inov.pt>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 010/187] ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping
Date: Thu, 12 Jul 2012 15:32:46 -0700
Message-Id: <20120712191523.188600481@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Miguel Goncalves <jose.goncalves@inov.pt>

commit 3dca938656c7b0ff6b0717a5dde0f5f45e592be5 upstream.

While upgrading the kernel on a S3C2412 based board I've noted
that it was impossible to boot the board with a 2.6.32 or upper
kernel. I've tracked down the problem to the EBI virtual memory
mapping that is in conflict with the IO mapping definition in
arch/arm/mach-s3c24xx/s3c2412.c.

Signed-off-by: Jose Miguel Goncalves <jose.goncalves@inov.pt>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-samsung/include/plat/map-s3c.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/plat-samsung/include/plat/map-s3c.h
+++ b/arch/arm/plat-samsung/include/plat/map-s3c.h
@@ -22,7 +22,7 @@
 #define S3C24XX_VA_WATCHDOG	S3C_VA_WATCHDOG
 
 #define S3C2412_VA_SSMC		S3C_ADDR_CPU(0x00000000)
-#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00010000)
+#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00100000)
 
 #define S3C2410_PA_UART		(0x50000000)
 #define S3C24XX_PA_UART		S3C2410_PA_UART


