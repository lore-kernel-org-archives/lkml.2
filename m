Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab1KWA0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:26:10 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49176 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab1KWA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:26:06 -0500
X-Sasl-enc: bYXlDlF9ZTYaTfieEhvXAwEyxWPKecvGD9Z47AbuuchO 1322007965
Date: Tue, 22 Nov 2011 16:22:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/25] 2.6.32.49-longterm review
Message-ID: <20111123002222.GA2376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.49 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, November 25, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.49-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/Makefile              |    2 +-
 Documentation/kbuild/makefiles.txt  |   12 ++
 Documentation/video4linux/Makefile  |    8 --
 Documentation/video4linux/v4lgrab.c |  201 -----------------------------------
 Makefile                            |    7 +-
 arch/ia64/hp/sim/simserial.c        |   12 +--
 drivers/base/sys.c                  |    6 +
 drivers/char/amiserial.c            |   56 ++++++-----
 drivers/char/cyclades.c             |   49 +++++----
 drivers/char/ip2/ip2main.c          |   72 ++++++++-----
 drivers/char/mxser.c                |   62 ++++++-----
 drivers/char/nozomi.c               |   37 +++----
 drivers/char/pcmcia/synclink_cs.c   |   60 +++++------
 drivers/char/synclink.c             |   73 ++++++-------
 drivers/char/synclink_gt.c          |   56 +++++-----
 drivers/char/synclinkmp.c           |   61 +++++------
 drivers/char/tty_io.c               |   21 ++++
 drivers/gpu/drm/i915/i915_gem.c     |   44 ++++----
 drivers/md/raid5.c                  |   32 ++++--
 drivers/mtd/mtdchar.c               |    1 +
 drivers/scsi/hosts.c                |    9 +-
 drivers/scsi/scsi_lib.c             |    9 ++
 drivers/scsi/st.c                   |    4 +-
 drivers/serial/68360serial.c        |   51 +++++-----
 drivers/serial/serial_core.c        |   35 +++----
 drivers/usb/core/quirks.c           |   27 +++++
 drivers/usb/serial/ftdi_sio.c       |   14 ++-
 drivers/usb/serial/pl2303.c         |    1 -
 drivers/usb/serial/pl2303.h         |    4 -
 drivers/usb/serial/usb-serial.c     |   13 +++
 drivers/usb/storage/protocol.c      |    7 +-
 drivers/xen/events.c                |    2 +-
 fs/hfs/trans.c                      |    2 +
 include/linux/interrupt.h           |    6 +
 include/linux/tty_driver.h          |    9 ++
 include/linux/usb/serial.h          |    2 +
 include/linux/vmalloc.h             |    1 +
 kernel/irq/pm.c                     |   35 +++++--
 kernel/power/suspend.c              |    2 +-
 lib/nlattr.c                        |    1 +
 mm/vmalloc.c                        |   67 +++++++++---
 net/bluetooth/rfcomm/tty.c          |    4 -
 net/ipv6/udp.c                      |    2 +-
 net/sunrpc/auth_unix.c              |    3 +
 scripts/Kbuild.include              |    5 +
 sound/pci/hda/patch_realtek.c       |    1 -
 sound/soc/codecs/wm8940.c           |    1 +
 47 files changed, 586 insertions(+), 603 deletions(-)
