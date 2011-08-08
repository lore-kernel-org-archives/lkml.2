Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1HHRxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:53:00 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41165 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab1HHRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:52:58 -0400
X-Sasl-enc: 2Is1g1H+ryeUMGeVsCdvgy6I2Lx+0w1PT2bFq75+Ls7X 1312825977
Date: Mon, 8 Aug 2011 10:52:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.44
Message-ID: <20110808175207.GA18137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.44 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/alpha/kernel/osf_sys.c                |   11 +++---
 arch/arm/mach-davinci/board-dm365-evm.c    |    4 +-
 arch/arm/mach-pxa/cm-x300.c                |    8 ++--
 arch/powerpc/kernel/crash.c                |    6 ---
 arch/powerpc/platforms/pseries/hvconsole.c |    2 -
 arch/x86/kernel/hpet.c                     |   53 +++++++++++++++--------------
 arch/x86/kernel/reboot.c                   |    8 ++++
 arch/x86/kernel/relocate_kernel_32.S       |    2 +
 arch/x86/kernel/relocate_kernel_64.S       |    2 +
 arch/xtensa/kernel/ptrace.c                |    3 +
 drivers/ata/libata-eh.c                    |   12 ++++--
 drivers/block/cciss.h                      |    2 -
 drivers/hwmon/max1111.c                    |   11 ++++++
 drivers/md/dm-mpath.c                      |    5 ++
 drivers/md/dm.c                            |   10 ++++-
 drivers/media/radio/si4713-i2c.c           |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 ++
 drivers/media/video/v4l2-ioctl.c           |    6 +++
 drivers/net/jme.c                          |   20 +++++++---
 drivers/pci/pci.c                          |    7 +++
 drivers/scsi/libsas/sas_expander.c         |    3 +
 drivers/scsi/pmcraid.c                     |    3 +
 drivers/scsi/scsi_devinfo.c                |    2 +
 drivers/scsi/ses.c                         |    6 ++-
 drivers/staging/comedi/comedi_fops.c       |    4 +-
 drivers/usb/gadget/dummy_hcd.c             |    1 
 drivers/usb/host/ehci-hub.c                |    3 +
 drivers/usb/host/ehci-q.c                  |    3 +
 drivers/usb/host/ehci.h                    |    1 
 drivers/usb/host/pci-quirks.c              |   28 +++++++++++++++
 drivers/usb/musb/musb_core.c               |    1 
 drivers/usb/serial/pl2303.c                |    2 +
 drivers/usb/serial/pl2303.h                |   10 ++++-
 fs/block_dev.c                             |   27 ++++----------
 fs/cifs/cifsglob.h                         |    2 -
 fs/cifs/connect.c                          |   28 ++++++++++-----
 fs/ext3/xattr.c                            |   12 +++++-
 fs/nfs/nfs4xdr.c                           |    2 -
 fs/proc/base.c                             |    7 ++-
 include/linux/netdevice.h                  |    5 ++
 kernel/perf_event.c                        |    8 +---
 net/atm/br2684.c                           |   11 ++++--
 net/bridge/br_private.h                    |    1 
 net/bridge/br_stp.c                        |    4 +-
 net/ipv4/ip_gre.c                          |   19 +++++-----
 net/ipv4/ipip.c                            |   13 +++----
 net/ipv6/ip6_tunnel.c                      |   28 ++++++++-------
 net/ipv6/sit.c                             |   13 +++----
 net/ipv6/xfrm6_tunnel.c                    |   32 ++++++++++-------
 net/mac80211/mlme.c                        |    3 +
 net/sunrpc/rpcb_clnt.c                     |    2 -
 net/sunrpc/sched.c                         |   27 ++++++--------
 net/sunrpc/svc_xprt.c                      |   11 +++---
 sound/core/pcm_compat.c                    |    2 -
 sound/soc/blackfin/bf5xx-i2s-pcm.c         |   13 ++++++-
 57 files changed, 339 insertions(+), 182 deletions(-)

Ajay Kumar Gupta (1):
      usb: musb: restore INDEX register in resume path

Alan Stern (3):
      USB: OHCI: fix another regression for NVIDIA controllers
      USB: dummy-hcd needs the has_tt flag
      EHCI: fix direction handling for interrupt data toggles

Alasdair G Kergon (1):
      dm: fix idr leak on module removal

Alexey Dobriyan (3):
      gre: fix netns vs proto registration ordering
      netns xfrm: fixup xfrm6_tunnel error propagation
      tunnels: fix netns vs proto registration ordering

Andy Adamson (1):
      NFSv4.1: update nfs4_fattr_bitmap_maxsz

Anton Blanchard (1):
      powerpc/pseries/hvconsole: Fix dropped console output

Ben Greear (1):
      SUNRPC: Fix use of static variable in rpcb_getport_async

Chris Wright (1):
      PCI: ARI is a PCIe v2 feature

Dan Rosenberg (3):
      pmcraid: reject negative request size
      xtensa: prevent arbitrary read in ptrace
      alpha: fix several security issues

Daniel J Blueman (1):
      x86: Make Dell Latitude E5420 use reboot=pci

Douglas Gilbert (1):
      ses: requesting a fault indication

Greg Kroah-Hartman (3):
      USB: pl2303.h: checkpatch cleanups
      Revert "block: rescan partitions on invalidated devices on -ENOMEDIA too"
      Linux 2.6.32.44

Guo-Fu Tseng (1):
      jme: Fix unmap error (Causing system freeze)

Hans Verkuil (3):
      v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
      pvrusb2: fix g/s_tuner support
      bttv: fix s_tuner for radio

Herbert Xu (1):
      gro: Only reset frag0 when skb can be pulled

Huang Ying (1):
      kexec, x86: Fix incorrect jump back address if not preserving context

Igor Grinberg (1):
      ARM: pxa/cm-x300: fix V3020 RTC functionality

J. Bruce Fields (1):
      svcrpc: fix list-corrupting race on nfsd shutdown

Jan Kara (1):
      ext3: Fix oops in ext3_try_to_allocate_with_rsv()

Jeff Layton (3):
      cifs: clean up cifs_find_smb_ses (try #2)
      cifs: fix NULL pointer dereference in cifs_find_smb_ses
      cifs: check for NULL session password

Jon Povey (1):
      davinci: DM365 EVM: fix video input mux bits

Julia Lawall (1):
      ALSA: sound/core/pcm_compat.c: adjust array index

Luben Tuikov (1):
      libsas: remove expander from dev list on error

Manuel Jander (1):
      USB: pl2303: add AdLink ND-6530 USB IDs

Mark Brown (1):
      ASoC: Fix Blackfin I2S _pointer() implementation return in bounds values

Mauro Carvalho Chehab (1):
      si4713-i2c: avoid potential buffer overflow on si4713

Michael Neuling (1):
      powerpc/kdump: Fix timeout in crash_kexec_wait_realmode

Mike Snitzer (1):
      dm mpath: fix potential NULL pointer in feature arg processing

Pavel Herrmann (1):
      hwmon: (max1111) Fix race condition causing NULL pointer exception

Peter Zijlstra (1):
      perf: overflow/perf_count_sw_cpu_clock crashes recent kernels

Rajkumar Manoharan (1):
      mac80211: Restart STA timers only on associated state

Sergei Shtylyov (1):
      EHCI: only power off port if over-current is active

Stephen M. Cameron (1):
      cciss: do not attempt to read from a write-only register

Tejun Heo (1):
      libata: fix unexpectedly frozen port after ata_eh_reset()

Thomas Gleixner (2):
      x86: Hpet: Avoid the comparator readback penalty
      x86: HPET: Chose a paranoid safe value for the ETIME check

Trond Myklebust (1):
      SUNRPC: Fix a race between work-queue and rpc_killall_tasks

Vasiliy Kulikov (2):
      staging: comedi: fix infoleak to userspace
      proc: restrict access to /proc/PID/io

Werner Fink (1):
      Blacklist Traxdata CDR4120 and IOMEGA Zip drive to avoid lock ups.

Wolfgang Denk (1):
      USB: serial: add IDs for WinChipHead USB->RS232 adapter

chas williams - CONTRACTOR (1):
      atm: [br2684] allow routed mode operation again

stephen hemminger (1):
      bridge: send proper message_age in config BPDU

