Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab1GKSj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab1GKSj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:39:27 -0400
Date: Mon, 11 Jul 2011 14:39:20 -0400
From: Dave Jones <davej@redhat.com>
To: lirc@bartelmus.de, Linux Kernel <linux-kernel@vger.kernel.org>,
        greg@kroah.com
Subject: staging/lirc_parallel: fix panic on rmmod
Message-ID: <20110711183920.GA31024@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, lirc@bartelmus.de,
	Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lirc_parallel seems to leave a bunch of stuff around after rmmod.
Without the patch below modprobe ; rmmod ; modprobe will cause a panic.

There are still some remaining problems, (double registration of sysfs files)
but this patch is at least a start to survive the panic.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/staging/lirc/lirc_parallel.c b/drivers/staging/lirc/lirc_parallel.c
index 50724c4..70db1d1 100644
--- a/drivers/staging/lirc/lirc_parallel.c
+++ b/drivers/staging/lirc/lirc_parallel.c
@@ -730,6 +730,9 @@ static void __exit lirc_parallel_exit(void)
 {
 	parport_unregister_device(ppdevice);
 	lirc_unregister_driver(driver.minor);
+
+	platform_device_unregister(lirc_parallel_dev);
+	platform_driver_unregister(&lirc_parallel_driver);
 }
 
 module_init(lirc_parallel_init);

