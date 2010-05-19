Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0ESC4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:56:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:1125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0ESC4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,259,1272870000"; 
   d="scan'208";a="519191112"
Subject: Re: [RFC][PATCH v2 08/11] sysfs: introduce new interface
 sysfs_get_kobject
From: Lin Ming <ming.m.lin@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100518200823.GC20223@kroah.com>
References: <1274233723.3036.87.camel@localhost>
	 <20100518200823.GC20223@kroah.com>
Content-Type: text/plain
Date: Wed, 19 May 2010 10:55:17 +0800
Message-Id: <1274237717.3603.37.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 04:08 +0800, Greg KH wrote:
> On Wed, May 19, 2010 at 01:48:43AM +0000, Lin Ming wrote:
> > Need this interface in the later sysfs pmu lookup.
> > 
> > struct kobject *sysfs_get_kobject(struct file *file);
> > Return the relative kobject of the sysfs file.
> 
> Ick, no.  Why would you ever have the file, yet not have the kobject
> already?  Something is really wrong if this is needed.  Or strange.  Or
> maybe both :)

Let me show you the scenario.

/sys/devices/system/cpu/event_source/
`-- id

/sys/devices/system/cpu/events/
|-- L1-dcache-load-misses
|   |-- event_source -> ../../event_source

$perf top -e L1-dcache-load-misses

Lookup the pmu used to handle L1-dcache-load-misses as below,

1. pmu_sys_fd =
open("/sys/devices/system/cpu/events/L1-dcache-load-misses/event_source/id", ...)

2. pmu_sys_file = fget_light(pmu_sys_fd, ....)

3. pmu_kobject = sysfs_get_kobject(pmu_sys_file)

4. pmu_kobject is embedded in struct pmu, pmu = container_of(kobj,
struct pmu, kobj);

> 
> thanks,
> 
> greg k-h

