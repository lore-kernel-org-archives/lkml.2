Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2D0Xhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:37:34 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:52537 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2D0Xhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:37:32 -0400
Subject: [PATCH 0/4] Physical memory info formatting
To: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 27 Apr 2012 17:37:30 -0600
Message-ID: <20120427233620.25317.67562.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no functional changes in these patches; they just add a little
consistency to printing out physical memory information.

For example:

    -BIOS-provided physical RAM map:
    +e820: BIOS-provided physical RAM map:
    - BIOS-e820: 0000000000000100 - 000000000009e000 (usable)
    +BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
    - BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
    +BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved

    -found SMP MP-table at [ffff8800000fce90] fce90
    +found SMP MP-table at [mem 0x000fce90-0x000fce9f] mapped at [ffff8800000fce90]
    -initial memory mapped : 0 - 20000000
    +initial memory mapped: [mem 0x00000000-0x1fffffff]
    -Base memory trampoline at [ffff88000009c000] 9c000 size 8192
    +Base memory trampoline [mem 0x0009c000-0x0009dfff] mapped at [ffff88000009c000]

    -SRAT: Node 0 PXM 0 0-80000000
    +SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]

    -NUMA: Node 0 [0,80000000) + [100000000,880000000) -> [0,880000000)
    +NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]

    ...

---

Bjorn Helgaas (4):
      x86: print e820 physical addresses consistently with other parts of kernel
      x86: print physical addresses consistently with other parts of kernel
      swiotlb: print physical addresses consistently with other parts of kernel
      mm: print physical addresses consistently with other parts of kernel


 arch/x86/kernel/e820.c       |   53 +++++++++++++++++++++---------------------
 arch/x86/kernel/mpparse.c    |   10 +++++---
 arch/x86/kernel/setup.c      |   16 ++++++-------
 arch/x86/kernel/trampoline.c |    5 ++--
 arch/x86/mm/init.c           |   16 +++++++------
 arch/x86/mm/numa.c           |   32 +++++++++++++------------
 arch/x86/mm/numa_emulation.c |    4 ++-
 arch/x86/mm/pat.c            |   42 +++++++++++++++------------------
 arch/x86/mm/srat.c           |    5 ++--
 lib/swiotlb.c                |    8 ++----
 mm/memory_hotplug.c          |   14 ++++++-----
 mm/page_alloc.c              |   19 +++++++++------
 12 files changed, 115 insertions(+), 109 deletions(-)

-- 
Bjorn
