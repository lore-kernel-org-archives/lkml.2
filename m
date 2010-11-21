Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0KVAzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:55:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:28504 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab0KVAzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:55:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,232,1288594800"; 
   d="scan'208";a="576119040"
Date: Mon, 22 Nov 2010 07:33:51 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8,v3] NUMA Hotplug Emulator: documentation
Message-ID: <20101121233351.GA7626@shaohui>
References: <20101117020759.016741414@intel.com>
 <20101117021000.985643862@intel.com>
 <20101121150344.GK9099@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101121150344.GK9099@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 11:03:45PM +0800, Américo Wang wrote:
> On Wed, Nov 17, 2010 at 10:08:07AM +0800, shaohui.zheng@intel.com wrote:
> >+2) CPU hotplug emulation:
> >+
> >+The emulator reserve CPUs throu grub parameter, the reserved CPUs can be
> >+hot-add/hot-remove in software method, it emulates the process of physical
> >+cpu hotplug.
> >+
> >+When hotplug a CPU with emulator, we are using a logical CPU to emulate the CPU
> >+socket hotplug process. For the CPU supported SMT, some logical CPUs are in the
> >+same socket, but it may located in different NUMA node after we have emulator.
> >+We put the logical CPU into a fake CPU socket, and assign it an unique
> >+phys_proc_id. For the fake socket, we put one logical CPU in only.
> >+
> >+ - to hide CPUs
> >+	- Using boot option "maxcpus=N" hide CPUs
> >+	  N is the number of initialize CPUs
> >+	- Using boot option "cpu_hpe=on" to enable cpu hotplug emulation
> >+      when cpu_hpe is enabled, the rest CPUs will not be initialized
> >+
> >+ - to hot-add CPU to node
> >+	$ echo nid > cpu/probe
> >+
> >+ - to hot-remove CPU
> >+	$ echo nid > cpu/release
> >+
> 
> Again, we already have software CPU hotplug,
> i.e. /sys/devices/system/cpu/cpuX/online.
it is cpu online/offline in current kernel, not physical CPU hot-add or hot-remove.
the emulator is a tool to emulate the process of physcial CPU hotplug.
> 
> You need to pick up another name for this.
> 
> >From your documentation above, it looks like you are trying
> to move one CPU between nodes?
Yes, you are correct. With cpu probe/release interface, you can hot-remove a
CPU from a node, and hot-add it to another node.
> 
> >+	cpu_hpe=on/off
> >+		Enable/disable cpu hotplug emulation with software method. when cpu_hpe=on,
> >+		sysfs provides probe/release interface to hot add/remove cpu dynamically.
> >+		this option is disabled in default.
> >+			
> 
> Why not just a CONFIG? IOW, why do we need to make another boot
> parameter for this?
Only the developer or QA will use the emulator, we did not want to change the
default action for common user who does not care the hotplug emulator, so we
use a kernel parameter as a switch. The common user is not aware the existence
of the emulator.


-- 
Thanks & Regards,
Shaohui

