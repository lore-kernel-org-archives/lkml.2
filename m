Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0K3CpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 21:45:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:61780 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0K3CpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 21:45:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,278,1288594800"; 
   d="scan'208";a="354763109"
Date: Tue, 30 Nov 2010 09:22:05 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v5] NUMA Hotplug Emulator: Add node hotplug emulation
Message-ID: <20101130012205.GB3021@shaohui>
References: <20101129091750.950277284@intel.com>
 <20101129091935.703824659@intel.com>
 <alpine.DEB.2.00.1011291600020.21653@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011291600020.21653@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:01:18PM -0800, David Rientjes wrote:
> On Mon, 29 Nov 2010, shaohui.zheng@intel.com wrote:
> 
> > From: David Rientjes <rientjes@google.com>
> > 
> > Add an interface to allow new nodes to be added when performing memory
> > hot-add.  This provides a convenient interface to test memory hotplug
> > notifier callbacks and surrounding hotplug code when new nodes are
> > onlined without actually having a machine with such hotpluggable SRAT
> > entries.
> > 
> > This adds a new debugfs interface at /sys/kernel/debug/hotplug/add_node
> > that behaves in a similar way to the memory hot-add "probe" interface.
> > Its format is size@start, where "size" is the size of the new node to be
> > added and "start" is the physical address of the new memory.
> > 
> 
> Looks like you've changed some of the references in my changlog to 
> node/add_node, but not others, such as the above.  I'd actually much 
> rather prefer to take Greg's latest suggestion of doing 
> s/hotplug/mem_hotplug instead.
> 
> Would it be possible to repost the patch with that change?
> 
> Thanks!

We have two memory hotplug interfaces here:
add_node: add a new NUMA node
probe: add memory section

so puting add_node to node/add_node and puting probe to memory/probe should make sense. 
it is similar with sysfs hierarchy.

if we want to move the add_node to mem_hotplug/add_node, I'd prefer to put the probe
interface to mem_hotplug/probe since they are also related to memory hotplug.

I will include this change in next patchset.

-- 
Thanks & Regards,
Shaohui

