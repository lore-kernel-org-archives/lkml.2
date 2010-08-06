Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712Ab0HFStb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:49:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:36497 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0HFSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:49:29 -0400
Date: Fri, 6 Aug 2010 11:49:21 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: West Bridge Driver Kernel Support linux-2.6.35
Message-ID: <20100806184921.GA23722@suse.de>
References: <CF8CD4BB5F91431A975E9F2DEFEF8F42@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF8CD4BB5F91431A975E9F2DEFEF8F42@stanford.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:38:22AM -0700, David Cross wrote:
> Re-Re-sending in plain text.
> 
> This is a driver for the Cypress West Bridge companion chip. Its function is
> analogous to the North/South Bridges of PC environments applied to embedded
> devices, in that it expands I/O and storage capabilities of an embedded
> processor.

Odd, your patch contains a lot of stuff it shouldn't, here's the
diffstat to show what I mean:

 Documentation/dontdiff                             |11723 ++++++++++++++++++++-
 arch/arm/mach-omap2/gpmc.c                         |    3 
 block/modules.builtin                              |    2 
 crypto/modules.builtin                             |   16 
 drivers/block/modules.builtin                      |    2 
 drivers/char/hw_random/modules.builtin             |    1 
 drivers/char/modules.builtin                       |    1 
 drivers/connector/modules.builtin                  |    1 
 drivers/gpio/modules.builtin                       |    1 
 drivers/hid/modules.builtin                        |    2 
 drivers/hid/usbhid/modules.builtin                 |    1 
 drivers/i2c/busses/modules.builtin                 |    1 
 drivers/i2c/modules.builtin                        |    3 
 drivers/input/keyboard/modules.builtin             |    2 
 drivers/input/modules.builtin                      |    5 
 drivers/input/serio/modules.builtin                |    3 
 drivers/input/touchscreen/modules.builtin          |    1 
 drivers/mmc/card/modules.builtin                   |    1 
 drivers/mmc/core/modules.builtin                   |    1 
 drivers/mmc/host/modules.builtin                   |    1 
 drivers/mmc/modules.builtin                        |    3 
 drivers/modules.builtin                            |   38 
 drivers/net/modules.builtin                        |    4 
 drivers/net/phy/modules.builtin                    |    2 
 drivers/power/modules.builtin                      |    1 
 drivers/rtc/modules.builtin                        |    2 
 drivers/scsi/modules.builtin                       |    2 
 drivers/serial/modules.builtin                     |    2 
 drivers/spi/modules.builtin                        |    1 
 drivers/staging/Kconfig                            |    2 
 drivers/staging/Makefile                           |    1 
 drivers/staging/westbridge/Kconfig                 |   34 
 drivers/staging/westbridge/astoria/Kconfig         |    9 
 drivers/staging/westbridge/astoria/Makefile        |   11 
 drivers/staging/westbridge/astoria/api/Makefile    |   10 
 drivers/staging/westbridge/astoria/block/Kconfig   |    9 
 drivers/staging/westbridge/astoria/block/Makefile  |   11 
 drivers/staging/westbridge/astoria/device/Kconfig  |    9 
 drivers/staging/westbridge/astoria/device/Makefile |   14 
 drivers/staging/westbridge/astoria/gadget/Kconfig  |    8 
 drivers/staging/westbridge/astoria/gadget/Makefile |   11 
 drivers/usb/core/modules.builtin                   |    1 
 drivers/usb/modules.builtin                        |    2 
 drivers/usb/mon/modules.builtin                    |    1 
 drivers/usb/musb/modules.builtin                   |    1 
 drivers/usb/otg/modules.builtin                    |    1 
 drivers/w1/modules.builtin                         |    1 
 fs/ext2/modules.builtin                            |    1 
 fs/ext3/modules.builtin                            |    1 
 fs/fat/inode.c                                     |    1 
 fs/fat/modules.builtin                             |    3 
 fs/jbd/modules.builtin                             |    1 
 fs/lockd/modules.builtin                           |    1 
 fs/modules.builtin                                 |   15 
 fs/mpage.c                                         |   17 
 fs/nfs/modules.builtin                             |    1 
 fs/nfs_common/modules.builtin                      |    1 
 fs/nls/modules.builtin                             |    3 
 fs/quota/modules.builtin                           |    2 
 lib/modules.builtin                                |    6 
 lib/zlib_inflate/modules.builtin                   |    1 
 modules.builtin                                    |   92 
 net/ipv4/modules.builtin                           |    6 
 net/key/modules.builtin                            |    1 
 net/modules.builtin                                |   13 
 net/packet/modules.builtin                         |    1 
 net/sunrpc/auth_gss/modules.builtin                |    2 
 net/sunrpc/modules.builtin                         |    3 
 net/unix/modules.builtin                           |    1 
 net/xfrm/modules.builtin                           |    1 
 sound/core/modules.builtin                         |    1 
 sound/modules.builtin                              |    2 
 72 files changed, 12101 insertions(+), 38 deletions(-)

It's also line-wrapped, and doesn't contain a "Signed-off-by:" line so I
can't apply it :(

Oh, diffstat can't even read the diff properly, so what is above isn't
what is really all there, the driver files do seem to be there, just not
showing up properly.

Care to fix this up and retry?

thanks,

greg k-h
