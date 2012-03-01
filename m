Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165Ab2CAVre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:47:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab2CAVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:47:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.130.6 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 1 Mar 2012 13:46:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/34] 2.6.32.58-longterm review
Message-ID: <20120301214654.GA13231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:
	I have NOT tested this rc release.  I now no longer own any
	machines that can run the 2.6.32 kernel.  Because of this, this
	will be the last 2.6.32-longterm kernel that I will release.  I
	will be passing on the .32 kernel to someone else after this
	release.  Please, if you care about the .32 kernel, test this
	release, I have _only_ build tested it, and have no idea if I
	got something wrong or not.


This is the start of the longterm review cycle for the 2.6.32.58 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Mar  3 21:39:21 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.58-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                |    2 +-
 arch/arm/include/asm/assembler.h        |    5 ++
 arch/arm/mm/cache-v7.S                  |    6 ++
 arch/s390/include/asm/compat.h          |    7 --
 arch/s390/kernel/process.c              |    1 -
 arch/s390/kernel/ptrace.c               |    2 +-
 arch/s390/kernel/setup.c                |    2 +-
 arch/s390/mm/mmap.c                     |    2 +-
 crypto/sha512_generic.c                 |   83 +++++++++++--------------
 drivers/base/firmware_class.c           |   12 +++-
 drivers/cdrom/cdrom.c                   |    8 +--
 drivers/gpu/drm/i915/intel_lvds.c       |    8 +++
 drivers/gpu/drm/radeon/r100.c           |    4 +-
 drivers/gpu/drm/radeon/rs600.c          |    4 +-
 drivers/hwmon/f75375s.c                 |    4 +-
 drivers/media/video/hdpvr/hdpvr-video.c |    3 +-
 drivers/s390/block/dasd_eckd.c          |    1 +
 drivers/s390/block/dasd_ioctl.c         |    1 +
 drivers/s390/char/fs3270.c              |    1 +
 drivers/s390/char/vmcp.c                |    1 +
 drivers/s390/cio/chsc_sch.c             |    1 +
 drivers/s390/scsi/zfcp_cfdc.c           |    1 +
 drivers/scsi/3w-9xxx.c                  |   11 ++-
 drivers/usb/host/pci-quirks.c           |   11 +++
 drivers/usb/host/xhci-mem.c             |   32 +++++++---
 drivers/usb/serial/cp210x.c             |    2 +
 fs/autofs4/autofs_i.h                   |    1 +
 fs/autofs4/dev-ioctl.c                  |    1 +
 fs/autofs4/inode.c                      |    2 +
 fs/autofs4/waitq.c                      |   22 ++++++-
 fs/ecryptfs/file.c                      |    2 +-
 fs/ecryptfs/inode.c                     |  103 +++++++++++++++++++++----------
 fs/ecryptfs/main.c                      |   38 ++++++++++--
 include/linux/bitops.h                  |   20 ++++++
 include/linux/compat.h                  |    4 +
 include/linux/kernel.h                  |   15 ++---
 include/linux/kmod.h                    |    9 +++
 include/linux/proportions.h             |    4 +
 kernel/kmod.c                           |   33 ++++++++++-
 kernel/relay.c                          |   10 +++-
 net/mac80211/rx.c                       |    2 +-
 41 files changed, 338 insertions(+), 143 deletions(-)

