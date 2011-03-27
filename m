Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1C0W77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 18:59:59 -0400
Received: from kroah.org ([198.145.64.141]:53019 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab1C0W75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 18:59:57 -0400
Date: Sun, 27 Mar 2011 15:57:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.2
Message-ID: <20110327225754.GA23206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.2 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                                   |    2 
 arch/arm/mach-s3c2440/mach-mini2440.c      |    7 +
 arch/sh/kernel/ptrace_32.c                 |    8 +
 arch/sh/kernel/ptrace_64.c                 |    6 +
 arch/x86/kernel/entry_32.S                 |    2 
 arch/x86/kernel/head64.c                   |    3 
 arch/x86/kernel/setup.c                    |    5 
 arch/x86/mm/init.c                         |   19 ---
 arch/x86/mm/init_64.c                      |   11 +-
 arch/x86/xen/mmu.c                         |   13 +-
 drivers/firmware/dcdbas.c                  |    4 
 drivers/gpu/drm/drm_crtc.c                 |   51 +++++++++
 drivers/gpu/drm/drm_gem.c                  |    5 
 drivers/gpu/drm/i915/i915_gem.c            |    6 -
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   21 +++
 drivers/gpu/drm/radeon/atombios_crtc.c     |    6 -
 drivers/gpu/drm/radeon/radeon_combios.c    |   21 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   30 +++++
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 
 drivers/input/xen-kbdfront.c               |   44 ++++----
 drivers/media/video/uvc/uvc_driver.c       |    8 +
 drivers/media/video/uvc/uvc_video.c        |   14 +-
 drivers/pci/hotplug/acpiphp_glue.c         |    1 
 drivers/usb/class/cdc-acm.c                |    7 +
 drivers/usb/class/cdc-wdm.c                |    2 
 drivers/usb/core/devio.c                   |    2 
 drivers/usb/host/ehci-q.c                  |   12 --
 drivers/usb/misc/uss720.c                  |    7 -
 drivers/usb/musb/blackfin.c                |    6 -
 drivers/video/console/tileblit.c           |    2 
 fs/aio.c                                   |    4 
 fs/dcache.c                                |    3 
 fs/ext3/super.c                            |    7 +
 fs/ext4/super.c                            |    8 +
 fs/namespace.c                             |   16 --
 fs/nfs/write.c                             |   31 +++--
 fs/nfsd/nfs4proc.c                         |    4 
 fs/nfsd/nfs4state.c                        |  155 +++++++++++++++--------------
 fs/nfsd/nfs4xdr.c                          |    5 
 fs/proc/array.c                            |    4 
 fs/proc/task_mmu.c                         |    4 
 fs/super.c                                 |    2 
 fs/sync.c                                  |    4 
 include/linux/compaction.h                 |    9 -
 include/linux/ethtool.h                    |   34 ++++++
 include/linux/mm.h                         |   11 +-
 kernel/cgroup.c                            |   14 +-
 kernel/perf_event.c                        |   13 +-
 kernel/signal.c                            |   16 ++
 kernel/sysctl.c                            |   18 +++
 mm/backing-dev.c                           |    2 
 mm/compaction.c                            |   24 ----
 mm/oom_kill.c                              |   50 +++++----
 mm/page_alloc.c                            |    4 
 mm/shmem.c                                 |    1 
 mm/slab.c                                  |    8 -
 mm/swapfile.c                              |    7 +
 mm/vmscan.c                                |   18 ---
 net/socket.c                               |  114 ++++++++++++++++++++-
 net/sunrpc/xprtsock.c                      |    2 
 sound/pci/hda/patch_realtek.c              |   25 +++-
 sound/pci/hda/patch_sigmatel.c             |   18 +++
 sound/pci/hda/patch_via.c                  |   53 +++++++--
 sound/soc/codecs/uda134x.c                 |    3 
 sound/soc/samsung/s3c24xx_uda134x.c        |    3 
 65 files changed, 688 insertions(+), 332 deletions(-)


Aaro Koskinen (1):
      procfs: fix /proc/<pid>/maps heap check

Al Viro (1):
      fix deadlock in pivot_root()

Alan Stern (1):
      ehci-hcd: Bug fix: don't set a QH's Halt bit

Alex Deucher (2):
      drm/radeon/kms: prefer legacy pll algo for tv-out
      drm/radeon/kms: fix hardcoded EDID handling

Amir Goldstein (2):
      ext3: skip orphan cleanup on rocompat fs
      ext4: skip orphan cleanup if fs has unknown ROCOMPAT features

Andrea Arcangeli (2):
      mm: compaction: prevent kswapd compacting memory to reduce CPU usage
      mm: PageBuddy and mapcount robustness

Andrey Vagin (1):
      oom: skip zombies when iterating tasklist

Ben Hutchings (1):
      ethtool: Compat handling for struct ethtool_rxnfc

Bob Liu (1):
      usb: musb: blackfin: fix typo in new dev_pm_ops struct

Chris Wilson (2):
      drm/i915: Disable pagefaults along execbuffer relocation fast path
      drm: Fix use-after-free in drm_gem_vm_close()

Dave Airlie (1):
      drm: check for modesetting on modeset ioctls

David Engraf (1):
      sh: Fix ptrace hw_breakpoint handling

David Henningsson (2):
      ALSA: HDA: Realtek: Avoid unnecessary volume control index on Surround/Side
      ALSA: HDA: Fix internal mic on Dell E5420/E5520

David Rientjes (2):
      oom: prevent unnecessary oom kills or kernel panics
      oom: avoid deferring oom killer if exiting task is being traced

Greg Kroah-Hartman (1):
      Linux 2.6.38.2

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Herton Ronaldo Krzesinski (1):
      drm/i915: Prevent racy removal of request from client list

Hugh Dickins (1):
      shmem: let shared anonymous be nonlinear again

J. Bruce Fields (2):
      nfsd4: minor nfs4state.c reshuffling
      nfsd4: fix struct file leak

Jens Axboe (1):
      fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away

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

Lydia Wang (6):
      ALSA: hda - VIA: Fix stereo mixer recording no sound issue
      ALSA: hda - VIA: Fix independent headphone no sound issue
      ALSA: hda - VIA: Add missing support for VT1718S in A-A path
      ALSA: hda - VIA: Fix invalid A-A path volume adjust issue
      ALSA: hda - VIA: Fix codec type for VT1708BCE at the right timing
      ALSA: hda - VIA: Fix VT1708 can't build up Headphone control issue

Marek Belisko (1):
      ASoC: mini2440: Fix uda134x codec problem.

Mel Gorman (1):
      mm: swap: unlock swapfile inode mutex before closing file on bad swapfiles

Mi Jinlong (2):
      nfsd41: modify the members value of nfsd4_op_flags
      nfsd: wrong index used in inner loop

Michal Sojka (1):
      USB: Do not pass negative length to snoop_urb()

Mike Frysinger (2):
      usb: musb: blackfin: fix typo in platform driver name
      usb: musb: blackfin: fix typo in new bfin_musb_vbus_status func

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Pekka Enberg (1):
      Revert "slab: Fix missing DEBUG_SLAB last user"

Peter Holik (1):
      USB: uss720 fixup refcount position

Peter Zijlstra (1):
      perf: Fix tear-down of inherited group events

Phil Carmody (1):
      cgroups: if you list_empty() a head then don't list_del() it

Phil Edworthy (1):
      sh: Fix ptrace fpu state initialisation

Richard Weinberger (1):
      sysctl: restrict write access to dmesg_restrict

Robert Lukassen (1):
      USB: Fix 'bad dma' problem on WDM device disconnect

Roland Dreier (1):
      aio: wake all waiters when destroying ctx

Sedat Dilek (1):
      x86: Fix binutils-2.21 symbol related build failures

Stefano Stabellini (2):
      PCI hotplug: acpiphp: set current_state to D0 in register_slot
      xen: set max_pfn_mapped to the last pfn mapped

Stephan Lachowsky (1):
      uvcvideo: Fix uvc_fixup_video_ctrl() format search

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Trond Myklebust (2):
      NFS: Fix a hang/infinite loop in nfs_wb_page()
      SUNRPC: Never reuse the socket port after an xs_close()

Yinghai Lu (1):
      x86: Cleanup highmap after brk is concluded

