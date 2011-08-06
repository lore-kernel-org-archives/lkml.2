Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1HFADI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:03:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46917 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab1HFADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:03:03 -0400
X-Sasl-enc: aPF3kwciDhdvjSqsk1ydIuRGZ2uKHdNbvDWashESmaI6 1312588983
Date: Fri, 5 Aug 2011 17:02:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/55] 2.6.32.44-longterm review
Message-ID: <20110806000257.GA25498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.44 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, August 8, 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.44-rc1.gz
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
 drivers/hwmon/max1111.c                    |   11 ++++++
 drivers/md/dm-mpath.c                      |    5 +++
 drivers/md/dm.c                            |   10 ++++-
 drivers/media/radio/si4713-i2c.c           |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 ++
 drivers/media/video/v4l2-ioctl.c           |    6 +++
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
 drivers/usb/host/pci-quirks.c              |   28 +++++++++++++++
 drivers/usb/musb/musb_core.c               |    1 +
 drivers/usb/serial/pl2303.c                |    2 +
 drivers/usb/serial/pl2303.h                |   10 +++++-
 fs/block_dev.c                             |   27 +++++---------
 fs/cifs/cifsglob.h                         |    2 +-
 fs/cifs/connect.c                          |   28 ++++++++++----
 fs/ext3/xattr.c                            |   12 +++++-
 fs/nfs/nfs4xdr.c                           |    2 +-
 fs/proc/base.c                             |    7 +++-
 include/linux/netdevice.h                  |    5 ++-
 kernel/perf_event.c                        |    8 +---
 net/atm/br2684.c                           |   11 ++++--
 net/bridge/br_private.h                    |    1 +
 net/bridge/br_stp.c                        |    4 +-
 net/ipv4/ip_gre.c                          |   19 +++++-----
 net/ipv4/ipip.c                            |   13 +++----
 net/ipv6/ip6_tunnel.c                      |   28 ++++++++-------
 net/ipv6/sit.c                             |   13 +++----
 net/ipv6/xfrm6_tunnel.c                    |   32 ++++++++++-------
 net/mac80211/mlme.c                        |    3 ++
 net/sunrpc/rpcb_clnt.c                     |    2 +-
 net/sunrpc/sched.c                         |   27 ++++++--------
 net/sunrpc/svc_xprt.c                      |   11 +++---
 sound/core/pcm_compat.c                    |    2 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c         |   13 ++++++-
 60 files changed, 351 insertions(+), 182 deletions(-)
