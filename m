Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab0GAVrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:47:08 -0400
Received: from kroah.org ([198.145.64.141]:32782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049Ab0GAVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:08 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:54 2010
Message-Id: <20100701174254.785483296@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Maurus Cuelenaere <mcuelenaere@gmail.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [099/200] rtc: s3c: initialize driver data before using it
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurus Cuelenaere <mcuelenaere@gmail.com>

commit e893de59a4982791368b3ce412bc67dd601a88a0 upstream.

s3c_rtc_setfreq() uses the platform driver data to derive struct rtc_device,
so make sure drvdata is set _before_ s3c_rtc_setfreq() is called.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Maurus Cuelenaere <mcuelenaere@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-s3c.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -457,8 +457,6 @@ static int __devinit s3c_rtc_probe(struc
  	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
 		 readb(s3c_rtc_base + S3C2410_RTCCON));
 
-	s3c_rtc_setfreq(&pdev->dev, 1);
-
 	device_init_wakeup(&pdev->dev, 1);
 
 	/* register RTC and exit */
@@ -475,6 +473,9 @@ static int __devinit s3c_rtc_probe(struc
 	rtc->max_user_freq = 128;
 
 	platform_set_drvdata(pdev, rtc);
+
+	s3c_rtc_setfreq(&pdev->dev, 1);
+
 	return 0;
 
  err_nortc:


