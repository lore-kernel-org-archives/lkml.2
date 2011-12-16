Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab1LPTse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:48:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759843Ab1LPTsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:55 2011
Message-Id: <20111216194555.756710902@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonghwan Choi <jhbird.choi@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [11/53] drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit 2dbcd05f1e9e0932833d16dab1696176fc164b07 upstream.

If an error occurs after the clock is enabled, the enable/disable state
can become unbalanced.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -202,7 +202,6 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	clk_enable(rtc_clk);
 	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -214,6 +213,7 @@ static int s3c_rtc_settime(struct device
 		return -EINVAL;
 	}
 
+	clk_enable(rtc_clk);
 	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
 	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);


