Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1DEPBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:44467 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab1DEO7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:38 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 25/34] usb/ftdi-elan: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:12 +0200
Message-Id: <1302015561-21047-26-git-send-email-mmarek@suse.cz>
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
 drivers/usb/misc/ftdi-elan.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 7839c98..b16bd3c 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2889,8 +2889,7 @@ static struct usb_driver ftdi_elan_driver = {
 static int __init ftdi_elan_init(void)
 {
         int result;
-        printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
-	       __TIME__, __DATE__);
+        printk(KERN_INFO "driver %s\n", ftdi_elan_driver.name);
         mutex_init(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
-- 
1.7.4.1

