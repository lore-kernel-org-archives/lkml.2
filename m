Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0EXB6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:58:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:53972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab0EXB6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:58:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,288,1272870000"; 
   d="scan'208";a="624151765"
Date: Mon, 24 May 2010 09:31:34 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com,
       Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
Message-ID: <20100524013134.GB25893@shaohui>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
	linux-kernel@vger.kernel.org, ak@linux.intel.co,
	fengguang.wu@intel.com, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com, Balbir Singh <balbir@in.ibm.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
References: <20100513114835.GD2169@shaohui>
 <20100521100816.GA7906@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521100816.GA7906@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:38:16PM +0530, Ankita Garg wrote:
> Hi,
> 
> On Thu, May 13, 2010 at 07:48:35PM +0800, Shaohui Zheng wrote:
> > Userland interface to hotplug-add fake offlined nodes.
> > 
> > Add a sysfs entry "probe" under /sys/devices/system/node/:
> > 
> >  - to show all fake offlined nodes:
> >     $ cat /sys/devices/system/node/probe
> > 
> >  - to hotadd a fake offlined node, e.g. nodeid is N:
> >     $ echo N > /sys/devices/system/node/probe
> > 
> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> > Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
> > ---
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 9458685..2c078c8 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1214,6 +1214,20 @@ config NUMA_EMU
> >  	  into virtual nodes when booted with "numa=fake=N", where N is the
> >  	  number of nodes. This is only useful for debugging.
> > 
> > +config NUMA_HOTPLUG_EMU
> > +	bool "NUMA hotplug emulator"
> > +	depends on X86_64 && NUMA && HOTPLUG
> > +	---help---
> > +
> > +config NODE_HOTPLUG_EMU
> > +	bool "Node hotplug emulation"
> > +	depends on NUMA_HOTPLUG_EMU && MEMORY_HOTPLUG
> > +	---help---
> > +	  Enable Node hotplug emulation. The machine will be setup with
> > +	  hidden virtual nodes when booted with "numa=hide=N*size", where
> > +	  N is the number of hidden nodes, size is the memory size per
> > +	  hidden node. This is only useful for debugging.
> > +
> 
> The above dependencies do not work as expected. I could configure
> NUMA_HOTPLUG_EMU & NODE_HOTPLUG_EMU without having MEMORY_HOTPLUG
> turned on. By pushing the above definition below SPARSEMEM and memory
> hot add and remove, the dependencies could be sorted out.
Ankita, 
	The emulation code was tested by many times, but we did not try each 
combination for the new options, good catching.
    We will includes your suggestion in the formal patch. thanks so much.
> 
> -- 
> Regards,                                                                        
> Ankita Garg (ankita@in.ibm.com)                                                 
> Linux Technology Center                                                         
> IBM India Systems & Technology Labs,                                            
> Bangalore, India

-- 
Thanks & Regards,
Shaohui

