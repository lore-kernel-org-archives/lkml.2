Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab2IKLet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:34:49 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:43407 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759238Ab2IKLeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8CAIAhT1BbdWObgWdsb2JhbABFhUBHtUkiAQEWJieCIQEFIwQLAUYQJQImAgJXBhOIFKhokzeBIY8DgRIDlV2TBQ
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505383"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 14/20] Staging: ipack/devices/ipoctal: change exiting procedure
Date: Tue, 11 Sep 2012 13:35:07 +0200
Message-Id: <1347363313-17094-15-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipoctal devices can be uninstalled from the ipack_driver_unregister()
call as the device model calles the bus's .remove() function for each device
registered by the driver and it will execute the .remove() function of the
ipoctal driver.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index c94a9df..272832f 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -853,11 +853,6 @@ static int __init ipoctal_init(void)
 
 static void __exit ipoctal_exit(void)
 {
-	struct ipoctal *p, *next;
-
-	list_for_each_entry_safe(p, next, &ipoctal_list, list)
-		p->dev->bus->ops->remove_device(p->dev);
-
 	ipack_driver_unregister(&driver);
 }
 
-- 
1.7.10.4

