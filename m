Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab2EVTxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:53:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48215 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2EVTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:53:13 -0400
Date: Tue, 22 May 2012 15:46:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.5-rc0-tag
Message-ID: <20120522194639.GA2820@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.5-rc0-tag

which has:
 * support for 'perf' running. Perf depends on APIC ops to send IPIs, not SMP ops.
   Re-using the existing SMP ops and also adding code to deal IRQ_WORKER vector makes it work.
 * enhancements to the self-ballooning code
 * fix to auto-balloon the initial domain to the original boot-up size (it would
   return to the hypervisor around 1GB of memory that overlapped PCI and non-E820 RAM regions -
   this brings it back).
 * move some of the debugfs code dealing with printing u32 arrays to the generic code-base.
 * allow fronted modules to unload with grants in usage and lazily free them
 * further disintegrate the XenBus and initial domain coupling - so that there can be
   a separate XenBus domain - and the concept of initial domain shrinks even further.
 * perf improvements in the M2P calls to utilize the batching of PTEs.
 * bug-fixes

Please pull!

Ben Guthro (1):
      xen: implement apic ipi interface

Dan Carpenter (1):
      hvc_xen: NULL dereference on allocation failure

Daniel De Graaf (1):
      xenbus: Add support for xenbus backend in stub domain

David Vrabel (1):
      xen/setup: update VA mapping when releasing memory during setup

Jan Beulich (1):
      xen/gnttab: add deferred freeing logic

Jana Saout (1):
      xen: Add selfballoning memory reservation tunable.

Konrad Rzeszutek Wilk (9):
      xen/p2m: Move code around to allow for better re-usage.
      xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
      xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
      xen/p2m: An early bootup variant of set_phys_to_machine
      xen/setup: Only print "Freeing XXX-YYY pfn range: Z pages freed" if Z > 0
      xen/setup: Populate freed MFNs from non-RAM E820 entries and gaps to E820 RAM
      xen/setup: Combine the two hypercall functions - since they are quite similar.
      xen/acpi/sleep: Enable ACPI sleep via the __acpi_os_prepare_sleep
      xen/smp: unbind irqworkX when unplugging vCPUs.

Lin Ming (1):
      xen: implement IRQ_WORK_VECTOR handler

Srivatsa Vaddagiri (1):
      debugfs: Add support to print u32 array in debugfs

Stefano Stabellini (2):
      xen: enter/exit lazy_mmu_mode around m2p_override calls
      xen: do not map the same GSI twice in PVHVM guests.

 arch/x86/include/asm/xen/events.h       |    1 +
 arch/x86/include/asm/xen/page.h         |    1 +
 arch/x86/pci/xen.c                      |    4 +
 arch/x86/xen/debugfs.c                  |  104 -------------------
 arch/x86/xen/debugfs.h                  |    4 -
 arch/x86/xen/enlighten.c                |   13 ++-
 arch/x86/xen/mmu.c                      |   23 ----
 arch/x86/xen/p2m.c                      |  104 +++++++++++--------
 arch/x86/xen/setup.c                    |  171 ++++++++++++++++++++++++++-----
 arch/x86/xen/smp.c                      |  112 +++++++++++++++++++-
 arch/x86/xen/smp.h                      |   12 ++
 arch/x86/xen/spinlock.c                 |   12 +-
 arch/x86/xen/xen-ops.h                  |    1 -
 drivers/tty/hvc/hvc_xen.c               |    4 +-
 drivers/xen/Makefile                    |    2 +-
 drivers/xen/acpi.c                      |   62 +++++++++++
 drivers/xen/events.c                    |    5 +-
 drivers/xen/grant-table.c               |  125 +++++++++++++++++++++--
 drivers/xen/xen-selfballoon.c           |   34 ++++++-
 drivers/xen/xenbus/xenbus_comms.c       |    6 +
 drivers/xen/xenbus/xenbus_comms.h       |    1 +
 drivers/xen/xenbus/xenbus_dev_backend.c |   51 +++++++++
 fs/debugfs/file.c                       |  128 +++++++++++++++++++++++
 include/linux/debugfs.h                 |   11 ++
 include/xen/acpi.h                      |   58 +++++++++++
 include/xen/events.h                    |    3 +
 include/xen/grant_table.h               |    2 +
 include/xen/xenbus_dev.h                |    3 +
 28 files changed, 829 insertions(+), 228 deletions(-)


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPu+0bAAoJEFjIrFwIi8fJYLsH/jOwAs53oFrx167doN/IPahE
DjTDH+hlMfCrp+8Q1VHxUh+EWWW38KEReVvgjlXXGJV93v411MlKaIN1bs9scnEC
lIQlYuUO6HZ5KvrYY6qAxea75ff2vXoIjnGx77DhaIjRJnMWEdeU20pwcY5cmLWf
RwKAsfttHSdT36ohdz09vQB1osr4tBN7VUrqPL1Bp5uVbef1qpWBnM8f/JU+xyQC
vcJhEbyssVKtshCYcWY4SPRokthkH+q0SFz7dpZTRikY9s9h2Hl3I8gytl+siCps
FGSxg/q7i0MXLq5/VN4yTPkU24ij5li7eFhc1w3n0Mzxs/NMWNUMOrTOG9FPUcc=
=KHZQ
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
