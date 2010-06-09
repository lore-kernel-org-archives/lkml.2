Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab0FISyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:54:23 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202Ab0FISyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:18 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183625.830071655@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] floppy: cmos attribute should be static
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-cmos-local.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by sparse, cmos attribute is local.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/block/floppy.c	2010-06-08 23:08:23.326715957 -0700
+++ b/drivers/block/floppy.c	2010-06-08 23:08:29.136934127 -0700
@@ -4127,7 +4127,7 @@ static ssize_t floppy_cmos_show(struct d
 	return sprintf(buf, "%X\n", UDP->cmos);
 }
 
-DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
+static DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
 
 static void floppy_device_release(struct device *dev)
 {


