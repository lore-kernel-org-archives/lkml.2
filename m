Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2DXWdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:33:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49634 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab2DXWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:33:06 -0400
Date: Tue, 24 Apr 2012 15:33:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/62] 3.3.4-stable review
Message-ID: <20120424223305.GA7748@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.3.4 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr 26 22:32:39 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                       |    4 +-
 arch/arm/mach-at91/board-sam9261ek.c           |    5 +-
 arch/arm/mach-omap1/timer.c                    |    4 +-
 arch/arm/mach-omap2/serial.c                   |    8 ++-
 crypto/sha512_generic.c                        |    2 +-
 drivers/bluetooth/ath3k.c                      |    2 +
 drivers/bluetooth/btusb.c                      |    1 +
 drivers/hwmon/fam15h_power.c                   |   39 ++++++++++++++
 drivers/md/md.c                                |    7 +--
 drivers/media/dvb/dvb-core/dvb_frontend.c      |   25 ++++++++-
 drivers/media/dvb/frontends/drxk_hard.c        |    6 ++-
 drivers/media/rc/winbond-cir.c                 |    1 +
 drivers/mmc/card/block.c                       |   54 +++++++++++++------
 drivers/mmc/card/queue.c                       |    2 +-
 drivers/mmc/core/core.c                        |    9 ++--
 drivers/mmc/host/sdhci-esdhc-imx.c             |    3 +-
 drivers/mmc/host/sdhci.c                       |    2 +-
 drivers/net/ethernet/ti/davinci_mdio.c         |    5 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 +++
 drivers/net/wireless/mwifiex/pcie.h            |   18 +++----
 drivers/pci/quirks.c                           |   34 ++++++++++++
 drivers/platform/x86/dell-laptop.c             |   28 ++++++++++
 drivers/staging/rtl8712/os_intfs.c             |    3 --
 drivers/staging/rtl8712/usb_intf.c             |    5 ++
 drivers/tty/amiserial.c                        |    4 +-
 drivers/tty/serial/clps711x.c                  |   14 ++---
 drivers/tty/serial/pch_uart.c                  |    4 +-
 drivers/usb/core/hub.c                         |    3 --
 drivers/usb/core/message.c                     |    6 +--
 drivers/usb/gadget/f_fs.c                      |    2 +-
 drivers/usb/gadget/udc-core.c                  |    6 ++-
 drivers/usb/host/ehci-hcd.c                    |    9 +++-
 drivers/usb/misc/yurex.c                       |   10 ++--
 drivers/usb/musb/omap2430.c                    |    9 ++--
 drivers/usb/serial/cp210x.c                    |    9 ++--
 drivers/usb/serial/sierra.c                    |    6 ++-
 drivers/uwb/hwa-rc.c                           |    3 +-
 drivers/uwb/neh.c                              |   12 ++++-
 drivers/xen/gntdev.c                           |    2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c     |   69 ++++++++++++++++++------
 fs/btrfs/ctree.h                               |    2 +-
 fs/ext4/extents.c                              |    2 +-
 fs/jbd2/commit.c                               |    4 +-
 fs/lockd/clnt4xdr.c                            |    2 +-
 fs/lockd/clntxdr.c                             |    2 +-
 fs/nfsd/nfs3xdr.c                              |   22 +++-----
 fs/nfsd/nfs4proc.c                             |    7 +--
 fs/nfsd/nfs4state.c                            |   23 ++++----
 fs/nfsd/nfs4xdr.c                              |    2 +-
 fs/ocfs2/alloc.c                               |    2 +-
 fs/ocfs2/refcounttree.c                        |   12 ++---
 fs/ocfs2/suballoc.c                            |    4 +-
 include/linux/kvm_host.h                       |    6 +++
 mm/memblock.c                                  |    7 ++-
 mm/swap_state.c                                |    2 +-
 net/mac80211/ibss.c                            |    4 +-
 net/wireless/util.c                            |    2 +-
 scripts/mod/file2alias.c                       |    4 ++
 sound/pci/hda/patch_conexant.c                 |   37 +++++++++++--
 tools/perf/util/hist.c                         |    4 +-
 virt/kvm/iommu.c                               |    7 ++-
 virt/kvm/kvm_main.c                            |    5 +-
 62 files changed, 441 insertions(+), 164 deletions(-)

