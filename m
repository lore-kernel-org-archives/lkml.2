Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0LWGfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:35:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:36219 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab0LWGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:35:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="871192014"
Date: Thu, 23 Dec 2010 13:10:47 +0800
From: Shaohui Zheng <shaohui.zheng@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shaohui.zheng@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Sam Ravnborg <sam@ravnborg.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [6/7, v9] NUMA Hotplug Emulator: Fake CPU socket with logical
 CPU on x86
Message-ID: <20101223051047.GA13060@shaohui>
References: <20101210073119.156388875@intel.com>
 <20101210073242.773689101@intel.com>
 <20101222162732.bef6904e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222162732.bef6904e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 04:27:32PM -0800, Andrew Morton wrote:
> >  static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
> > @@ -198,6 +200,8 @@
> >  {
> >  	int cpuid, phys_id;
> >  	unsigned long timeout;
> > +	u8 cpu_probe_on = 0;
> 
> Unneeded initialisation.
> 
> Does this cause an unused var warning when
> CONFIG_ARCH_CPU_PROBE_RELEASE=n?
> 

I am trying to avoid too much ifdef here, it seems it take an unused var
warining when CONFIG_ARCH_CPU_PROBE_RELEASE=n. good catching.

I will figure out a better method.

> > +	struct cpuinfo_x86 *c;
> >  
> >  	/*
> >  	 * If waken up by an INIT in an 82489DX configuration
> >
> > ...
> >
> > +#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> > +/*
> > + * Put the logical cpu into a new sokect, and encapsule it into core 0.
> 
> That comment needs help.
> 

Agree, the comment is too simple, should add better documents for function
fake_cpu_socket_info.

-- 
Thanks & Regards,
Shaohui

