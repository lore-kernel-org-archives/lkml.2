Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0LCR35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:29:57 -0500
Received: from claw.goop.org ([74.207.240.146]:43538 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab0LCR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:29:56 -0500
Message-ID: <4CF92911.8060704@goop.org>
Date: Fri, 03 Dec 2010 09:29:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@kernel.org>
Subject: [GIT PULL] Xen fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another handful of Xen fixes:

    * Fix a hang-on-shutdown regression introduced by 76fac077db6b34e2
      ("x86, kexec: Make sure to stop all CPUs before exiting the
      kernel") [Also for stable]
    * Fix crash-on-boot regression on 32-bit systems, caused by
      b40827fa7268 ("x86-32, mm: Add an initial page table for core
      bootstrapping")
    * Avoid using memory that's inaccessible on 32-bit systems without
      HIGHMEM
    * Don't assume NUMA node 0 is always present when allocating irq descs
    * Kill Xen's private idle implementation in favour of using default_idle
    * Simplify boot-time E820 mangling, which fixes a couple of corner cases

There are two branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/core

Jeremy Fitzhardinge (4):
      xen: clean up "extra" memory handling some more
      xen: use default_idle
      xen: prevent crashes with non-HIGHMEM 32-bit kernels with largeish memory
      xen: allocate irq descs on any NUMA node

 arch/x86/xen/setup.c  |   41 ++++++++++++++---------------------------
 drivers/xen/balloon.c |   12 ++++++++++--
 drivers/xen/events.c  |    4 ++--
 3 files changed, 26 insertions(+), 31 deletions(-)

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/bugfix

Ian Campbell (1):
      xen: x86/32: perform initial startup on initial_page_table

Jeremy Fitzhardinge (1):
      xen: don't bother to stop other cpus on shutdown/reboot

 arch/x86/xen/enlighten.c |    6 ----
 arch/x86/xen/mmu.c       |   69 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 19 deletions(-)

Thanks,
	J

