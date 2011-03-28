Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1C1QM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:12:57 -0400
Received: from mail.vyatta.com ([76.74.103.46]:48814 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1C1QMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:12:55 -0400
Date: Mon, 28 Mar 2011 09:12:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: make device_type const
Message-ID: <20110328091252.75a22583@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device_type structure does not contain data that changes
during usage and should be const. This allows devices to declare
the struct const.

I have patches to change all the subsystems, but need the infra
structure change first.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
 drivers/base/core.c    |    4 ++--
 include/linux/device.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/base/core.c	2011-03-28 08:48:43.380836767 -0700
+++ b/drivers/base/core.c	2011-03-28 08:48:46.228868558 -0700
@@ -400,7 +400,7 @@ static void device_remove_groups(struct
 static int device_add_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
-	struct device_type *type = dev->type;
+	const struct device_type *type = dev->type;
 	int error;
 
 	if (class) {
@@ -440,7 +440,7 @@ static int device_add_attrs(struct devic
 static void device_remove_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
-	struct device_type *type = dev->type;
+	const struct device_type *type = dev->type;
 
 	device_remove_groups(dev, dev->groups);
 
--- a/include/linux/device.h	2011-03-28 08:48:43.392836902 -0700
+++ b/include/linux/device.h	2011-03-28 08:48:46.228868558 -0700
@@ -408,7 +408,7 @@ struct device {
 
 	struct kobject kobj;
 	const char		*init_name; /* initial name of the device */
-	struct device_type	*type;
+	const struct device_type *type;
 
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
