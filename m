Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1G0EFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:31 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52109 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702Ab1G0EF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:29 -0400
X-Sasl-enc: VbSJRnMb2orWwEfuG5ycUm2APXf+MOhDz1p6i+doiwXG 1311739527
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/11] DOCUMENTATION: Update overview.txt in Doc/driver-model.
Date: Tue, 26 Jul 2011 21:05:12 -0700
Message-Id: <1311739521-11014-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@crashcourse.ca>

A few grammatical fixes, clarifications and corrections in just the
overview file for the driver model documentation.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/overview.txt |   52 ++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/Documentation/driver-model/overview.txt b/Documentation/driver-model/overview.txt
index 07236ed..6a8f9a8 100644
--- a/Documentation/driver-model/overview.txt
+++ b/Documentation/driver-model/overview.txt
@@ -30,7 +30,7 @@ management, and hot plug. In particular, the model dictated by Intel and
 Microsoft (namely ACPI) ensures that almost every device on almost any bus
 on an x86-compatible system can work within this paradigm.  Of course,
 not every bus is able to support all such operations, although most
-buses support a most of those operations.
+buses support most of those operations.
 
 
 Downstream Access
@@ -46,25 +46,29 @@ struct pci_dev now looks like this:
 struct pci_dev {
 	...
 
-	struct device dev;
+	struct device dev;     /* Generic device interface */
+	...
 };
 
-Note first that it is statically allocated. This means only one allocation on
-device discovery. Note also that it is at the _end_ of struct pci_dev. This is
-to make people think about what they're doing when switching between the bus
-driver and the global driver; and to prevent against mindless casts between
-the two.
+Note first that the struct device dev within the struct pci_dev is
+statically allocated. This means only one allocation on device discovery.
+
+Note also that that struct device dev is not necessarily defined at the
+front of the pci_dev structure.  This is to make people think about what
+they're doing when switching between the bus driver and the global driver,
+and to discourage meaningless and incorrect casts between the two.
 
 The PCI bus layer freely accesses the fields of struct device. It knows about
 the structure of struct pci_dev, and it should know the structure of struct
 device. Individual PCI device drivers that have been converted to the current
 driver model generally do not and should not touch the fields of struct device,
-unless there is a strong compelling reason to do so.
+unless there is a compelling reason to do so.
 
-This abstraction is prevention of unnecessary pain during transitional phases.
-If the name of the field changes or is removed, then every downstream driver
-will break. On the other hand, if only the bus layer (and not the device
-layer) accesses struct device, it is only that layer that needs to change.
+The above abstraction prevents unnecessary pain during transitional phases.
+If it were not done this way, then when a field was renamed or removed, every
+downstream driver would break.  On the other hand, if only the bus layer
+(and not the device layer) accesses the struct device, it is only the bus
+layer that needs to change.
 
 
 User Interface
@@ -73,15 +77,27 @@ User Interface
 By virtue of having a complete hierarchical view of all the devices in the
 system, exporting a complete hierarchical view to userspace becomes relatively
 easy. This has been accomplished by implementing a special purpose virtual
-file system named sysfs. It is hence possible for the user to mount the
-whole sysfs filesystem anywhere in userspace.
+file system named sysfs.
+
+Almost all mainstream Linux distros mount this filesystem automatically; you
+can see some variation of the following in the output of the "mount" command:
+
+$ mount
+...
+none on /sys type sysfs (rw,noexec,nosuid,nodev)
+...
+$
+
+The auto-mounting of sysfs is typically accomplished by an entry similar to
+the following in the /etc/fstab file:
+
+none     	/sys	sysfs    defaults	  	0 0
 
-This can be done permanently by providing the following entry into the
-/etc/fstab (under the provision that the mount point does exist, of course):
+or something similar in the /lib/init/fstab file on Debian-based systems:
 
-none     	/sys	sysfs    defaults		0	0
+none            /sys    sysfs    nodev,noexec,nosuid    0 0
 
-Or by hand on the command line:
+If sysfs is not automatically mounted, you can always do it manually with:
 
 # mount -t sysfs sysfs /sys
 
-- 
1.7.6

