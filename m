Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0G3SkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:40:08 -0400
Received: from kroah.org ([198.145.64.141]:57880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759739Ab0G3RyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:35 2010
Message-Id: <20100730175135.212617767@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [018/205] hwmon: (i5k_amb) Fix sysfs attribute for lockdep
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 0e6c7870856c7fb4ee054d28ac253b2d3d0c7e36 upstream.

i5k_amb.ko uses dynamically allocated memory (by kmalloc) for
attributes passed to sysfs. So, sysfs_attr_init() should be called
for working happy with lockdep.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/i5k_amb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -289,6 +289,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
 			iattr->s_attr.dev_attr.show = show_label;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -303,6 +304,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
 			iattr->s_attr.dev_attr.show = show_amb_temp;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -318,6 +320,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.show = show_amb_min;
 			iattr->s_attr.dev_attr.store = store_amb_min;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -333,6 +336,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.show = show_amb_mid;
 			iattr->s_attr.dev_attr.store = store_amb_mid;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -348,6 +352,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.show = show_amb_max;
 			iattr->s_attr.dev_attr.store = store_amb_max;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)
@@ -362,6 +367,7 @@ static int __devinit i5k_amb_hwmon_init(
 			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
 			iattr->s_attr.dev_attr.show = show_amb_alarm;
 			iattr->s_attr.index = k;
+			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
 			res = device_create_file(&pdev->dev,
 						 &iattr->s_attr.dev_attr);
 			if (res)


