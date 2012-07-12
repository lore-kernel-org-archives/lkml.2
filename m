Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab2GLWgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375Ab2GLWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 011/187] ARM: SAMSUNG: Should check for IS_ERR(clk) instead of NULL
Date: Thu, 12 Jul 2012 15:32:47 -0700
Message-Id: <20120712191523.284312406@linuxfoundation.org>
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

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit a5d8f4765f0e92ef027492a8cb979c5b8d45f2c3 upstream.

On the error condition clk_get() returns ERR_PTR().

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-samsung/include/plat/watchdog-reset.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/plat-samsung/include/plat/watchdog-reset.h
+++ b/arch/arm/plat-samsung/include/plat/watchdog-reset.h
@@ -25,7 +25,7 @@ static inline void arch_wdt_reset(void)
 
 	__raw_writel(0, S3C2410_WTCON);	  /* disable watchdog, to be safe  */
 
-	if (s3c2410_wdtclk)
+	if (!IS_ERR(s3c2410_wdtclk))
 		clk_enable(s3c2410_wdtclk);
 
 	/* put initial values into count and data */


