Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0JEXVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:21:35 -0400
Received: from kroah.org ([198.145.64.141]:46773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907Ab0JEXVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:21:34 -0400
Subject: patch "driver core: fix build for CONFIG_BLOCK not enabled" added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Tue, 05 Oct 2010 16:18:10 -0700
In-Reply-To: <20100924143649.59f0572a.randy.dunlap@oracle.com>
Message-ID: <12863206901208@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: fix build for CONFIG_BLOCK not enabled

to my gregkh-2.6 tree which can be found in directory form at:
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
 and in git form at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git

The filename of this patch is:
    driver-core-fix-build-for-config_block-not-enabled.patch

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

If this patch meets the merge guidelines for a bugfix, it should be
merged into Linus's tree before the next major kernel release.
If not, it will be merged into Linus's tree during the next merge window.

Either way, you will probably be copied on the patch when it gets sent
to Linus for merging so that others can see what is happening in kernel
development.

If you have any questions about this process, please let me know.


>From linux-next-owner@vger.kernel.org  Tue Oct  5 15:33:46 2010
Date: Fri, 24 Sep 2010 14:36:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: driver core: fix build for CONFIG_BLOCK not enabled
Message-Id: <20100924143649.59f0572a.randy.dunlap@oracle.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when CONFIG_BLOCK is not enabled:

drivers/base/core.c: In function 'get_device_parent':
drivers/base/core.c:634: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c: In function 'device_add_class_symlinks':
drivers/base/core.c:723: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c: In function 'device_remove_class_symlinks':
drivers/base/core.c:751: error: 'block_class' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -630,12 +630,14 @@ static struct kobject *get_device_parent
 		struct kobject *parent_kobj;
 		struct kobject *k;
 
+#ifdef CONFIG_BLOCK
 		/* block disks show up in /sys/block */
 		if (sysfs_deprecated && dev->class == &block_class) {
 			if (parent && parent->class == &block_class)
 				return &parent->kobj;
 			return &block_class.p->class_subsys.kobj;
 		}
+#endif
 
 		/*
 		 * If we have no parent, we live in "virtual".
@@ -719,9 +721,11 @@ static int device_add_class_symlinks(str
 			goto out_subsys;
 	}
 
+#ifdef CONFIG_BLOCK
 	/* /sys/block has directories and does not need symlinks */
 	if (sysfs_deprecated && dev->class == &block_class)
 		return 0;
+#endif
 
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
@@ -748,8 +752,10 @@ static void device_remove_class_symlinks
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 	sysfs_remove_link(&dev->kobj, "subsystem");
+#ifdef CONFIG_BLOCK
 	if (sysfs_deprecated && dev->class == &block_class)
 		return;
+#endif
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 }
 

