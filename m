Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab0D3TGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:06:00 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:30163 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759407Ab0D3TFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:05:20 -0400
Subject: Re: mmotm 2010-04-28-16-53 uploaded
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <21637.1272653269@localhost>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <18962.1272576730@localhost>
	 <1272650547.10027.97.camel@useless.americas.hpqcorp.net>
	 <21637.1272653269@localhost>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 30 Apr 2010 15:05:13 -0400
Message-Id: <1272654314.10027.100.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-30 at 14:47 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 30 Apr 2010 14:02:27 EDT, Lee Schermerhorn said:
> 
> > Would you have time to try a few patches?  I've been doing some rework
> > of the generic percpu numa_node/numa_mem patches.  This rework should
> > solve the build problem you encountered.

Thanks for the quick turn around!

> 
> Not sure if I bollixed up adding the patches to the series file, that
> section now looks like:
> 
> % grep -n ^numa series
> 1465:numa-add-generic-percpu-var-numa_node_id-implementation.patch
> 1466:numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch
> 1467:numa-add-generic-percpu-var-numa_node_id-implementation-fix2.patch
> 1468:numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
> 1469:numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix1.patch
> 1470:numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch
> 1471:numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
> 1473:numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
> 1474:numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
> 1475:numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
> 1476:numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch
> 1477:numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
> 1478:numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
> 1479:numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
> 1480:numa-update-documentation-vm-numa-add-memoryless-node-info.patch
> 1481:numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch

That looks right.

> 
> and it dies with:
> 
>  LANG=C make
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/linux/gfp.h:7,
>                  from include/linux/kmod.h:22,
>                  from include/linux/module.h:13,
>                  from include/linux/crypto.h:21,
>                  from arch/x86/kernel/asm-offsets_64.c:8,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/linux/topology.h:246: error: redefinition of 'numa_node_id'
> /usr/src/linux-2.6.34-rc5-mmotm0428/arch/x86/include/asm/topology.h:163: note: previous definition of 'numa_node_id' was here
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> X86_64 build, CONFIG_NUMA=n - looks like include/linux/topology.h doesn't
> play nice in the !CONFIG_USE_PERCPU_NUMA_NODE_ID case...
> 

Hmmm.  I tested that before I sent it.  I was getting that error before
I added the "override" definition to arch/x86/include/asm/topology.h.

Let me see what I did wrong...

Thanks

