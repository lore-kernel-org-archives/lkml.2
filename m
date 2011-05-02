Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab1EBJNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:13:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1EBJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Xrfx2QEQhE99uBXALVfvCMvI5ajDIcOWuWZgNClgvFWoqL02BrR8KLewlyOzCVv53i
         D1To/kJsWM9uPJwy77vsmkJ21sFLUNUEDMbDpETSXpcmWO5o9Coog/W/vAQa+a2wjUxG
         eW3dXBtxzii8c0JKlnDie2H0zbCfGet4KuEjc=
Date: Mon, 2 May 2011 11:13:34 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [GIT PULL tip:x86/mm] Unify 32 and 64bit NUMA init paths
Message-ID: <20110502091334.GB22117@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Please pull from the following branch to receive unification of 32 and
64bit NUMA init paths.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
 ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

Other than addition of two patches from Yinghai and rebasing on top of
x86/urgent, nothing has changed from the initial posting[1].

Please note that the tree is on top of

  x86/mm	c7a7b814c9dca9ee01b38e63b4a46de87156d3b6
+ x86/numa	993ba1585cbb03fab012e41d1a5d24330a283b31
+ x86/urgent	2be19102b71c1a45d37fec50303791daa1a06869

x86/urgent was needed for the following two NUMA fix commits.

 2be19102b7 "x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()"
 765af22da8 "x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change"

I can regenerate tree such that it's x86/mm + x86/numa + cherry pick
of the above two patches.  If that's preferred, please let me know.

Thank you.

Tejun Heo (25):
      x86-64, NUMA: Simplify hotadd memory handling
      x86-64, NUMA: trivial cleanups for setup_node_bootmem()
      x86-64, NUMA: simplify nodedata allocation
      x86-32, NUMA: Automatically set apicid -> node in setup_local_APIC()
      x86, NUMA: Unify 32/64bit numa_cpu_node() implementation
      x86-32, NUMA: Make apic->x86_32_numa_cpu_node() optional
      x86-32, NUMA: use sparse_memory_present_with_active_regions()
      x86, NUMA: trivial cleanups
      x86, NUMA: rename srat_64.c to srat.c
      x86, NUMA: make srat.c 32bit safe
      x86-32, NUMA: Move get_memcfg_numa() into numa_32.c
      x86, NUMA: Move numa_nodes_parsed to numa.[hc]
      x86-32, NUMA: implement temporary NUMA init shims
      x86-32, NUMA: Replace srat_32.c with srat.c
      x86-32, NUMA: Update numaq to use new NUMA init protocol
      x86, NUMA: Move NUMA init logic from numa_64.c to numa.c
      x86, NUMA: Enable build of generic NUMA init code on 32bit
      x86, NUMA: Remove long 64bit assumption from numa.c
      x86-32, NUMA: Add @start and @end to init_alloc_remap()
      x86, NUMA: Initialize and use remap allocator from setup_node_bootmem()
      x86, NUMA: Make 32bit use common NUMA init path
      x86, NUMA: Make numa_init_array() static
      x86, NUMA: Rename amdtopology_64.c to amdtopology.c
      x86, NUMA: Enable CONFIG_AMD_NUMA on 32bit too
      x86, NUMA: Enable emulation on 32bit too

Yinghai Lu (2):
      x86, NUMA: Rename setup_node_bootmem() to setup_node_data()
      x86, NUMA: Trim numa meminfo with max_pfn in a separate loop

 arch/x86/Kconfig                                |    4 +-
 arch/x86/include/asm/acpi.h                     |    2 -
 arch/x86/include/asm/amd_nb.h                   |    1 -
 arch/x86/include/asm/apic.h                     |    9 +-
 arch/x86/include/asm/dma.h                      |   12 +-
 arch/x86/include/asm/mmzone_32.h                |   20 -
 arch/x86/include/asm/numa.h                     |   32 ++-
 arch/x86/include/asm/numa_32.h                  |   10 -
 arch/x86/include/asm/numa_64.h                  |   36 --
 arch/x86/include/asm/numaq.h                    |    7 +-
 arch/x86/include/asm/srat.h                     |   39 --
 arch/x86/include/asm/topology.h                 |    7 -
 arch/x86/kernel/apic/apic.c                     |   26 +-
 arch/x86/kernel/apic/apic_noop.c                |    9 -
 arch/x86/kernel/apic/bigsmp_32.c                |    1 -
 arch/x86/kernel/apic/es7000_32.c                |    7 -
 arch/x86/kernel/apic/numaq_32.c                 |   30 +-
 arch/x86/kernel/apic/probe_32.c                 |    1 -
 arch/x86/kernel/apic/summit_32.c                |    1 -
 arch/x86/mm/Makefile                            |    4 +-
 arch/x86/mm/{amdtopology_64.c => amdtopology.c} |   21 +-
 arch/x86/mm/init_32.c                           |    1 +
 arch/x86/mm/init_64.c                           |    8 -
 arch/x86/mm/numa.c                              |  550 ++++++++++++++++++++++-
 arch/x86/mm/numa_32.c                           |  165 +-------
 arch/x86/mm/numa_64.c                           |  519 +---------------------
 arch/x86/mm/numa_emulation.c                    |   16 +-
 arch/x86/mm/numa_internal.h                     |    8 +
 arch/x86/mm/{srat_64.c => srat.c}               |   82 +----
 arch/x86/mm/srat_32.c                           |  287 ------------
 30 files changed, 655 insertions(+), 1260 deletions(-)
 delete mode 100644 arch/x86/include/asm/srat.h
 rename arch/x86/mm/{amdtopology_64.c => amdtopology.c} (90%)
 rename arch/x86/mm/{srat_64.c => srat.c} (67%)
 delete mode 100644 arch/x86/mm/srat_32.c

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1133076
