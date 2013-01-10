Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3AJBHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:07:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56142 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab3AJBHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:07:05 -0500
Date: Wed, 9 Jan 2013 17:07:03 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
Message-ID: <20130110010703.GF32590@us.ibm.com>
References: <20130110010347.GA32590@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110010347.GA32590@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011001-3620-0000-0000-000000DB2397
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries

This patchset addes two new sets of files to sysfs:

	- generic and POWER-specific perf events in /sys/devices/cpu/events/
	- perf event config format in /sys/devices/cpu/format/event

Document the format of these files which would become part of the ABI.

Changelog[v3]:
	[Greg KH] Include ABI documentation.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 Documentation/ABI/stable/sysfs-devices-cpu-events |   54 +++++++++++++++++++++
 Documentation/ABI/stable/sysfs-devices-cpu-format |   27 ++++++++++
 2 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-cpu-format

diff --git a/Documentation/ABI/stable/sysfs-devices-cpu-events b/Documentation/ABI/stable/sysfs-devices-cpu-events
index e69de29..f37d542 100644
--- a/Documentation/ABI/stable/sysfs-devices-cpu-events
+++ b/Documentation/ABI/stable/sysfs-devices-cpu-events
@@ -0,0 +1,54 @@
+What:		/sys/devices/cpu/events/
+		/sys/devices/cpu/events/branch-misses
+		/sys/devices/cpu/events/cache-references
+		/sys/devices/cpu/events/cache-misses
+		/sys/devices/cpu/events/stalled-cycles-frontend
+		/sys/devices/cpu/events/branch-instructions
+		/sys/devices/cpu/events/stalled-cycles-backend
+		/sys/devices/cpu/events/instructions
+		/sys/devices/cpu/events/cpu-cycles
+
+Date:		2013/01/08
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+
+Description:	Generic performance monitoring events
+
+		A collection of performance monitoring events that may be
+		supported by many/most CPUs. These events can be monitored
+		using the 'perf(1)' tool.
+
+		The contents of each file would look like:
+
+			event=0xNNNN
+
+		where 'N' is a hex digit.
+
+
+What: 		/sys/devices/cpu/events/PM_LD_MISS_L1
+		/sys/devices/cpu/events/PM_LD_REF_L1
+		/sys/devices/cpu/events/PM_CYC
+		/sys/devices/cpu/events/PM_BRU_FIN
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
+		/sys/devices/cpu/events/PM_BRU_MPRED
+		/sys/devices/cpu/events/PM_INST_CMPL
+		/sys/devices/cpu/events/PM_CMPLU_STALL
+
+Date:		2013/01/08
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux Powerpc mailing list <linuxppc-dev@ozlabs.org>
+
+Description:	POWER specific performance monitoring events
+
+		A collection of performance monitoring events that may be
+		supported by the POWER CPU. These events can be monitored
+		using the 'perf(1)' tool.
+
+		These events may not be supported by other CPUs.
+
+		The contents of each file would look like:
+
+			event=0xNNNN
+
+		where 'N' is a hex digit.
diff --git a/Documentation/ABI/stable/sysfs-devices-cpu-format b/Documentation/ABI/stable/sysfs-devices-cpu-format
new file mode 100644
index 0000000..b15cfb2
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-cpu-format
@@ -0,0 +1,27 @@
+What:		/sys/devices/cpu/format/
+		/sys/devices/cpu/format/event
+
+Date:		2013/01/08
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+
+Description:	Format of performance monitoring events
+
+		Each CPU/architecture may use different format to represent
+		the perf event.  The 'event' file describes the configuration
+		format of the performance monitoring event on the CPU/system.
+
+		The contents of each file would look like:
+
+			config:m-n
+
+		where m and n are the starting and ending bits that are
+		used to represent the event.
+
+		For example, on POWER,
+
+			$ cat /sys/devices/cpu/format/event
+			config:0-20
+
+		meaning that POWER uses the first 20-bits to represent a perf
+		event.
-- 
1.7.1

