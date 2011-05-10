Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1EJCuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 22:50:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775Ab1EJCuN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 22:50:13 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 May 2011 19:49:48 -0700
Message-ID: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
Subject: Linux 2.6.39-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So things have been pretty quiet, and unless something major comes up
I believe that this will be the last -rc.

There's only about a hundred commits here, and the bulk of the diffs
are to fs/hpfs which has been marked as BROKEN since early in the
merge window because of the final BKL removal. So it is a regression
fix. That said, I admittedly considered just leaving hpfs broken for
the 39 release and doing this fix series in the next merge window.
Whatever. Might as well take it now, since it has no impact outside of
hpfs, and certainly thus couldn't make things -worse-.

Outside of the hpfs patches, there really isn't all that much
interesting going on. Some hw breakpoint ptrace races, some cifs
updates, and then just random small fixes, mostly to drivers. Nothing
noticeable really stands out, it really has been pretty quiet.

But please do test, just to make sure that 39-final is good.

                      Linus

---
Alan Stern (1):
      USB: fix regression in usbip by setting has_tt flag

Alex Deucher (2):
      drm/radeon/kms: ATPX switcheroo fixes
      drm/radeon/kms: add pci id to acer travelmate quirk for 5730

Alex Williamson (1):
      drm/i915/lvds: Only act on lid notify when the device is on

Andiry Xu (1):
      xHCI: Clear PLC in xhci_bus_resume()

Arjan van de Ven (1):
      Regression: partial revert "tracing: Remove lock_depth from event entry"

Arvid Brodin (1):
      usb/isp1760: Report correct urb status after unlink

Axel Lin (1):
      mfd: Fix usbhs_enable error handling

B.J. Buchalter (1):
      firewire: Fix for broken configrom updates in quick succession

Ben Gardiner (4):
      ASoC: davinci-mcasp: correct tdm_slots limit
      davinci-mcasp: use bitfield definitions for PDIR
      davinci-mcasp: fix _CBM_CFS hw_params
      davinci-mcasp: fix _CBM_CFS pin directions

Chris Wilson (4):
      drm/i915: Release object along create user fb error path
      drm/i915/dp: Be paranoid in case we disable a DP before it is attached
      drm/i915: Only enable the plane after setting the fb base (pre-ILK)
      drm/i915: fix intel_crtc_clock_get pipe reads after "cleanup cleanup"

Daniel Vetter (1):
      drm: mm: fix debug output

Eric Paris (3):
      SELinux: pass last path component in may_create
      flex_array: flex_array_prealloc takes a number of elements, not an end
      flex_arrays: allow zero length flex arrays

Frederic Weisbecker (6):
      ptrace: Prepare to fix racy accesses on task breakpoints
      x86, hw_breakpoints: Fix racy access to ptrace breakpoints
      powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
      arm, hw_breakpoints: Fix racy access to ptrace breakpoints
      sh, hw_breakpoints: Fix racy access to ptrace breakpoints
      hw_breakpoints, powerpc: Fix CONFIG_HAVE_HW_BREAKPOINT off-case
in ptrace_set_debugreg()

Greg Ungerer (2):
      arm: at91: minimal defconfig for at91x40 SoC
      arm: at91: fix compiler warning for eb01 board build

Harry Wei (1):
      staging: Remove a warning for drivers/staging/wlan-ng/cfg80211.c

Henry C Chang (2):
      libceph: fix ceph_msg_new error path
      ceph: handle ceph_osdc_new_request failure in ceph_writepages_start

Herton Ronaldo Krzesinski (1):
      [media] v4l: make sure drivers supply a zeroed struct v4l2_subdev

Hugh Dickins (1):
      vm: fix vm_pgoff wrap in upward expansion

Hussam Al-Tayeb (1):
      [media] rc_core: avoid kernel oops when rmmod saa7134

Ilija Hadzic (1):
      drm/radeon: fix order of doing things in radeon_crtc_cursor_set

James Bottomley (1):
      [SCSI] fix oops in scsi_run_queue()

Jarkko Nikula (2):
      usb: musb: omap2430: Fix retention idle on musb peripheral only boards
      usb: musb: gadget: Fix out-of-sync runtime pm calls

Jarod Wilson (4):
      [media] mceusb: add Dell transceiver ID
      [media] ite-cir: modular build on ppc requires delay.h include
      [media] rc: show RC_TYPE_OTHER in sysfs
      [media] imon: add conditional locking in change_protocol

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: Add ARCH_ID and basic cpu macros definition for 5series
chips family.

Jeff Layton (5):
      cifs: change bleft in decode_unicode_ssetup back to signed type
      cifs: check for bytes_remaining going to zero in CIFS_SessSetup
      cifs: sanitize length checking in coalesce_t2 (try #3)
      cifs: refactor mid finding loop in cifs_demultiplex_thread
      cifs: handle errors from coalesce_t2

Jeff Mahoney (5):
      staging: olpc: Add <linux/delay.h>
      staging: gma500: Depend on X86
      staging: rts_pstor: Add <linux/vmalloc.h>
      staging: rts_pstor: use #ifdef instead of #if
      staging: ft1000: Remove unnecessary EXPORT_SYMBOLs

Jimmy Rentz (1):
      drm/nouveau: Fix a crash at card takedown for NV40 and older cards

Keshava Munegowda (1):
      omap:usb: add regulator support for EHCI

Lin Ming (1):
      perf tools: Makefile: Use gcc to determine ARCH

Linus Torvalds (2):
      VM: skip the stack guard page lookup in get_user_pages only for mlock
      Linux 2.6.39-rc7

Malcolm Priestley (1):
      [media] Missing frontend config for LME DM04/QQBOX

Manoj Iyer (1):
      thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.

Mark Brown (2):
      ASoC: Fix CODEC name in Goni
      ASoC: Fix CODEC DAI names for Goni

Matthew Garrett (1):
      eeepc-laptop: Use ACPI handle to identify rfkill port

Mattia Dongili (2):
      sony-laptop: report failures on setting LCD brightness
      sony-laptop: limit brightness range to DSDT provided ones

Max Vozeler (1):
      staging: usbip: vhci: fix oops on subsequent attach

Mikulas Patocka (15):
      HPFS: Make HPFS compile on preempt and SMP
      HPFS: Introduce a global mutex and lock it on every callback from VFS.
      HPFS: Remove remaining locks
      HPFS: Remove CR/LF conversion option
      HPFS: Remove mark_inode_dirty
      HPFS: Use types with defined width
      HPFS: When marking or clearing the dirty bit, sync the filesystem
      HPFS: Restrict uid and gid to 16-bit values
      HPFS: Fix a bug that filesystem was not marked dirty when remounting it
      HPFS: Implement fsync for hpfs
      HPFS: Fix endianity. Make hpfs work on big-endian machines
      HPFS: Fix some unaligned accesses
      HPFS: Move declaration up, so that there are no out-of-scope pointers
      HPFS: Remove unused variable
      Don't lock guardpage if the stack is growing up

Oliver Endriss (1):
      [media] ngene: Fix CI data transfer regression     Fix CI data
transfer regression introduced by previous cleanup.

Peter Foley (1):
      staging: solo6x10: add select SND_PCM to fix build error

Peter Zijlstra (1):
      perf events, x86: Fix Intel Nehalem and Westmere last level
cache event definitions

Randy Dunlap (1):
      staging: intel_sst: intelmid needs delay.h

Sage Weil (3):
      ceph: use ihold() when i_lock is held
      libceph: fix ceph_osdc_alloc_request error checks
      ceph: do not call __mark_dirty_inode under i_lock

Thomas Gleixner (1):
      slub: Fix the lockless code on 32-bit platforms with no 64-bit cmpxchg

Timo Warns (1):
      Validate size of EFI GUID partition entries.

Uwe Kleine-König (1):
      ARM: at91: AT91CAP9 has a macb device
