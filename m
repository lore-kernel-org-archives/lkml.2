Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2GASWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47016 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab2GASQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:40 -0400
Message-Id: <20120701172010.804545036@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 29/48] ARM: SAMSUNG: Should check for IS_ERR(clk) instead of NULL
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit a5d8f4765f0e92ef027492a8cb979c5b8d45f2c3 upstream.

On the error condition clk_get() returns ERR_PTR().

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-samsung/include/plat/watchdog-reset.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-samsung/include/plat/watchdog-reset.h b/arch/arm/plat-samsung/include/plat/watchdog-reset.h
index f19aff1..bc4db9b 100644
--- a/arch/arm/plat-samsung/include/plat/watchdog-reset.h
+++ b/arch/arm/plat-samsung/include/plat/watchdog-reset.h
@@ -25,7 +25,7 @@ static inline void arch_wdt_reset(void)
 
 	__raw_writel(0, S3C2410_WTCON);	  /* disable watchdog, to be safe  */
 
-	if (s3c2410_wdtclk)
+	if (!IS_ERR(s3c2410_wdtclk))
 		clk_enable(s3c2410_wdtclk);
 
 	/* put initial values into count and data */


