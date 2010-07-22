Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab0GVLRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:17:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:9931 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab0GVLRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:17:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="303090325"
Subject: [RFC][PATCH v1 14/15] perf: export tracepoint events via sysfs:
 scsi
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:18:04 +0800
Message-ID: <1279797484.20942.97.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi tracepoint events are exported like below,

/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host4/scsi_host/host4/events
|-- scsi_dispatch_cmd_done
|   |-- config
|   `-- type
|-- scsi_dispatch_cmd_error
|   |-- config
|   `-- type
|-- scsi_dispatch_cmd_start
|   |-- config
|   `-- type
|-- scsi_dispatch_cmd_timeout
|   |-- config
|   `-- type
`-- scsi_eh_wakeup
    |-- config
    `-- type
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host5/scsi_host/host5/events
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host6/scsi_host/host6/events
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host7/scsi_host/host7/events
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host8/scsi_host/host8/events
/sys/devices/pci0000:00/0000:00:1f.1/host9/scsi_host/host9/events
/sys/devices/pci0000:00/0000:00:1f.1/host10/scsi_host/host10/events
/sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host/host0/events
/sys/devices/pci0000:00/0000:00:1f.2/host1/scsi_host/host1/events
/sys/devices/pci0000:00/0000:00:1f.2/host2/scsi_host/host2/events
/sys/devices/pci0000:00/0000:00:1f.2/host3/scsi_host/host3/events
---
 drivers/scsi/hosts.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6660fa9..7e256a6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/completion.h>
+#include <linux/perf_event.h>
 #include <linux/transport_class.h>
 #include <linux/platform_device.h>
 
@@ -231,6 +232,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto out_del_gendev;
 
+	perf_sys_add_tp(&shost->shost_dev.kobj, "scsi");
+
 	get_device(&shost->shost_gendev);
 
 	if (shost->transportt->host_size) {



