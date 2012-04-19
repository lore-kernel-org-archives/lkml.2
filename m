Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab2DSVbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:31:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab2DSVPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:15:38 -0400
Message-Id: <20120419210819.964332956@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Linus Walleij <linus.walleij@linaro.org>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Alessandro Rubini <rubini@unipv.it>
Subject: [ 15/68] drivers/rtc/rtc-pl031.c: enable clock on all ST variants
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 2f3972168353d355854d6381f1f360ce83b723e5 upstream.

The ST variants of the PL031 all require bit 26 in the control register
to be set before they work properly.  Discovered this when testing on
the Nomadik board where it would suprisingly just stand still.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Cc: Alessandro Rubini <rubini@unipv.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pl031.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -339,8 +339,7 @@ static int pl031_probe(struct amba_devic
 	dev_dbg(&adev->dev, "revision = 0x%01x\n", ldata->hw_revision);
 
 	/* Enable the clockwatch on ST Variants */
-	if ((ldata->hw_designer == AMBA_VENDOR_ST) &&
-	    (ldata->hw_revision > 1))
+	if (ldata->hw_designer == AMBA_VENDOR_ST)
 		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
 		       ldata->base + RTC_CR);
 


