Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0EUKL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:11:28 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44331 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0EUKL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:11:26 -0400
Date: Fri, 21 May 2010 15:38:16 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Cc: Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
Message-ID: <20100521100816.GA7906@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <20100513114835.GD2169@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513114835.GD2169@shaohui>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 13, 2010 at 07:48:35PM +0800, Shaohui Zheng wrote:
> Userland interface to hotplug-add fake offlined nodes.
> 
> Add a sysfs entry "probe" under /sys/devices/system/node/:
> 
>  - to show all fake offlined nodes:
>     $ cat /sys/devices/system/node/probe
> 
>  - to hotadd a fake offlined node, e.g. nodeid is N:
>     $ echo N > /sys/devices/system/node/probe
> 
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
> ---
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9458685..2c078c8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1214,6 +1214,20 @@ config NUMA_EMU
>  	  into virtual nodes when booted with "numa=fake=N", where N is the
>  	  number of nodes. This is only useful for debugging.
> 
> +config NUMA_HOTPLUG_EMU
> +	bool "NUMA hotplug emulator"
> +	depends on X86_64 && NUMA && HOTPLUG
> +	---help---
> +
> +config NODE_HOTPLUG_EMU
> +	bool "Node hotplug emulation"
> +	depends on NUMA_HOTPLUG_EMU && MEMORY_HOTPLUG
> +	---help---
> +	  Enable Node hotplug emulation. The machine will be setup with
> +	  hidden virtual nodes when booted with "numa=hide=N*size", where
> +	  N is the number of hidden nodes, size is the memory size per
> +	  hidden node. This is only useful for debugging.
> +

The above dependencies do not work as expected. I could configure
NUMA_HOTPLUG_EMU & NODE_HOTPLUG_EMU without having MEMORY_HOTPLUG
turned on. By pushing the above definition below SPARSEMEM and memory
hot add and remove, the dependencies could be sorted out.

-- 
Regards,                                                                        
Ankita Garg (ankita@in.ibm.com)                                                 
Linux Technology Center                                                         
IBM India Systems & Technology Labs,                                            
Bangalore, India
