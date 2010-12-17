Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0LQQCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:02:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0LQQCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:02:34 -0500
Message-ID: <4D0B8994.8050509@redhat.com>
Date: Fri, 17 Dec 2010 17:02:28 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH 2/4] Staging: zram: round up the disk size provided by user
References: <4D0B88E5.4040005@redhat.com>
In-Reply-To: <4D0B88E5.4040005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently disksize_store() round down the disk size provided by user.
This is probably not what one would expect, so round up instead.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 zram_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index ad62db2..a70cc01 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -14,6 +14,7 @@
 
 #include <linux/device.h>
 #include <linux/genhd.h>
+#include <linux/mm.h>
 
 #include "zram_drv.h"
 
@@ -65,7 +66,7 @@ static ssize_t disksize_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	zram->disksize &= PAGE_MASK;
+	zram->disksize = PAGE_ALIGN(zram->disksize);
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 
 	return len;
