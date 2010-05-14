Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0ENFuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:50:22 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41725 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0ENFuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:50:18 -0400
Date: Fri, 14 May 2010 14:49:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       fengguang.wu@intel.com, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC,5/7] NUMA hotplug emulator
Message-ID: <20100514054928.GC12002@linux-sh.org>
References: <20100513121457.GJ2169@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513121457.GJ2169@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:14:57PM +0800, Shaohui Zheng wrote:
> hotplug emulator: support cpu probe/release in x86
> 
> Add cpu interface probe/release under sysfs for x86. User can use this
> interface to emulate the cpu hot-add process, it is for cpu hotplug 
> test purpose. Add a kernel option CONFIG_ARCH_CPU_PROBE_RELEASE for this
> feature.
> 
> This interface provides a mechanism to emulate cpu hotplug with software
>  methods, it becomes possible to do cpu hotplug automation and stress
> testing.
> 
At a quick glance, is this really necessary? It seems like you could
easily replace most of this with a CPU notifier chain that takes care of
the node handling. See for example how ppc64 manages the CPU hotplug/numa
emulation case in arch/powerpc/mm/numa.c. arch_register_cpu() just looks
like some topology hack for ACPI, it would be nice not to perpetuate that
too much.
