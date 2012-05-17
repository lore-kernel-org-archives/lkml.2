Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab2EQCc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:32:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:3058 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760881Ab2EQCcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:32:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153859356"
Date: Thu, 17 May 2012 10:32:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] radio: fix build error in rtrack2_alloc()
Message-ID: <20120517023222.GA7788@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error

drivers/media/radio/radio-rtrack2.c: In function ‘rtrack2_alloc’:                                                                         
drivers/media/radio/radio-rtrack2.c:46:2: error: implicit declaration of function ‘kzalloc’

CC: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/media/radio/radio-rtrack2.c |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/drivers/media/radio/radio-rtrack2.c	2012-04-06 13:23:52.548862660 +0800
+++ linux/drivers/media/radio/radio-rtrack2.c	2012-05-17 10:18:20.679495193 +0800
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/slab.h>		/* kzalloc			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include "radio-isa.h"
