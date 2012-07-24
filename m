Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2GXCGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:06:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28235 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2GXCGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:06:04 -0400
Date: Mon, 23 Jul 2012 21:57:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
Subject: What went in Linux 3.5 from Xen standpoint.
Message-ID: <20120724015703.GA10884@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Linus released this Saturday v3.5 and there were quite a few
of interesting components/fixes/features that went in!

Going to go down the list of what shortlog provided:
 - Less MSR traps when using AMD machines - so better performance. [andre]
 - The APIC IPI interface works - which means that 'perf' in the initial
   domain works. So no more lockups. Also with some tweaks, that means kdb
   can work as well [ben]
 - Static analyzer fixes in hvc [dan]
 - The march to make HVM domains driver domains continue - the XenBus
   in the initial domain can now search for it in another domain instead
   of assuming its in the initial domain [daniel]. Marek also expanded netfront
   to now work in initial domain. [marek]
 - Memory reported by 'xm list' for the initial domain now matches what
   the kernel has been booted with. In the past it would be around 1GB
   less due to the kernel releasing memory that fall within
   E820 gaps/PCI space [david and me]
 - The bootup on two-socket or more of AMD cpus works correctly (I put
   in a temporary way in v3.4) but Lin implemented the correct way [lin, jeremy and me]
 - Make xen-blkfront capable of unloading. This requires some extra
   infrastructure work to handle delayed grants [jan]
 - Fixes in the hvc drivers for PVonHVM guests started with 'xm' (not xl!) would
   fail during migration. [me]
 - Fix in blkback with discard operation in 32/64 (so 32-bit guest, 64-bit dom0) mix would fail.
 - Support for 'perf' to work in the initial domain [lin]
 - PVonHVM guests on their reboot would not release properly event channels
   so would consume additional memory [stefano]
 - Make it possible for the upstream QEMU run in the initial domain along with
   blkfront (and blkback) to allow QCOW images to be mapped [stefano]
 - Fix for mulitple PCI domains to not crash during bootup [zhang]
 - Fix to make FLR actually do properly FLR in xen-pciback. [me]

And the full list:

Andre Przywara (1):
      xen/setup: filter APERFMPERF cpuid feature out

Ben Guthro (1):
      xen: implement apic ipi interface

Dan Carpenter (1):
      hvc_xen: NULL dereference on allocation failure

Daniel De Graaf (1):
      xenbus: Add support for xenbus backend in stub domain

David Vrabel (1):
      xen/setup: update VA mapping when releasing memory during setup

H. Peter Anvin (1):
      xen-acpi-processor: Add missing #include <xen/xen.h>

Ingo Molnar (2):
      x86/apic: Fix UP boot crash
      x86/xen/apic: Add missing #include <xen/xen.h>

Jan Beulich (3):
      xen/gnttab: add deferred freeing logic
      xen-blkfront: properly name all devices
      xen-blkfront: module exit handling adjustments

Jana Saout (1):
      xen: Add selfballoning memory reservation tunable.

Konrad Rzeszutek Wilk (20):
      xen/p2m: Move code around to allow for better re-usage.
      xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
      xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
      xen/p2m: An early bootup variant of set_phys_to_machine
      PCI: move mutex locking out of pci_dev_reset function
      x86/apic: Replace io_apic_ops with x86_io_apic_ops.
      xen/x86: Implement x86_apic_ops
      Revert "xen/x86: Workaround 'x86/ioapic: Add register level checks to detect bogus io-apic entries'"
      xen/setup: Only print "Freeing XXX-YYY pfn range: Z pages freed" if Z > 0
      xen/setup: Populate freed MFNs from non-RAM E820 entries and gaps to E820 RAM
      xen/setup: Combine the two hypercall functions - since they are quite similar.
      xen/acpi/sleep: Enable ACPI sleep via the __acpi_os_prepare_sleep
      xen/smp: unbind irqworkX when unplugging vCPUs.
      xen/hvc: Collapse error logic.
      xen/hvc: Fix error cases around HVM_PARAM_CONSOLE_PFN
      xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for correctness.
      xen/events: Add WARN_ON when quick lookup found invalid type.
      xen/balloon: Subtract from xen_released_pages the count that is populated.
      xen/blkback: Copy id field when doing BLKIF_DISCARD.
      xen/blkfront: Add WARN to deal with misbehaving backends.

Lin Ming (2):
      xen/apic: implement io apic read with hypercall
      xen: implement IRQ_WORK_VECTOR handler

Marek Marczykowski (1):
      xen: do not disable netfront in dom0

Srivatsa Vaddagiri (1):
      debugfs: Add support to print u32 array in debugfs

Stefano Stabellini (3):
      xen: enter/exit lazy_mmu_mode around m2p_override calls
      xen: do not map the same GSI twice in PVHVM guests.
      xen: mark local pages as FOREIGN in the m2p_override

Zhang, Yang Z (1):
      xen/pci: Check for PCI bridge before using it.

