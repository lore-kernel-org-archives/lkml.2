Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1C1PKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:10:17 -0400
Received: from kroah.org ([198.145.64.141]:58836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1C1PKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:10:13 -0400
Date: Mon, 28 Mar 2011 08:09:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.9
Message-ID: <20110328150948.GA26598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.9 kernel.

This is primarily for the use of those people who are stuck using the
.33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

I'll be maintaining it for a while longer as it looks like the -rt tree
isn't moving forward to any newer kernel any time soon.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/instantiating-devices |    2 -
 Makefile                                |    2 -
 arch/parisc/kernel/irq.c                |    2 -
 arch/powerpc/kernel/crash.c             |   27 +++++++++++++++++++
 arch/powerpc/kernel/rtas_flash.c        |   39 ++++++++++++++-------------
 arch/x86/kernel/entry_64.S              |    2 -
 arch/x86/kernel/head64.c                |    3 --
 arch/x86/kernel/setup.c                 |    5 +++
 arch/x86/mm/init.c                      |   19 -------------
 arch/x86/mm/init_64.c                   |   11 ++++---
 arch/x86/xen/mmu.c                      |   13 ++++-----
 drivers/firmware/dcdbas.c               |    4 ++
 drivers/hwmon/sht15.c                   |    4 +-
 drivers/input/xen-kbdfront.c            |   45 +++++++++++++++++---------------
 drivers/media/video/uvc/uvc_driver.c    |    8 +++++
 drivers/media/video/uvc/uvc_video.c     |   14 ++++++---
 drivers/mmc/core/sdio.c                 |    8 +++++
 drivers/pci/hotplug/acpiphp_glue.c      |    1 
 drivers/pci/pci-sysfs.c                 |    7 ++++
 drivers/pci/quirks.c                    |   20 --------------
 drivers/usb/class/cdc-acm.c             |    7 ++++
 drivers/usb/host/ehci-q.c               |   12 --------
 drivers/usb/misc/uss720.c               |    7 ++--
 drivers/video/console/tileblit.c        |    2 -
 fs/aio.c                                |    4 +-
 fs/dcache.c                             |    3 ++
 fs/ext3/super.c                         |    7 ++++
 fs/nfsd/nfs4proc.c                      |    4 +-
 fs/nfsd/nfs4xdr.c                       |    5 ---
 fs/proc/array.c                         |    4 +-
 fs/proc/task_mmu.c                      |    4 +-
 kernel/signal.c                         |   16 ++++++++---
 kernel/smp.c                            |   13 +++++++--
 mm/shmem.c                              |    1 
 net/sunrpc/xprtsock.c                   |    2 +
 sound/pci/hda/patch_via.c               |   14 +++++++--
 36 files changed, 196 insertions(+), 145 deletions(-)

Aaro Koskinen (1):
      procfs: fix /proc/<pid>/maps heap check

Alan Stern (1):
      ehci-hcd: Bug fix: don't set a QH's Halt bit

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Greg Kroah-Hartman (2):
      Revert "intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang"
      Linux 2.6.33.9

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Hugh Dickins (1):
      shmem: let shared anonymous be nonlinear again

Johan Hovold (3):
      USB: cdc-acm: fix memory corruption / panic
      USB: cdc-acm: fix potential null-pointer dereference
      USB: cdc-acm: fix potential null-pointer dereference on disconnect

Josef Bacik (1):
      fs: call security_d_instantiate in d_obtain_alias V2

Julien Tinnes (1):
      Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code

Kees Cook (1):
      proc: protect mm start_code/end_code in /proc/pid/stat

Laurent Pinchart (1):
      uvcvideo: Fix descriptor parsing for video output devices

Lydia Wang (2):
      ALSA: hda - VIA: Fix stereo mixer recording no sound issue
      ALSA: hda - VIA: Add missing support for VT1718S in A-A path

Mi Jinlong (2):
      nfsd41: modify the members value of nfsd4_op_flags
      nfsd: wrong index used in inner loop

Michael Neuling (1):
      powerpc/kdump: Fix race in kdump shutdown

Michal Schmidt (1):
      PCI: return correct value when writing to the "reset" attribute

Milton Miller (2):
      smp_call_function_many: handle concurrent clearing of mask
      powerpc: rtas_flash needs to use rtas_data_buf

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Peter Holik (1):
      USB: uss720 fixup refcount position

Roland Dreier (1):
      aio: wake all waiters when destroying ctx

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Stefano Stabellini (2):
      PCI hotplug: acpiphp: set current_state to D0 in register_slot
      xen: set max_pfn_mapped to the last pfn mapped

Stephan Lachowsky (1):
      uvcvideo: Fix uvc_fixup_video_ctrl() format search

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Thomas Gleixner (1):
      fix per-cpu flag problem in the cpu affinity checkers

Trond Myklebust (1):
      SUNRPC: Never reuse the socket port after an xs_close()

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

Yinghai Lu (1):
      x86: Cleanup highmap after brk is concluded

