Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab0ETVKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:10:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26031 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0ETVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:09:51 -0400
Date: Thu, 20 May 2010 14:08:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, InKi Dae <inki.dae@samsung.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH -mmotm] backlight: fix s6e63m0 device attr function return
 types
Message-Id: <20100520140835.b06ece52.randy.dunlap@oracle.com>
In-Reply-To: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4BF5A4F0.00CB:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix device attribute functions return types.

drivers/video/backlight/s6e63m0.c:718: warning: initialization from incompatible pointer type
drivers/video/backlight/s6e63m0.c:718: warning: initialization from incompatible pointer type
drivers/video/backlight/s6e63m0.c:732: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: InKi Dae  <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/s6e63m0.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- mmotm-2010-0519-1612.orig/drivers/video/backlight/s6e63m0.c
+++ mmotm-2010-0519-1612/drivers/video/backlight/s6e63m0.c
@@ -654,7 +654,7 @@ static const struct backlight_ops s6e63m
 	.update_status = s6e63m0_set_brightness,
 };
 
-static int s6e63m0_sysfs_show_gamma_mode(struct device *dev,
+static ssize_t s6e63m0_sysfs_show_gamma_mode(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct s6e63m0 *lcd = dev_get_drvdata(dev);
@@ -681,7 +681,7 @@ static int s6e63m0_sysfs_show_gamma_mode
 	return strlen(buf);
 }
 
-static int s6e63m0_sysfs_store_gamma_mode(struct device *dev,
+static ssize_t s6e63m0_sysfs_store_gamma_mode(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
@@ -718,7 +718,7 @@ static int s6e63m0_sysfs_store_gamma_mod
 static DEVICE_ATTR(gamma_mode, 0644,
 		s6e63m0_sysfs_show_gamma_mode, s6e63m0_sysfs_store_gamma_mode);
 
-static int s6e63m0_sysfs_show_gamma_table(struct device *dev,
+static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct s6e63m0 *lcd = dev_get_drvdata(dev);
