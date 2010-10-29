Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab0J2RZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:25:31 -0400
Received: from kroah.org ([198.145.64.141]:59313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934190Ab0J2RZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:25:28 -0400
Date: Fri, 29 Oct 2010 10:23:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.25
Message-ID: <20101029172318.GC17043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.25 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/powerpc/kernel/head_64.S               |   18 +++++--
 arch/um/drivers/ubd_kern.c                  |    9 ++-
 arch/x86/include/asm/amd_iommu_types.h      |   18 +++++++
 arch/x86/kernel/Makefile                    |    2 
 arch/x86/kernel/amd_iommu.c                 |    4 +
 arch/x86/kernel/amd_iommu_init.c            |   67 ++++++++++++++++++----------
 arch/x86/kernel/apic/io_apic.c              |   11 +++-
 arch/x86/kernel/cpu/common.c                |    4 -
 arch/x86/kernel/cpu/cpu.h                   |    1 
 arch/x86/kernel/cpu/intel.c                 |    1 
 arch/x86/kernel/cpu/mcheck/mce_amd.c        |    9 +--
 arch/x86/kernel/hpet.c                      |    2 
 arch/x86/oprofile/nmi_int.c                 |    1 
 block/bsg.c                                 |    2 
 drivers/acpi/acpica/aclocal.h               |    1 
 drivers/acpi/blacklist.c                    |   16 ++++++
 drivers/acpi/processor_core.c               |    6 --
 drivers/dma/mv_xor.c                        |    2 
 drivers/i2c/busses/i2c-pca-isa.c            |   12 +++--
 drivers/i2c/busses/i2c-pca-platform.c       |   11 ++--
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |    6 +-
 drivers/input/joydev.c                      |    3 +
 drivers/media/video/cx231xx/cx231xx-cards.c |   14 +++--
 drivers/media/video/saa7134/saa7134-core.c  |   13 -----
 drivers/media/video/saa7134/saa7134-ts.c    |   13 +++++
 drivers/media/video/v4l2-compat-ioctl32.c   |   32 ++++++++-----
 drivers/mmc/host/sdhci-s3c.c                |    6 +-
 drivers/net/atlx/atl1.c                     |    5 +-
 drivers/net/b44.c                           |    4 -
 drivers/net/netxen/netxen_nic_init.c        |    3 -
 drivers/net/r6040.c                         |   12 ++---
 drivers/net/r8169.c                         |   12 ++---
 drivers/net/skge.c                          |   18 +++++++
 drivers/pci/quirks.c                        |   20 ++++++++
 drivers/usb/core/file.c                     |   35 ++++++--------
 drivers/usb/core/message.c                  |    1 
 drivers/usb/musb/musb_gadget.c              |   22 +++++++--
 drivers/usb/musb/musb_gadget.h              |    2 
 drivers/usb/musb/musb_gadget_ep0.c          |    9 +++
 fs/exec.c                                   |   14 +++++
 fs/ocfs2/symlink.c                          |    2 
 fs/proc/task_mmu.c                          |    3 -
 include/drm/drm_pciids.h                    |    2 
 include/linux/mm.h                          |    6 ++
 include/linux/pci_ids.h                     |    3 +
 include/linux/socket.h                      |    2 
 kernel/hrtimer.c                            |   13 ++++-
 kernel/sched.c                              |    7 --
 kernel/trace/ring_buffer.c                  |    2 
 mm/mlock.c                                  |    6 --
 net/core/ethtool.c                          |    2 
 net/core/iovec.c                            |    5 +-
 net/core/stream.c                           |    8 +--
 net/ipv4/ip_output.c                        |   19 +++++--
 net/ipv4/route.c                            |    7 ++
 net/ipv4/tcp.c                              |    9 ++-
 net/ipv4/tcp_input.c                        |    2 
 net/ipv4/xfrm4_policy.c                     |    4 -
 net/ipv6/ip6_output.c                       |   18 +++++--
 net/ipv6/route.c                            |   28 ++++++++++-
 net/phonet/af_phonet.c                      |    4 +
 net/phonet/pep.c                            |    3 -
 net/phonet/pn_dev.c                         |   12 ++++-
 net/phonet/pn_netlink.c                     |    9 +++
 net/rds/page.c                              |   27 ++---------
 net/rose/af_rose.c                          |    4 -
 net/wireless/wext.c                         |    2 
 sound/core/control.c                        |    5 ++
 sound/core/rawmidi.c                        |    4 +
 sound/pci/hda/patch_analog.c                |    1 
 sound/pci/oxygen/oxygen.c                   |    4 +
 sound/pci/rme9652/hdsp.c                    |    1 
 sound/pci/rme9652/hdspm.c                   |    1 
 74 files changed, 453 insertions(+), 215 deletions(-)

Alan Stern (1):
      USB: fix bug in initialization of interface minor numbers

Ben Hutchings (1):
      r6040: Fix multicast list iteration when hash filter is used

Borislav Petkov (1):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order

Clemens Ladisch (1):
      ALSA: rawmidi: fix oops (use after free) when unloading a driver module

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Dan Rosenberg (2):
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      ALSA: prevent heap corruption in snd_ctl_new()

Dave Airlie (1):
      drm/radeon: fix PCI ID 5657 to be an RV410

David S. Miller (2):
      tcp: Fix >4GB writes on 64-bit.
      rose: Fix signedness issues wrt. digi count.

Dmitri Belimov (1):
      V4L/DVB (13966): DVB-T regression fix for saa7134 cards

Eric Dumazet (2):
      ip: fix truesize mismatch in ip fragmentation
      netxen: dont set skb->truesize

Erik J. Staab (1):
      ALSA: oxygen: fix analog capture on Claro halo cards

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Florian Fainelli (1):
      r6040: fix r6040_multicast_list

Greg Kroah-Hartman (1):
      Linux 2.6.32.25

H. Peter Anvin (1):
      x86, cpu: After uncapping CPUID, re-run CPU feature detection

Jacob Pan (1):
      x86: detect scattered cpuid features earlier

Jeremy Fitzhardinge (1):
      tracing/x86: Don't use mcount in pvclock.c

Jianzhao Wang (1):
      net: blackhole route should always be recalculated

Jiri Olsa (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 29

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

Joerg Roedel (3):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Fix rounding-bug in __unmap_single
      x86/amd-iommu: Work around S3 BIOS bug

Johannes Berg (1):
      wext: fix potential private ioctl memory content leak

Kees Cook (1):
      net: clear heap allocations for privileged ethtool actions

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl

Kumar Sanghvi (1):
      Phonet: Correct header retrieval after pskb_may_pull

Len Brown (3):
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
      ACPI: delete ZEPTO idle=nomwait DMI quirk

Linus Torvalds (2):
      v4l1: fix 32-bit compat microcode loading translation
      De-pessimize rds_page_copy_user

Luca Tettamanti (1):
      atl1: fix resume

Luke Yelavich (1):
      ALSA: hda - Add Dell Latitude E6400 model quirk

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Marek Szyprowski (1):
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

Matt Evans (1):
      powerpc: Initialise paca->kstack before early_setup_secondary

Mauro Carvalho Chehab (1):
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)

Michael Neuling (1):
      powerpc: Don't use kernel stack with translation off

Mike Galbraith (1):
      fix 2.6.32.23 suspend regression caused by commit 6f6198a

Ming Lei (1):
      usb: musb: gadget: fix kernel panic if using out ep with FIFO_TXRX style

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Paul Fertser (1):
      b44: fix carrier detection on bind

Roland McGrath (3):
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

Rémi Denis-Courmont (1):
      Phonet: disable network namespace support

Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()

Sergei Shtylyov (1):
      usb: musb: gadget: restart request on clearing endpoint halt

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Stanislaw Gruszka (2):
      skge: add quirk to limit DMA
      r8169: allocate with GFP_KERNEL flag when able to sleep

Stefan Bader (1):
      mm: Move vma_stack_continue into mm.h

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

Steven Rostedt (2):
      tracing/x86: Don't use mcount in kvmclock.c
      ring-buffer: Fix typo of time extends per page

Tejun Heo (1):
      ubd: fix incorrect sector handling during request restart

Thomas Gleixner (2):
      x86, hpet: Fix bogus error check in hpet_assign_irq()
      x86, irq: Plug memory leak in sparse irq

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Ulrich Weber (1):
      xfrm4: strip ECN and IP Precedence bits in policy lookup

Yegor Yefremov (1):
      i2c-pca: Fix waitforcompletion() return value

Zhang Rui (1):
      ACPI: Disable Windows Vista compatibility for Toshiba P305D

