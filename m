Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1HAXWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:22:02 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48021 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab1HAXV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:21:56 -0400
X-Sasl-enc: cj876IstgNfXcuFhM5HYauVkf9ZJNrl8Whtfd28oFki0 1312240915
Date: Mon, 1 Aug 2011 16:21:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/70] 2.6.39.4-stable review
Message-ID: <20110801232124.GA15313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.39.4 release.

Note, barring anything extremely unusual, this will be the LAST 2.6.39.y
kernel release.  Everyone should be moving to the 3.0 kernel soon.

There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, August 3, 2011, 20:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.39.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                     |    2 +-
 arch/arm/kernel/perf_event.c                 |    6 +-
 arch/arm/mach-davinci/board-dm365-evm.c      |    4 +-
 arch/arm/mach-mmp/pxa168.c                   |    2 +-
 arch/arm/mach-mmp/pxa910.c                   |    2 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c               |    4 +-
 arch/x86/kernel/reboot.c                     |    8 ++
 drivers/ata/libata-eh.c                      |   12 ++-
 drivers/firewire/ohci.c                      |    6 +
 drivers/gpu/drm/radeon/evergreen.c           |  162 +++++++++++++++---------
 drivers/gpu/drm/radeon/evergreend.h          |    4 +-
 drivers/gpu/drm/radeon/ni.c                  |    1 +
 drivers/gpu/drm/radeon/r600.c                |    1 +
 drivers/gpu/drm/radeon/r600d.h               |    2 +-
 drivers/gpu/drm/radeon/radeon_display.c      |   13 ++-
 drivers/gpu/drm/radeon/rv770.c               |    1 +
 drivers/hwmon/asus_atk0110.c                 |    1 +
 drivers/hwmon/it87.c                         |    2 +-
 drivers/hwmon/lm95241.c                      |   22 +++-
 drivers/hwmon/max1111.c                      |   11 ++
 drivers/hwmon/pmbus.c                        |   19 ++-
 drivers/hwmon/pmbus_core.c                   |   31 ++---
 drivers/media/dvb/frontends/dib0070.c        |   40 ++-----
 drivers/media/dvb/frontends/dib0090.c        |   71 +++--------
 drivers/media/dvb/frontends/dib7000m.c       |   49 +++-----
 drivers/media/dvb/frontends/dib7000p.c       |   74 +++--------
 drivers/media/dvb/frontends/dib8000.c        |  126 +++++--------------
 drivers/media/dvb/frontends/dib9000.c        |  172 +++++++++-----------------
 drivers/media/dvb/frontends/dibx000_common.c |  109 +++++++----------
 drivers/media/dvb/frontends/dibx000_common.h |    5 -
 drivers/media/radio/si4713-i2c.c             |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c      |    2 +-
 drivers/media/video/cx23885/cx23885-core.c   |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c    |    4 +
 drivers/media/video/tuner-core.c             |   59 +++++----
 drivers/media/video/v4l2-ioctl.c             |    6 +
 drivers/mmc/host/sdhci-esdhc-imx.c           |    2 +-
 drivers/net/wireless/ath/ath5k/pci.c         |    7 +-
 drivers/net/wireless/ath/ath5k/sysfs.c       |    9 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |    3 +-
 drivers/net/wireless/ath/carl9170/usb.c      |    2 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  |    1 +
 drivers/pci/quirks.c                         |   23 ++++
 drivers/platform/x86/dell-laptop.c           |   24 +----
 drivers/usb/serial/pl2303.c                  |    1 +
 drivers/usb/serial/pl2303.h                  |    4 +
 fs/cifs/connect.c                            |   64 +++++++---
 fs/ext4/super.c                              |    3 +
 fs/gfs2/file.c                               |   10 ++-
 fs/namei.c                                   |    7 +-
 fs/nfs/nfs4xdr.c                             |    2 +-
 fs/partitions/efi.c                          |    9 ++
 fs/xfs/xfs_alloc.c                           |    6 +
 include/drm/drm_pciids.h                     |    2 +
 include/linux/netdevice.h                    |    5 +-
 mm/compaction.c                              |   42 ++++++-
 mm/nommu.c                                   |    9 +-
 mm/vmscan.c                                  |   80 ++++++++----
 net/bridge/br_private.h                      |    1 +
 net/bridge/br_stp.c                          |    4 +-
 net/mac80211/wpa.c                           |   16 ++-
 net/sunrpc/rpcb_clnt.c                       |    2 +-
 net/sunrpc/sched.c                           |   27 ++---
 sound/soc/blackfin/bf5xx-i2s-pcm.c           |   13 ++-
 sound/soc/codecs/ak4642.c                    |    2 +-
 sound/soc/codecs/wm8994.c                    |   11 +-
 66 files changed, 720 insertions(+), 717 deletions(-)
