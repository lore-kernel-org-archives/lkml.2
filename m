Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0FIS4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:56:01 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204Ab0FISyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:18 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183624.667690959@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:50 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] floppy: initialize debug jiffies offset
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-debugt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set debug jiffies offset at initialization. Avoids wierd values
showing up if debugging enabled.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/block/floppy.c	2010-06-08 23:06:35.142657727 -0700
+++ b/drivers/block/floppy.c	2010-06-08 23:07:59.205810459 -0700
@@ -4175,6 +4175,9 @@ static int __init floppy_init(void)
 	int i, unit, drive;
 	int err, dr;
 
+	set_debugt();
+	interruptjiffies = resultjiffies = jiffies;
+
 #if defined(CONFIG_PPC)
 	if (check_legacy_ioport(FDC1))
 		return -ENODEV;


