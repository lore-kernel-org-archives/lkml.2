Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0LAAjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:39:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:11297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0LAAjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:39:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="579251950"
Date: Wed, 1 Dec 2010 07:16:13 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v5] NUMA Hotplug Emulator: Add node hotplug emulation
Message-ID: <20101130231613.GA9117@shaohui>
References: <20101129091750.950277284@intel.com>
 <20101129091935.703824659@intel.com>
 <alpine.DEB.2.00.1011291600020.21653@chino.kir.corp.google.com>
 <20101130012205.GB3021@shaohui>
 <alpine.DEB.2.00.1011301208060.12979@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011301208060.12979@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:10:09PM -0800, David Rientjes wrote:
> On Tue, 30 Nov 2010, Shaohui Zheng wrote:
> 
> > We have two memory hotplug interfaces here:
> > add_node: add a new NUMA node
> > probe: add memory section
> > 
> > so puting add_node to node/add_node and puting probe to memory/probe should make sense. 
> > it is similar with sysfs hierarchy.
> > 
> > if we want to move the add_node to mem_hotplug/add_node, I'd prefer to put the probe
> > interface to mem_hotplug/probe since they are also related to memory hotplug.
> > 
> > I will include this change in next patchset.
> > 
> 
> No, please don't move the 'probe' trigger to debugfs; hotadding memory 
> should not depend on CONFIG_DEBUG_FS.  Node hotplug emulation _is_ a 
> debugging function and can therefore be defined in debugfs as I did but 
> with a s/hotplug/mem_hotplug change that Greg suggested.

David,
	we provide both debugfs and sysfs interface for memory probe, the sysfs 
interface is always available. For debugfs interface, it depends on CONFIG_DEBUG_FS.
	we can also think that memory hotplug emulation _is_ a debuging function,
so we accept Dave's suggestion to provide debugfs interface.

-- 
Thanks & Regards,
Shaohui

