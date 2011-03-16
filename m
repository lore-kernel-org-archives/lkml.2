Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1CPVLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:11:50 -0400
Received: from kroah.org ([198.145.64.141]:42522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1CPVLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Tejun Heo <tj@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/50] docs/sysfs: show() methods should use scnprintf().
Date: Wed, 16 Mar 2011 14:10:41 -0700
Message-Id: <1300309888-5028-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Since snprintf() may return a value that exceeds its second argument,
show() methods should use scnprintf() instead of snprintf(). This patch
updates the example in the sysfs documentation accordingly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 2ed95f9..f806e50 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -210,9 +210,9 @@ Other notes:
   is 4096. 
 
 - show() methods should return the number of bytes printed into the
-  buffer. This is the return value of snprintf().
+  buffer. This is the return value of scnprintf().
 
-- show() should always use snprintf(). 
+- show() should always use scnprintf().
 
 - store() should return the number of bytes used from the buffer. If the
   entire buffer has been used, just return the count argument.
@@ -231,7 +231,7 @@ A very simple (and naive) implementation of a device attribute is:
 static ssize_t show_name(struct device *dev, struct device_attribute *attr,
                          char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", dev->name);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", dev->name);
 }
 
 static ssize_t store_name(struct device *dev, struct device_attribute *attr,
-- 
1.7.4.1

