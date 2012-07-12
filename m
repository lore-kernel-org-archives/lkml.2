Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162456Ab2GLWsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:48:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162373Ab2GLWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:46:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Devendra Naga <devendra.aaru@gmail.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [ 181/187] drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()
Date: Thu, 12 Jul 2012 15:35:37 -0700
Message-Id: <20120712191540.072466555@linuxfoundation.org>
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

From: Devendra Naga <devendra.aaru@gmail.com>

commit 2a643893e50fde71d7ba84b5592ec61b467b9ab6 upstream.

`config' is freed and is then used in the rtc_device_unregister() call,
causing a kernel panic.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Reviewed-by: Viresh Kumar <viresh.linux@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-spear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -457,12 +457,12 @@ static int __devexit spear_rtc_remove(st
 	clk_disable(config->clk);
 	clk_put(config->clk);
 	iounmap(config->ioaddr);
-	kfree(config);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(config->rtc);
+	kfree(config);
 
 	return 0;
 }


