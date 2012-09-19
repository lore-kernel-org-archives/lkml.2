Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab2ISTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:09:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49148 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2ISTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:09:57 -0400
Date: Wed, 19 Sep 2012 21:09:52 +0200
From: Lee Jones <ljkenny@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [rtc-linux] [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device
 Tree enablement
Message-ID: <20120919190952.GB2753@gmail.com>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
 <1344527828-6283-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
 <20120831110818.GA5962@gmail.com>
 <CACRpkdat3zj_47r7ENz7Qv3N8cNOSKDV+k5em9DjOhkNycy9gQ@mail.gmail.com>
 <CACRpkdbXwLXoWL+PS-wJ9cbztC-jWhyc=vr+98ffg70f6coaiQ@mail.gmail.com>
 <20120919160302.GN28670@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120919160302.GN28670@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Sam: do you agree?
> I'd love to see the patch first :)
> Could you please bounce it to me ?

I'll help. :)

Author: Lee Jones <lee.jones@linaro.org>
Date:   Thu Aug 9 13:28:19 2012 +0100

    drivers/rtc/rtc-ab8500.c: Revoke Device Tree enablement
    
    All AB8500 devices are now registered via MFD core, so Device Tree
    capability is no longer required for probing. Here we pull the DT
    match table to ensure we're no longer probed during Device Tree
    start-up.
    
    CC: Alessandro Zummo <a.zummo@towertech.it>
    CC: rtc-linux@googlegroups.com
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index bf3c2f6..2e5970f 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -462,16 +462,10 @@ static int __devexit ab8500_rtc_remove(struct platform_device *pdev)
   return 0;
 }
 
-static const struct of_device_id ab8500_rtc_match[] = {
-	{ .compatible = "stericsson,ab8500-rtc", },
-	{}
-};
-
 static struct platform_driver ab8500_rtc_driver = {
 	.driver = {
 		.name = "ab8500-rtc",
 		      .owner = THIS_MODULE,
-		      	     .of_match_table = ab8500_rtc_match,
 			     },
 			     .probe	= ab8500_rtc_probe,
 			     .remove = __devexit_p(ab8500_rtc_remove),

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
