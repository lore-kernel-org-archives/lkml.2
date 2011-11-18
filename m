Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1KRSUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:20:12 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30220 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1KRSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:20:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen: document balloon driver sysfs files
Date: Fri, 18 Nov 2011 13:19:52 -0500
Message-Id: <1321640393-19708-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
References: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EC6A1D4.00D1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Add ABI documentation for the balloon driver's sysfs files.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Daniel Kiper <dkiper@net-space.pl>
[v2: Added comments from Daniel]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 .../ABI/stable/sysfs-devices-system-xen_memory     |   77 ++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-system-xen_memory

diff --git a/Documentation/ABI/stable/sysfs-devices-system-xen_memory b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
new file mode 100644
index 0000000..caa311d
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
@@ -0,0 +1,77 @@
+What:		/sys/devices/system/xen_memory/xen_memory0/max_retry_count
+Date:		May 2011
+KernelVersion:	2.6.39
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		The maximum number of times the balloon driver will
+		attempt to increase the balloon before giving up.  See
+		also 'retry_count' below.
+		A value of zero means retry forever and is the default one.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/max_schedule_delay
+Date:		May 2011
+KernelVersion:	2.6.39
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		The limit that 'schedule_delay' (see below) will be
+		increased to. The default value is 32 seconds.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/retry_count
+Date:		May 2011
+KernelVersion:	2.6.39
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		The current number of times that the balloon driver
+		has attempted to increase the size of the balloon.
+		The default value is one. With max_retry_count being
+		zero (unlimited), this means that the driver will attempt
+		to retry with a 'schedule_delay' delay.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/schedule_delay
+Date:		May 2011
+KernelVersion:	2.6.39
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		The time (in seconds) to wait between attempts to
+		increase the balloon.  Each time the balloon cannot be
+		increased, 'schedule_delay' is increased (until
+		'max_schedule_delay' is reached at which point it
+		will use the max value).
+
+What:		/sys/devices/system/xen_memory/xen_memory0/target
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		The target number of pages to adjust this domain's
+		memory reservation to.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/target_kb
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		As target above, except the value is in KiB.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/info/current_kb
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		Current size (in KiB) of this domain's memory
+		reservation.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/info/high_kb
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		Amount (in KiB) of high memory in the balloon.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/info/low_kb
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+		Amount (in KiB) of low (or normal) memory in the
+		balloon.
-- 
1.7.7.1

