Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1HCPj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:39:57 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:59605 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1HCPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:39:53 -0400
Date: Wed, 03 Aug 2011 11:39:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [GIT PATCH] APEI patches for Linux 3.1
Message-id: <alpine.LFD.2.02.1108031137590.22067@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-696493462-1312385979=:22067"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-696493462-1312385979=:22067
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git apei-release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-kernel@vger.kernel.org

 Documentation/acpi/apei/einj.txt  |   11 +-
 arch/Kconfig                      |    3 +
 arch/alpha/Kconfig                |    1 +
 arch/avr32/Kconfig                |    1 +
 arch/frv/Kconfig                  |    1 +
 arch/ia64/Kconfig                 |    1 +
 arch/m68k/Kconfig                 |    1 +
 arch/parisc/Kconfig               |    1 +
 arch/powerpc/Kconfig              |    1 +
 arch/s390/Kconfig                 |    1 +
 arch/sh/Kconfig                   |    1 +
 arch/sparc/Kconfig                |    1 +
 arch/tile/Kconfig                 |    1 +
 arch/x86/Kconfig                  |    1 +
 drivers/acpi/apei/Kconfig         |   11 +-
 drivers/acpi/apei/apei-base.c     |   35 +++-
 drivers/acpi/apei/apei-internal.h |   15 ++-
 drivers/acpi/apei/einj.c          |   43 +++--
 drivers/acpi/apei/erst-dbg.c      |    6 +-
 drivers/acpi/apei/erst.c          |   12 +-
 drivers/acpi/apei/ghes.c          |  431 ++++++++++++++++++++++++++++++++++---
 drivers/acpi/apei/hest.c          |   17 +-
 drivers/acpi/bus.c                |   14 +-
 include/acpi/apei.h               |    5 +
 include/linux/acpi.h              |    2 +
 include/linux/bitmap.h            |    1 +
 include/linux/genalloc.h          |   34 +++-
 include/linux/llist.h             |  126 +++++++++++
 include/linux/mm.h                |    1 +
 lib/Kconfig                       |    3 +
 lib/Makefile                      |    2 +
 lib/bitmap.c                      |    2 -
 lib/genalloc.c                    |  300 +++++++++++++++++++++-----
 lib/llist.c                       |  129 +++++++++++
 mm/memory-failure.c               |   92 ++++++++
 35 files changed, 1172 insertions(+), 135 deletions(-)
 create mode 100644 include/linux/llist.h
 create mode 100644 lib/llist.c

through these commits:

Chen Gong (1):
      ACPI, APEI, ERST, Fix erst-dbg long record reading issue

Huang Ying (16):
      ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
      ACPI, APEI, GHES, Do not ratelimit fatal error printk before panic
      ACPI, APEI, Add apei_exec_run_optional
      ACPI, APEI, Use apei_exec_run_optional in APEI EINJ and ERST
      ACPI, APEI, GHES, Prevent GHES to be built as module
      ACPI, APEI, GHES, Support disable GHES at boot time
      ACPI, APEI, Add APEI bit support in generic _OSC call
      ACPI, APEI, Add WHEA _OSC support
      Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
      lib, Add lock-less NULL terminated single list
      lib, Make gen_pool memory allocator lockless
      ACPI, APEI, GHES, printk support for recoverable error via NMI
      ACPI, APEI, GHES, Error records content based throttle
      HWPoison: add memory_failure_queue()
      ACPI, APEI, GHES: Add hardware memory error recovery support
      ACPI, APEI, EINJ Param support is disabled by default

Len Brown (2):
      ACPI: APEI build fix
      APEI GHES: 32-bit buildfix

with this log:

commit d0e323b47057f4492b8fa22345f38d80a469bf8d
Merge: c027a47 c3e6088
Author: Len Brown <len.brown@intel.com>
Date:   Wed Aug 3 11:30:42 2011 -0400

    Merge branch 'apei' into apei-release
    
    Some trivial conflicts due to other various merges
    adding to the end of common lists sooner than this one.
    
    	arch/ia64/Kconfig
    	arch/powerpc/Kconfig
    	arch/x86/Kconfig
    	lib/Kconfig
    	lib/Makefile
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c3e6088e1036f8084bc7444b38437da136b7588b
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 20 16:09:29 2011 +0800

    ACPI, APEI, EINJ Param support is disabled by default
    
    EINJ parameter support is only usable for some specific BIOS.
    Originally, it is expected to have no harm for BIOS does not support
    it.  But now, we found it will cause issue (memory overwriting) for
    some BIOS.  So param support is disabled by default and only enabled
    when newly added module parameter named "param_extension" is
    explicitly specified.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Acked-by: Don Zickus <dzickus@redhat.com>
    Acked-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 70cb6e1da00db6c9212e6fd69bd96fd41c797077
Author: Len Brown <len.brown@intel.com>
Date:   Tue Aug 2 18:00:21 2011 -0400

    APEI GHES: 32-bit buildfix
    
    drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
    drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression
    
    ghes.c:(.text+0x46289): undefined reference to `__udivdi3'
      in function ghes_estatus_cache_add().
    
    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7e09d450b2e0b068e850d103b6ee1af537d1910
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jul 16 18:14:21 2011 -0400

    ACPI: APEI build fix
    
    as GHES is optional...
    
    When # CONFIG_ACPI_APEI_GHES is not set:
    
    (.init.text+0x4c22): undefined reference to `ghes_disable'
    
    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Acked-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba61ca4aab47441f1c6cec28a9a6aa0489fd1df3
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:28 2011 +0800

    ACPI, APEI, GHES: Add hardware memory error recovery support
    
    memory_failure_queue() is called when recoverable memory errors are
    notified by firmware to do the recovery work.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea8f5fb8a71fddaf5f3a17100d3247855701f732
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:27 2011 +0800

    HWPoison: add memory_failure_queue()
    
    memory_failure() is the entry point for HWPoison memory error
    recovery.  It must be called in process context.  But commonly
    hardware memory errors are notified via MCE or NMI, so some delayed
    execution mechanism must be used.  In MCE handler, a work queue + ring
    buffer mechanism is used.
    
    In addition to MCE, now APEI (ACPI Platform Error Interface) GHES
    (Generic Hardware Error Source) can be used to report memory errors
    too.  To add support to APEI GHES memory recovery, a mechanism similar
    to that of MCE is implemented.  memory_failure_queue() is the new
    entry point that can be called in IRQ context.  The next step is to
    make MCE handler uses this interface too.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: Wu Fengguang <fengguang.wu@intel.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 152cef40a808d3034e383465b3f7d6783613e458
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:26 2011 +0800

    ACPI, APEI, GHES, Error records content based throttle
    
    printk is used by GHES to report hardware errors.  Ratelimit is
    enforced on the printk to avoid too many hardware error reports in
    kernel log.  Because there may be thousands or even millions of
    corrected hardware errors during system running.
    
    Currently, a simple scheme is used.  That is, the total number of
    hardware error reporting is ratelimited.  This may cause some issues
    in practice.
    
    For example, there are two kinds of hardware errors occurred in
    system.  One is corrected memory error, because the fault memory
    address is accessed frequently, there may be hundreds error report
    per-second.  The other is corrected PCIe AER error, it will be
    reported once per-second.  Because they share one ratelimit control
    structure, it is highly possible that only memory error is reported.
    
    To avoid the above issue, an error record content based throttle
    algorithm is implemented in the patch.  Where after the first
    successful reporting, all error records that are same are throttled for
    some time, to let other kinds of error records have the opportunity to
    be reported.
    
    In above example, the memory errors will be throttled for some time,
    after being printked.  Then the PCIe AER error will be printked
    successfully.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 67eb2e99076708cc790019a6a08ca3e0ae130a3a
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:25 2011 +0800

    ACPI, APEI, GHES, printk support for recoverable error via NMI
    
    Some APEI GHES recoverable errors are reported via NMI, but printk is
    not safe in NMI context.
    
    To solve the issue, a lock-less memory allocator is used to allocate
    memory in NMI handler, save the error record into the allocated
    memory, put the error record into a lock-less list.  On the other
    hand, an irq_work is used to delay the operation from NMI context to
    IRQ context.  The irq_work IRQ handler will remove nodes from
    lock-less list, printk the error record and do some further processing
    include recovery operation, then free the memory.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f184275aa306046fe7edcbef3229754f0d97402
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:24 2011 +0800

    lib, Make gen_pool memory allocator lockless
    
    This version of the gen_pool memory allocator supports lockless
    operation.
    
    This makes it safe to use in NMI handlers and other special
    unblockable contexts that could otherwise deadlock on locks.  This is
    implemented by using atomic operations and retries on any conflicts.
    The disadvantage is that there may be livelocks in extreme cases.  For
    better scalability, one gen_pool allocator can be used for each CPU.
    
    The lockless operation only works if there is enough memory available.
    If new memory is added to the pool a lock has to be still taken.  So
    any user relying on locklessness has to ensure that sufficient memory
    is preallocated.
    
    The basic atomic operation of this allocator is cmpxchg on long.  On
    architectures that don't have NMI-safe cmpxchg implementation, the
    allocator can NOT be used in NMI handler.  So code uses the allocator
    in NMI handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f49f23abf3dd786ddcac1c1e7db3c2013b07413f
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:23 2011 +0800

    lib, Add lock-less NULL terminated single list
    
    Cmpxchg is used to implement adding new entry to the list, deleting
    all entries from the list, deleting first entry of the list and some
    other operations.
    
    Because this is a single list, so the tail can not be accessed in O(1).
    
    If there are multiple producers and multiple consumers, llist_add can
    be used in producers and llist_del_all can be used in consumers.  They
    can work simultaneously without lock.  But llist_del_first can not be
    used here.  Because llist_del_first depends on list->first->next does
    not changed if list->first is not changed during its operation, but
    llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
    llist_add) sequence in another consumer may violate that.
    
    If there are multiple producers and one consumer, llist_add can be
    used in producers and llist_del_all or llist_del_first can be used in
    the consumer.
    
    This can be summarized as follow:
    
               |   add    | del_first |  del_all
     add       |    -     |     -     |     -
     del_first |          |     L     |     L
     del_all   |          |           |     -
    
    Where "-" stands for no lock is needed, while "L" stands for lock is
    needed.
    
    The list entries deleted via llist_del_all can be traversed with
    traversing function such as llist_for_each etc.  But the list entries
    can not be traversed safely before deleted from the list.  The order
    of deleted entries is from the newest to the oldest added one.  If you
    want to traverse from the oldest to the newest, you must reverse the
    order by yourself before traversing.
    
    The basic atomic operation of this list is cmpxchg on long.  On
    architectures that don't have NMI-safe cmpxchg implementation, the
    list can NOT be used in NMI handler.  So code uses the list in NMI
    handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit df013ffb8119c89f062ab05b7f544704315db47b
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:22 2011 +0800

    Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
    
    cmpxchg() is widely used by lockless code, including NMI-safe lockless
    code.  But on some architectures, the cmpxchg() implementation is not
    NMI-safe, on these architectures the lockless code may need a
    spin_trylock_irqsave() based implementation.
    
    This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
    NMI-safe lockless code can depend on it or provide different
    implementation according to it.
    
    On many architectures, cmpxchg is only NMI-safe for several specific
    operand sizes. So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch
    only guarantees cmpxchg is NMI-safe for sizeof(unsigned long).
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Acked-by: Mike Frysinger <vapier@gentoo.org>
    Acked-by: Paul Mundt <lethal@linux-sh.org>
    Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Acked-by: Chris Metcalf <cmetcalf@tilera.com>
    Acked-by: Richard Henderson <rth@twiddle.net>
    CC: Mikael Starvik <starvik@axis.com>
    Acked-by: David Howells <dhowells@redhat.com>
    CC: Yoshinori Sato <ysato@users.sourceforge.jp>
    CC: Tony Luck <tony.luck@intel.com>
    CC: Hirokazu Takata <takata@linux-m32r.org>
    CC: Geert Uytterhoeven <geert@linux-m68k.org>
    CC: Michal Simek <monstr@monstr.eu>
    Acked-by: Ralf Baechle <ralf@linux-mips.org>
    CC: Kyle McMartin <kyle@mcmartin.ca>
    CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
    CC: Chen Liqin <liqin.chen@sunplusct.com>
    CC: "David S. Miller" <davem@davemloft.net>
    CC: Ingo Molnar <mingo@redhat.com>
    CC: Chris Zankel <chris@zankel.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9fb0bfe1408d5506b7b83d13d1eed573fd71d67d
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:21 2011 +0800

    ACPI, APEI, Add WHEA _OSC support
    
    APEI firmware first mode must be turned on explicitly on some
    machines, otherwise there may be no GHES hardware error record for
    hardware error notification.  APEI bit in generic _OSC call can be
    used to do that, but on some machine, a special WHEA _OSC call must be
    used.  This patch adds the support to that WHEA _OSC call.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eccddd32ced0df8f9130024157bf8d37df860d76
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:20 2011 +0800

    ACPI, APEI, Add APEI bit support in generic _OSC call
    
    In APEI firmware first mode, hardware error is reported by hardware to
    firmware firstly, then firmware reports the error to Linux in a GHES
    error record via POLL/SCI/IRQ/NMI etc.
    
    This may result in some issues if OS has no full APEI support.  So
    some firmware implementation will work in a back-compatible mode by
    default.  Where firmware will only notify OS in old-fashion, without
    GHES record.  For example, for a fatal hardware error, only NMI is
    signaled, no GHES record.
    
    To gain full APEI power on these machines, APEI bit in generic _OSC
    call can be specified to tell firmware that Linux has full APEI
    support.  This patch adds the APEI bit support in generic _OSC call.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6a9501658530d8b8374e37f1edb549039a8a260
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:19 2011 +0800

    ACPI, APEI, GHES, Support disable GHES at boot time
    
    Some machine may have broken firmware so that GHES and firmware first
    mode should be disabled.  This patch adds support to that.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 86cd47334b00b6aa9b5d0ebf389a6fe76f21c641
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:18 2011 +0800

    ACPI, APEI, GHES, Prevent GHES to be built as module
    
    GHES (Generic Hardware Error Source) is used to process hardware error
    notification in firmware first mode.  But because firmware first mode
    can be turned on but can not be turned off, it is unreasonable to
    unload the GHES module with firmware first mode turned on.  To avoid
    confusion, this patch makes GHES can be enabled/disabled in
    configuration time, but not built as module and unloaded at run time.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 392913de7cc7446531922f29c0a4382d8d09626c
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:17 2011 +0800

    ACPI, APEI, Use apei_exec_run_optional in APEI EINJ and ERST
    
    This patch changes APEI EINJ and ERST to use apei_exec_run for
    mandatory actions, and apei_exec_run_optional for optional actions.
    
    Cc: Thomas Renninger <trenn@novell.com>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eecf2f7124834dd1cad21807526a8ea031ba8217
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:16 2011 +0800

    ACPI, APEI, Add apei_exec_run_optional
    
    Some actions in APEI ERST and EINJ tables are optional, for example,
    ACPI_EINJ_BEGIN_OPERATION action is used to do some preparation for
    error injection, and firmware may choose to do nothing here.  While
    some other actions are mandatory, for example, firmware must provide
    ACPI_EINJ_GET_ERROR_TYPE implementation.
    
    Original implementation treats all actions as optional (that is, can
    have no instructions), that may cause issue if firmware does not
    provide some mandatory actions.  To fix this, this patch adds
    apei_exec_run_optional, which should be used for optional actions.
    The original apei_exec_run should be used for mandatory actions.
    
    Cc: Thomas Renninger <trenn@novell.com>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5588340d46a484da53bbce8136184d9c7fbc259c
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:15 2011 +0800

    ACPI, APEI, GHES, Do not ratelimit fatal error printk before panic
    
    printk is used by GHES to report hardware errors.  Normally, the
    printk will be ratelimited to avoid too many hardware error reports in
    kernel log.  Because there may be thousands or even millions of
    corrected hardware errors during system running.
    
    That is different for fatal hardware error, because system will go
    panic as soon as possible, there will be no more than several error
    records.  And these error records are valuable for system fault
    diagnosis, so they should not be ratelimited.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d37afc50e618271839f001ea653949eefc728167
Author: Chen Gong <gong.chen@linux.intel.com>
Date:   Wed Jul 13 13:14:14 2011 +0800

    ACPI, APEI, ERST, Fix erst-dbg long record reading issue
    
    When we debug ERST table with erst-dbg, if the error record in ERST
    table is too long(>4K), it can't be read out.  So this patch increases
    the buffer size to 16K to ensure such error records can be read from
    ERST table.
    
    Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ca7cc5110a313a609da40ae948978a585352564b
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:13 2011 +0800

    ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
    
    erst_dbg module can not work when ERST is disabled.  So disable module
    loading to provide clearer information to user.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-696493462-1312385979=:22067--
