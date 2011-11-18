Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1KRSUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:20:10 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30221 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1KRSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:20:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen: document backend sysfs files
Date: Fri, 18 Nov 2011 13:19:53 -0500
Message-Id: <1321640393-19708-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
References: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EC6A1D4.00B5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Add ABI documentation for the /sys/bus/xen-backend sysfs files,
including those specific to xen-blkback devices.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/ABI/stable/sysfs-bus-xen-backend |   75 ++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-bus-xen-backend

diff --git a/Documentation/ABI/stable/sysfs-bus-xen-backend b/Documentation/ABI/stable/sysfs-bus-xen-backend
new file mode 100644
index 0000000..3d5951c
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-bus-xen-backend
@@ -0,0 +1,75 @@
+What:		/sys/bus/xen-backend/devices/*/devtype
+Date:		Feb 2009
+KernelVersion:	2.6.38
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                The type of the device.  e.g., one of: 'vbd' (block),
+                'vif' (network), or 'vfb' (framebuffer).
+
+What:		/sys/bus/xen-backend/devices/*/nodename
+Date:		Feb 2009
+KernelVersion:	2.6.38
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                XenStore node (under /local/domain/NNN/) for this
+                backend device.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/physical_device
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                The major:minor number (in hexidecimal) of the
+                physical device providing the storage for this backend
+                block device.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/mode
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Whether the block device is read-only ('r') or
+                read-write ('w').
+
+What:		/sys/bus/xen-backend/devices/vbd-*/statistics/f_req
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Number of flush requests from the frontend.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/statistics/oo_req
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Number of requests delayed because the backend was too
+                busy processing previous requests.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/statistics/rd_req
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Number of read requests from the frontend.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/statistics/rd_sect
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Number of sectors read by the frontend.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/statistics/wr_req
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Number of write requests from the frontend.
+
+What:		/sys/bus/xen-backend/devices/vbd-*/statistics/wr_sect
+Date:		April 2011
+KernelVersion:	3.0
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Number of sectors written by the frontend.
-- 
1.7.7.1

