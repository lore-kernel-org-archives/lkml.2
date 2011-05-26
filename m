Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab1E0BbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:31:24 -0400
Received: from c-67-188-111-120.hsd1.ca.comcast.net ([67.188.111.120]:49739
	"EHLO saboo.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013Ab1E0BbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:31:23 -0400
Message-ID: <4DDEC7D9.1090604@goop.org>
Date: Thu, 26 May 2011 14:36:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Xen internal cleanup stuff
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/tidy-xen-mmu-2.6.39

Jeremy Fitzhardinge (10):
      xen: drop all the special iomap pte paths.
      xen: use mmu_update for xen_set_pte_at()
      xen: condense everything onto xen_set_pte
      vmalloc: remove vmalloc_sync_all() from alloc_vm_area()
      xen: make a pile of mmu pvop functions static
      xen: use normal virt_to_machine for ptes
      xen/mmu: remove all ad-hoc stats stuff
      Use arbitrary_virt_to_machine() to deal with ioremapped pmd updates.
      Use arbitrary_virt_to_machine() to deal with ioremapped pud updates.
      xen: fix compile without CONFIG_XEN_DEBUG_FS

 arch/x86/xen/mmu.c |  284 +++++++++------------------------------------------
 arch/x86/xen/mmu.h |   37 -------
 mm/vmalloc.c       |    4 -
 3 files changed, 50 insertions(+), 275 deletions(-)


This is all Xen-internal cleanup stuff.  The change to mm/vmalloc.c is
to remove a pointless vmalloc_sync_all() from alloc_vm_area(). 
alloc_vm_area() is only called by Xen code, though there's nothing
Xen-specific about it.

Thanks,
    J
