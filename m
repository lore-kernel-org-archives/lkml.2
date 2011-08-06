Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1HFAFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:05:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57314 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab1HFAFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:05:16 -0400
X-Sasl-enc: K/xnKEp7NfxV9ZLHZmPoQ5yWVArmHcS/KQyuPXjWbsfI 1312589115
Date: Fri, 5 Aug 2011 17:04:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/50] 2.6.33.17-longterm review
Message-ID: <20110806000419.GA28392@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.17 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, August 8, 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.17-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                   |    2 +-
 arch/alpha/kernel/osf_sys.c                |   11 ++++--
 arch/arm/mach-davinci/board-dm365-evm.c    |    4 +-
 arch/arm/mach-pxa/cm-x300.c                |    8 ++--
 arch/powerpc/kernel/crash.c                |    6 +---
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 arch/x86/kernel/hpet.c                     |   53 +++++++++++++++------------
 arch/x86/kernel/reboot.c                   |    8 ++++
 arch/x86/kernel/relocate_kernel_32.S       |    2 +
 arch/x86/kernel/relocate_kernel_64.S       |    2 +
 arch/xtensa/kernel/ptrace.c                |    3 ++
 block/blk-core.c                           |    3 ++
 block/blk-exec.c                           |    7 ++++
 drivers/ata/libata-eh.c                    |   12 ++++--
 drivers/block/cciss.h                      |    2 +-
 drivers/hwmon/asus_atk0110.c               |    1 +
 drivers/hwmon/max1111.c                    |   11 ++++++
 drivers/md/dm-mpath.c                      |    5 +++
 drivers/md/dm.c                            |   10 ++++-
 drivers/media/radio/si4713-i2c.c           |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 ++
 drivers/media/video/v4l2-ioctl.c           |    6 +++
 drivers/misc/Kconfig                       |    3 +-
 drivers/net/jme.c                          |   20 +++++++---
 drivers/pci/pci.c                          |    7 +++-
 drivers/scsi/libsas/sas_expander.c         |    3 ++
 drivers/scsi/pmcraid.c                     |    3 ++
 drivers/scsi/scsi_devinfo.c                |    2 +
 drivers/scsi/scsi_lib.c                    |    2 +
 drivers/scsi/ses.c                         |    6 +++-
 drivers/staging/comedi/comedi_fops.c       |    4 +-
 drivers/usb/gadget/dummy_hcd.c             |    1 +
 drivers/usb/host/ehci-hub.c                |    3 +-
 drivers/usb/host/ehci-q.c                  |    3 +-
 drivers/usb/host/ehci.h                    |    1 +
 drivers/usb/musb/musb_core.c               |    1 +
 drivers/usb/serial/pl2303.c                |    2 +
 drivers/usb/serial/pl2303.h                |   10 +++++-
 fs/block_dev.c                             |   27 +++++---------
 fs/ext3/xattr.c                            |   12 +++++-
 fs/proc/base.c                             |    7 +++-
 include/drm/i915_drm.h                     |    2 +-
 include/linux/netdevice.h                  |    5 ++-
 net/bridge/br_private.h                    |    1 +
 net/bridge/br_stp.c                        |    4 +-
 net/ipv4/ip_gre.c                          |   19 +++++-----
 net/ipv6/xfrm6_tunnel.c                    |   16 ++++++---
 net/mac80211/mlme.c                        |    3 ++
 net/sunrpc/rpcb_clnt.c                     |    2 +-
 net/sunrpc/sched.c                         |   27 ++++++--------
 net/sunrpc/svc_xprt.c                      |   11 +++---
 sound/core/pcm_compat.c                    |    2 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c         |   13 ++++++-
 54 files changed, 259 insertions(+), 131 deletions(-)
