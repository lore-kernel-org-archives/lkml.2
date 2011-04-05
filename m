Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1DEPBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab1DEO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:36 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 24/34] usb/u132-hcd: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:11 +0200
Message-Id: <1302015561-21047-25-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Tony Olech <tony.olech@elandigitalsystems.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/usb/host/u132-hcd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index fab7649..dc6dd22 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3229,8 +3229,7 @@ static int __init u132_hcd_init(void)
 	mutex_init(&u132_module_lock);
 	if (usb_disabled())
 		return -ENODEV;
-	printk(KERN_INFO "driver %s built at %s on %s\n", hcd_name, __TIME__,
-		__DATE__);
+	printk(KERN_INFO "driver %s\n", hcd_name);
 	workqueue = create_singlethread_workqueue("u132");
 	retval = platform_driver_register(&u132_platform_driver);
 	return retval;
-- 
1.7.4.1

