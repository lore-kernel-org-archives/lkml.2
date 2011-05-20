Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab1ETALR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43485 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933416Ab1ETALN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:13 -0400
X-Sasl-enc: QwNNSSlRH6pksgzjupyYP88+afR0wAsMWTXgE9XMrgwn 1305850273
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/44] drivers: make device_type const
Date: Thu, 19 May 2011 17:10:23 -0700
Message-Id: <1305850262-9575-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>

The device_type structure does not contain data that changes
during usage and should be const. This allows devices to declare
the struct const.

I have patches to change all the subsystems, but need the infra
structure change first.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |    4 ++--
 include/linux/device.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 81b78ed..fb8130c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -400,7 +400,7 @@ static void device_remove_groups(struct device *dev,
 static int device_add_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
-	struct device_type *type = dev->type;
+	const struct device_type *type = dev->type;
 	int error;
 
 	if (class) {
@@ -440,7 +440,7 @@ static int device_add_attrs(struct device *dev)
 static void device_remove_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
-	struct device_type *type = dev->type;
+	const struct device_type *type = dev->type;
 
 	device_remove_groups(dev, dev->groups);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index d484051..350ceda 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -408,7 +408,7 @@ struct device {
 
 	struct kobject kobj;
 	const char		*init_name; /* initial name of the device */
-	struct device_type	*type;
+	const struct device_type *type;
 
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
-- 
1.7.4.2

