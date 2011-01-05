Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1AEXGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:11 -0500
Received: from kroah.org ([198.145.64.141]:50659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1AEXGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:10 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:23 2011
Message-Id: <20110105230018.307910025@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/49] 2.6.32.28-longterm review
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.28
release.  There are 49 patches in this series, all will be posted as a
response to this one.  If anyone has any issues with these being
applied, please let us know.  If anyone is a maintainer of the proper
subsystem, and wants to add a Signed-off-by: line to the patch, please
respond with it.

Responses should be made by Friday, January 7, 2011, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.28-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                             |    2 +-
 arch/x86/include/asm/processor.h     |   23 --------
 arch/x86/kernel/apic/apic.c          |    8 +++
 arch/x86/kernel/apic/io_apic.c       |    1 +
 arch/x86/kernel/apic/probe_64.c      |    7 --
 arch/x86/kernel/cpu/amd.c            |    3 +-
 arch/x86/kernel/smpboot.c            |   85 ++++++++++++++++++++++++++++-
 arch/x86/vdso/Makefile               |    4 +-
 block/blk-merge.c                    |    6 +-
 block/blk-settings.c                 |   24 +-------
 drivers/acpi/acpica/dswexec.c        |   19 ++++++-
 drivers/acpi/ec.c                    |    3 +
 drivers/char/hvc_console.c           |   27 ++++++---
 drivers/char/tty_ldisc.c             |    1 +
 drivers/dma/mv_xor.c                 |    2 +-
 drivers/edac/amd64_edac.c            |    2 +-
 drivers/gpu/drm/drm_crtc.c           |    8 +-
 drivers/hid/hidraw.c                 |   11 +++-
 drivers/hwmon/adm1026.c              |   20 +++---
 drivers/infiniband/core/uverbs_cmd.c |  101 +++++++++++++++++++---------------
 drivers/md/dm-table.c                |    5 --
 drivers/md/md.c                      |   10 ++--
 drivers/net/igb/igb_main.c           |    2 +-
 drivers/net/wireless/orinoco/main.c  |    6 ++
 drivers/net/wireless/orinoco/wext.c  |    4 +-
 drivers/net/wireless/p54/p54usb.c    |    6 ++
 drivers/pci/dmar.c                   |    5 ++
 drivers/pci/quirks.c                 |   23 ++++++++
 drivers/scsi/bfa/bfa_core.c          |   22 +++++++
 drivers/scsi/scsi_lib.c              |    3 +-
 drivers/usb/misc/uss720.c            |    4 +-
 drivers/usb/serial/ftdi_sio.c        |    1 +
 drivers/usb/serial/ftdi_sio_ids.h    |    5 ++
 drivers/usb/storage/unusual_devs.h   |    7 ++
 fs/exec.c                            |    5 ++
 fs/fuse/file.c                       |   72 ++++++++++++++++++++++--
 fs/nfs/file.c                        |    2 +
 fs/nfs/mount_clnt.c                  |    4 +-
 fs/nfsd/nfs3xdr.c                    |    6 +-
 include/linux/blkdev.h               |    9 ++-
 include/linux/nfsd/xdr4.h            |   21 +++----
 include/net/sctp/sm.h                |    1 +
 include/net/sctp/structs.h           |    3 +
 kernel/exit.c                        |    8 +++
 kernel/power/user.c                  |    2 +-
 kernel/printk.c                      |    2 +
 kernel/timer.c                       |    6 ++
 kernel/trace/trace.c                 |   10 +++-
 mm/mmap.c                            |   16 ++++-
 net/core/dev.c                       |    8 +++
 net/sctp/input.c                     |   22 ++++++-
 net/sctp/sm_sideeffect.c             |   35 ++++++++++++
 net/sctp/transport.c                 |    2 +
 net/sunrpc/svc_xprt.c                |    9 +++-
 security/integrity/ima/ima_policy.c  |    2 +
 sound/oss/soundcard.c                |    4 +-
 sound/pci/hda/hda_intel.c            |    2 +
 sound/pci/hda/patch_realtek.c        |    1 +
 58 files changed, 523 insertions(+), 189 deletions(-)

