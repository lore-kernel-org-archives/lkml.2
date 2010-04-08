Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab0DHPJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:09:47 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:40219 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab0DHPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:09:46 -0400
Date: Thu, 8 Apr 2010 17:10:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, stable@kernel.org
Subject: [PATCH] Revert "memory-hotplug: add 0x prefix to HEX
 block_size_bytes"
Message-ID: <20100408151006.GB2446@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Revert ba168fc37dea145deeb8fa9e7e71c748d2e00d74 "memory-hotplug: add 0x prefix
to HEX block_size_bytes" since it changes the user space visible sysfs interface
/sys/devices/system/memory/block_size_bytes.
The change breaks existing user space applications which rely on the fact that
the output does not contain the "0x" prefix.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 4f4aa58..933442f 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -313,7 +313,7 @@ static ssize_t
 print_block_size(struct sysdev_class *class, struct sysdev_class_attribute *attr,
 		 char *buf)
 {
-	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
+	return sprintf(buf, "%lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
 static SYSDEV_CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
