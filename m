Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab0GVLLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:11:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:6908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210Ab0GVLL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:11:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="640711486"
Subject: [RFC][PATCH v1 00/15] perf: export events in a structured way via
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Jens Axboe <jaxboe@fusionio.com>, Avi Kivity <avi@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
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
Date: Thu, 22 Jul 2010 19:11:40 +0800
Message-ID: <1279797100.20942.81.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

(CC driver maintainers since many device tracepoint events are exported)

This patch series is based on the discussion of
[rfc] Describe events in a structured way via sysfs
http://lkml.org/lkml/2010/5/21/102

Applied on top of Peter's perf tree, perf-pmu branch.

Hareware/Software/Tracepoint events are exported in a structured way via
sysfs, like below
I throw out these patches to see if various events are put under correct
sysfs point.

Robert Richter and Corey Ashford have some ideas about what event
attributes should be shown in sysfs, but now let's just show "config"
and "type" for demo of sysfs structure.

And I'll document the sysfs ABI in later version.

1. Hardware events
/sys/devices/system/cpu/cpu0...cpuN/events
|-- L1-dcache-load-misses  ===> event name
|   |-- config             ===> config value for the event
|   `-- type               ===> event type
|-- cycles
|   |-- config
|   `-- type
.....

2. Software events
/sys/kernel/events
|-- page-faults
|   |-- config
|   `-- type
|-- context-switches
|   |-- config
|   `-- type
....

3. Tracepoint events
/sys/devices/pci0000:00/0000:00:02.0/events
|-- i915_gem_object_create
|   |-- config
|   `-- type
|-- i915_gem_object_bind
|   |-- config
|   `-- type
....
/sys/devices/system/kvm/kvm0/events
|-- kvm_entry
|   |-- config
|   `-- type
|-- kvm_hypercall
|   |-- config
|   `-- type
....

Welcome for any comment.

Thanks,
Lin Ming






