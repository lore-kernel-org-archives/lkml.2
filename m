Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0EXBxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:53:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:2246 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab0EXBxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:53:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,288,1272870000"; 
   d="scan'208";a="624151252"
Date: Mon, 24 May 2010 09:26:39 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
Message-ID: <20100524012639.GA25893@shaohui>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com
References: <20100513120016.GG2169@shaohui>
 <20100521101104.GB7906@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521101104.GB7906@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:41:04PM +0530, Ankita Garg wrote:
> Hi,
> 
> On Thu, May 13, 2010 at 08:00:16PM +0800, Shaohui Zheng wrote:
> > hotplug emulator:extend memory probe interface to support NUMA
> > 
> > Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
> > Signed-off-by: Haicheng Li <haicheng.li@intel.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 54ccb0d..787024f 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1239,6 +1239,17 @@ config ARCH_CPU_PROBE_RELEASE
> >  	  is for cpu hot-add/hot-remove to specified node in software method.
> >  	  This is for debuging and testing purpose
> > 
> > +config ARCH_MEMORY_PROBE
> 
> The above symbol exists already...
Yes, we create CONFIG_NUMA_HOTPLUG_EMU, CONFIG_NODE_HOTPLUG_EMU and CONFIG_ARCH_CPU_PROBE_RELEASE options,
and move CONFIG_ARCH_MEMORY_PROBE together with the above 3 options.


> 
> > +	def_bool y
> > +	bool "Memory hotplug emulation"
> > +	depends on NUMA_HOTPLUG_EMU
> > +	---help---
> > +	  Enable memory hotplug emulation. Reserve memory with grub parameter
> > +	  "mem=N"(such as mem=1024M), where N is the initial memory size, the
> > +	  rest physical memory will be removed from e820 table; the memory probe
> > +	  interface is for memory hot-add to specified node in software method.
> > +	  This is for debuging and testing purpose
> > +
> >  config NODES_SHIFT
> >  	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
> >  	range 1 10
> 
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

