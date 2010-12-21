Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0LUMkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:40:17 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:38726 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LUMkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:40:15 -0500
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/2] docs/sysfs: show() methods should use scnprintf().
Date: Tue, 21 Dec 2010 13:09:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.6-scst; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211309.47482.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since snprintf() may return a value that exceeds its second argument,
show() methods should use scnprintf() instead of snprintf(). This patch
updates the example in the sysfs documentation accordingly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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
1.7.1

