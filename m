Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0IVDUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:20:31 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27579 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830Ab0IVDU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:20:29 -0400
Subject: [PATCH v2 2/2] Doc/ABI: sysfs-drm initial document; "polled" entry
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        dri-devel@lists.freedesktop.org, Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <1285023750.30856.99.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	 <1285023750.30856.99.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 23:20:22 -0400
Message-ID: <1285125622.2518.21.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_02:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009210245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial addition of documentation for the drm module's sysfs
entries.  It provides a drm sysfs entries overview, and a detailed
description of the new drm per output connector "polled" entry in sysfs.

Signed-of-by: Andy Walls <awalls@md.metrocast.net>

diff --git a/Documentation/ABI/testing/sysfs-drm b/Documentation/ABI/testing/sysfs-drm
new file mode 100644
index 0000000..18a017a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-drm
@@ -0,0 +1,208 @@
+Direct Rendering Infrastructure (DRI) Direct Rendering Manager (drm) module
+and Translation Table Manager (ttm) module sysfs entries
+
+Example class view showing a single graphics adapter with three output
+connectors, a special control device node for the graphics adapter, and the
+Translation Table Manager (ttm) graphics memory manager virtual device:
+
+    /sys/class/drm/
+    ├── card0               -> ../../devices/<...>/drm/card0
+    ├── card0-DVI-D-1       -> ../../devices/<...>/drm/card0/card0-DVI-D-1
+    ├── card0-HDMI Type A-1 -> ../../devices/<...>/drm/card0/card0-HDMI Type A-1
+    ├── card0-VGA-1         -> ../../devices/<...>/drm/card0/card0-VGA-1
+    ├── controlD64          -> ../../devices/<...>/drm/controlD64
+    ├── ttm                 -> ../../devices/virtual/drm/ttm
+    └── version
+
+    6 directories, 1 file
+
+
+Corresponding DRI device nodes for the example graphics adapter, with
+additional ACL properties on card0 granting rw perms to the X/console user:
+
+    crw-rw----+ 1 root video 226,  0 2010-09-21 20:52 /dev/dri/card0
+    crw-rw-rw-. 1 root video 226, 64 2010-09-21 20:51 /dev/dri/controlD64
+
+
+Example physical device view for a single graphics adapter with three output
+connectors and a special control device node for the graphics adapter:
+
+    /sys/devices/<...>/drm
+    ├── card0
+    │   ├── card0-DVI-D-1
+    │   │   ├── device -> ../../card0
+    │   │   ├── dpms
+    │   │   ├── edid
+    │   │   ├── enabled
+    │   │   ├── modes
+    │   │   ├── polled
+    │   │   ├── power
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   ├── wakeup
+    │   │   │   └── wakeup_count
+    │   │   ├── status
+    │   │   ├── subsystem -> ../../../../../../../class/drm
+    │   │   └── uevent
+    │   ├── card0-HDMI Type A-1
+    │   │   ├── device -> ../../card0
+    │   │   ├── dpms
+    │   │   ├── edid
+    │   │   ├── enabled
+    │   │   ├── modes
+    │   │   ├── polled
+    │   │   ├── power
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   ├── wakeup
+    │   │   │   └── wakeup_count
+    │   │   ├── status
+    │   │   ├── subsystem -> ../../../../../../../class/drm
+    │   │   └── uevent
+    │   ├── card0-VGA-1
+    │   │   ├── device -> ../../card0
+    │   │   ├── dpms
+    │   │   ├── edid
+    │   │   ├── enabled
+    │   │   ├── modes
+    │   │   ├── polled
+    │   │   ├── power
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   ├── wakeup
+    │   │   │   └── wakeup_count
+    │   │   ├── status
+    │   │   ├── subsystem -> ../../../../../../../class/drm
+    │   │   └── uevent
+    │   ├── dev
+    │   ├── device -> ../../../0000:01:05.0
+    │   ├── power
+    │   │   ├── control
+    │   │   ├── runtime_active_time
+    │   │   ├── runtime_status
+    │   │   ├── runtime_suspended_time
+    │   │   ├── wakeup
+    │   │   └── wakeup_count
+    │   ├── subsystem -> ../../../../../../class/drm
+    │   └── uevent
+    └── controlD64
+        ├── dev
+        ├── device -> ../../../0000:01:05.0
+        ├── power
+        │   ├── control
+        │   ├── runtime_active_time
+        │   ├── runtime_status
+        │   ├── runtime_suspended_time
+        │   ├── wakeup
+        │   └── wakeup_count
+        ├── subsystem -> ../../../../../../class/drm
+        └── uevent
+
+    20 directories, 55 files
+
+
+Example virtual device view view showing the Translation Table Manager (ttm)
+graphics memory manager virtual device:
+
+    /sys/devices/virtual/drm
+    └── ttm
+        ├── buffer_objects
+        │   └── bo_count
+        ├── memory_accounting
+        │   ├── kernel
+        │   │   ├── available_memory
+        │   │   ├── emergency_memory
+        │   │   ├── swap_limit
+        │   │   ├── used_memory
+        │   │   └── zone_memory
+        │   └── pool
+        │       ├── pool_allocation_size
+        │       ├── pool_max_size
+        │       └── pool_small_allocation
+        ├── power
+        │   ├── control
+        │   ├── runtime_active_time
+        │   ├── runtime_status
+        │   ├── runtime_suspended_time
+        │   ├── wakeup
+        │   └── wakeup_count
+        ├── subsystem -> ../../../../class/drm
+        └── uevent
+
+    7 directories, 16 files
+
+
+
+Where:		/sys/devices/<...>/drm/cardN/cardN-C-M/polled
+		For N a decimal system graphics adapter number: 0, 1, 2, ...
+		For C a connector type name (including spaces) from the set:
+			Unknown
+			VGA
+			DVI-I
+			DVI-D
+			DVI-A
+			Composite
+			SVIDEO
+			LVDS
+			Component
+			9-pin DIN
+			DisplayPort
+			HDMI Type A
+			HDMI Type B
+			TV
+			Embedded DisplayPort
+		For M a decimal connector number for connectors of that type
+			over all the graphics adapters in the system: 1, 2, ...
+Date:		22 September 2010
+KernelVersion:	2.6.37
+Contact:	Andy Walls <awalls@md.metrocast.net>
+Description:
+		Manual control over DRM Kernel Mode Set (KMS) output connector
+		hotplug/connect/disconnect polling criteria.  The graphics
+		adapter drm driver (e.g. radeon, i915, nouveau) will detect
+		the available connectors on a graphics adapter and set polling
+		criteria flags for the connector to specify for what events the
+		0.1 Hz DRM KMS poll of the connector should look.
+
+		A read of the contents of this entry will show what flags are
+		available, with the names of flags that are set for the
+		connector enclosed in brackets:
+
+			# cat /sys/devices/.../drm/card0/card0-DVI-D-1/polled
+			[hotplug_detectable] connect disconnect
+
+		A write of flags names to this entry, will clear the current
+		flag settings and set the poll criteria flags for that
+		connector to those specified names:
+
+			# echo " disconnect  connect " > \
+				/sys/devices/.../drm/card0/card0-DVI-D-1/polled
+			# cat /sys/devices/.../drm/card0/card0-DVI-D-1/polled
+			hotplug_detectable [connect] [disconnect]
+
+			# echo > /sys/devices/.../drm/card0/card0-DVI-D-1/polled
+			# cat /sys/devices/.../drm/card0/card0-DVI-D-1/polled
+			hotplug_detectable connect disconnect
+
+		The flags have the following meanings in drm_crtc_helper.c:
+
+			hotplug_detectable:
+			   always attempt to detect connection status upon poll
+			   don't automatically set up another poll of connector
+
+			connect:
+			   attempt to detect "connect" events
+			   automatically set up another poll of connector
+
+			disconnect:
+			   attempt to detect "disconnect" events
+			   automatically set up another poll of connector
+
+		Clearing all three flags will disable any detection actions
+		being taken for that connector during the 0.1 Hz poll.





