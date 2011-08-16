Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1HPDFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 23:05:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46525 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1HPDFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 23:05:03 -0400
Subject: [PATCH] ARM: S3C2443: Remove redundant s3c_register_clocks call
 for init_clocks
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 11:04:41 +0800
Message-ID: <1313463881.16359.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit af337f3e633a198034a99450416257ddf2307497
"ARM: S3C2443: Move parts of the clock code to common clock file",
the init_clocks array is moved to arch/arm/plat-s3c24xx/s3c2443-clock.c.
Now we call s3c_register_clocks for init_clocks in s3c2443_common_init_clocks.

Thus we can remove the empty init_clocks array here and remove the
redundant s3c_register_clocks call for init_clocks in s3c2443_init_clocks.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-s3c2443/clock.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-s3c2443/clock.c b/arch/arm/mach-s3c2443/clock.c
index a1a7176..4018dbe 100644
--- a/arch/arm/mach-s3c2443/clock.c
+++ b/arch/arm/mach-s3c2443/clock.c
@@ -305,9 +305,6 @@ static struct clk init_clocks_off[] = {
 	}
 };
 
-static struct clk init_clocks[] = {
-};
-
 /* clocks to add straight away */
 
 static struct clksrc_clk *clksrcs[] __initdata = {
@@ -345,10 +342,6 @@ void __init s3c2443_init_clocks(int xtal)
 	for (ptr = 0; ptr < ARRAY_SIZE(clksrcs); ptr++)
 		s3c_register_clksrc(clksrcs[ptr], 1);
 
-	/* register clocks from clock array */
-
-	s3c_register_clocks(init_clocks, ARRAY_SIZE(init_clocks));
-
 	/* We must be careful disabling the clocks we are not intending to
 	 * be using at boot time, as subsystems such as the LCD which do
 	 * their own DMA requests to the bus can cause the system to lockup
-- 
1.7.4.1



