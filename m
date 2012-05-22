Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2EVPOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:14:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab2EVPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:14:36 -0400
Date: Tue, 22 May 2012 08:14:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char and misc patches for 3.5-rc1 - try 2
Message-ID: <20120522151432.GA21477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.5-rc1

for you to fetch changes up to 991214386dee8a3cd9adc743778f472ac8a12bbc:

  parport: remove unused dead code from lowlevel drivers (2012-04-20 09:48:27 -0700)

----------------------------------------------------------------
Char/Misc patches for 3.5-rc1

Here are a few various char/misc tree patches for the 3.5-rc1 merge window.

Nothing major here at all, just different driver updates and some parport dead
code removal.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Arnd Bergmann (2):
      misc: add missing __devexit_p() annotations
      misc: do not mark exported functions __devexit

Axel Lin (1):
      misc: Fix irq leak in max8997_muic_probe error path

Daniel Borkmann (2):
      xilinx_hwicap: add support for virtex6 FPGAs
      xilinx_hwicap: reset XHI_MAX_RETRIES

Eric Andersson (3):
      misc: clean up bmp085 driver
      misc: bmp085: add device tree properties
      misc: add support for bmp18x chips to the bmp085 driver

Ivo Sieben (1):
      Support M95040 SPI EEPROM

Matt Porter (1):
      parport: remove unused dead code from lowlevel drivers

Tomoya MORINAGA (1):
      pch_phub: delete duplicate definitions

 Documentation/devicetree/bindings/misc/bmp085.txt  |   20 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |   30 ++
 drivers/char/xilinx_hwicap/xilinx_hwicap.h         |    2 +-
 drivers/misc/Kconfig                               |   26 +-
 drivers/misc/Makefile                              |    2 +
 drivers/misc/ad525x_dpot.c                         |    2 +-
 drivers/misc/bh1780gli.c                           |    2 +-
 drivers/misc/bmp085-i2c.c                          |   91 +++++
 drivers/misc/bmp085-spi.c                          |   91 +++++
 drivers/misc/bmp085.c                              |  356 ++++++++++----------
 drivers/misc/bmp085.h                              |   33 ++
 drivers/misc/eeprom/at25.c                         |   19 +-
 drivers/misc/max8997-muic.c                        |    6 +-
 drivers/misc/pch_phub.c                            |    4 -
 drivers/misc/pti.c                                 |    2 +-
 drivers/parport/parport_amiga.c                    |   36 --
 drivers/parport/parport_atari.c                    |    9 -
 drivers/parport/parport_mfc3.c                     |   35 --
 drivers/parport/parport_pc.c                       |  276 ---------------
 drivers/parport/parport_sunbpp.c                   |   21 --
 include/linux/spi/eeprom.h                         |   10 +
 22 files changed, 503 insertions(+), 571 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/bmp085.txt
 create mode 100644 drivers/misc/bmp085-i2c.c
 create mode 100644 drivers/misc/bmp085-spi.c
 create mode 100644 drivers/misc/bmp085.h
