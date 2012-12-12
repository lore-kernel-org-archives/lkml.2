Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2LLTaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:30:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42838 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754076Ab2LLTae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:30:34 -0500
Message-ID: <1355340633.8538.1.camel@joe-AO722>
Subject: [TRIVIAL PATCH V2 24/26] Documentation: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Harry Wei <harryxiyou@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@zh-kernel.org
Date: Wed, 12 Dec 2012 11:30:33 -0800
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving and set a good example for Documentation too.

Signed-off-by: Joe Perches <joe@perches.com>
---
V2: Fix commit subject line (Thanks to Marc Gauthier <marc@tensilica.com>)

 Documentation/filesystems/sysfs.txt       |    4 ++--
 Documentation/zh_CN/filesystems/sysfs.txt |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index a6619b7..9cc7742 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -154,8 +154,8 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
         if (dev_attr->show)
                 ret = dev_attr->show(dev, dev_attr, buf);
         if (ret >= (ssize_t)PAGE_SIZE) {
-                print_symbol("dev_attr_show: %s returned bad count\n",
-                                (unsigned long)dev_attr->show);
+                printk("dev_attr_show: %pSR returned bad count\n",
+                       dev_attr->show);
         }
         return ret;
 }
diff --git a/Documentation/zh_CN/filesystems/sysfs.txt b/Documentation/zh_CN/filesystems/sysfs.txt
index e230eaa..42fc023 100644
--- a/Documentation/zh_CN/filesystems/sysfs.txt
+++ b/Documentation/zh_CN/filesystems/sysfs.txt
@@ -167,8 +167,8 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
         if (dev_attr->show)
                 ret = dev_attr->show(dev, dev_attr, buf);
         if (ret >= (ssize_t)PAGE_SIZE) {
-                print_symbol("dev_attr_show: %s returned bad count\n",
-                                (unsigned long)dev_attr->show);
+                printk("dev_attr_show: %pSR returned bad count\n",
+                       dev_attr->show);
         }
         return ret;
 }
-- 
1.7.8.112.g3fd21


