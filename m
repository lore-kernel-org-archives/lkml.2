Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2CTHBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:01:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60730 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2CTHBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:01:03 -0400
Message-ID: <1332226855.2434.1.camel@phoenix>
Subject: [PATCH] drivers/base: Use DEFINE_IDA for soc_ida
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 20 Mar 2012 15:00:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soc_ida actually is a struct ida.
This fixes below build warnings:

  CC      drivers/base/soc.o
drivers/base/soc.c: In function 'soc_device_register':
drivers/base/soc.c:126: warning: passing argument 1 of 'ida_pre_get' from incompatible pointer type
include/linux/idr.h:142: note: expected 'struct ida *' but argument is of type 'struct idr *'
drivers/base/soc.c:132: warning: passing argument 1 of 'ida_get_new' from incompatible pointer type
include/linux/idr.h:144: note: expected 'struct ida *' but argument is of type 'struct idr *'
drivers/base/soc.c:154: warning: passing argument 1 of 'ida_remove' from incompatible pointer type
include/linux/idr.h:145: note: expected 'struct ida *' but argument is of type 'struct idr *'
drivers/base/soc.c: In function 'soc_device_unregister':
drivers/base/soc.c:164: warning: passing argument 1 of 'ida_remove' from incompatible pointer type
include/linux/idr.h:145: note: expected 'struct ida *' but argument is of type 'struct idr *'
drivers/base/soc.c: In function 'soc_bus_unregister':
drivers/base/soc.c:179: warning: passing argument 1 of 'ida_destroy' from incompatible pointer type
include/linux/idr.h:146: note: expected 'struct ida *' but argument is of type 'struct idr *'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/base/soc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 05f1503..e57aec1 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -15,7 +15,7 @@
 #include <linux/sys_soc.h>
 #include <linux/err.h>
 
-static DEFINE_IDR(soc_ida);
+static DEFINE_IDA(soc_ida);
 static DEFINE_SPINLOCK(soc_lock);
 
 static ssize_t soc_info_get(struct device *dev,
-- 
1.7.5.4



