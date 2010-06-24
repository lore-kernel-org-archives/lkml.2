Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab0FXD1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:27:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63278 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0FXD1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:27:42 -0400
Date: Wed, 23 Jun 2010 20:27:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Nitin Gupta <ngupta@vflare.org>,
       devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: [PATCH -next] zram: fix build errors, depends on BLOCK
Message-Id: <20100623202709.4ecb798c.randy.dunlap@oracle.com>
In-Reply-To: <20100623154531.0a4b02e1.sfr@canb.auug.org.au>
References: <20100623154531.0a4b02e1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4C22D0A5.0059:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 49 zram build errors in one swoop.  Examples:

drivers/staging/zram/zram_drv.c:225: error: dereferencing pointer to incomplete type
drivers/staging/zram/zram_drv.c:226: error: implicit declaration of function 'bio_for_each_segment'
drivers/staging/zram/zram_drv.c:226: error: expected ';' before '{' token
drivers/staging/zram/zram_drv.c:281: error: implicit declaration of function 'bio_endio'
drivers/staging/zram/zram_drv.c:285: error: implicit declaration of function 'bio_io_error'
drivers/staging/zram/zram_drv.c:545: error: implicit declaration of function 'set_capacity'
drivers/staging/zram/zram_drv.c:548: error: implicit declaration of function 'queue_flag_set_unlocked'
drivers/staging/zram/zram_drv.c:548: error: 'QUEUE_FLAG_NONROT' undeclared (first use in this function)
drivers/staging/zram/zram_drv.c:548: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	devel@driverdev.osuosl.org
Cc:	Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/Kconfig    |    1 +
 drivers/staging/zram/zram_drv.c |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20100623.orig/drivers/staging/zram/Kconfig
+++ linux-next-20100623/drivers/staging/zram/Kconfig
@@ -1,5 +1,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
+	depends on BLOCK
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
--- linux-next-20100623.orig/drivers/staging/zram/zram_drv.c
+++ linux-next-20100623/drivers/staging/zram/zram_drv.c
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/bio.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
