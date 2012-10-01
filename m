Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2JAS1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:27:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55183 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848Ab2JAS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:27:18 -0400
X-Sasl-enc: 22Fstn/s8I6SL0pgAC11FPQSVBP9TQu97Wdi9Yknno3c 1349116037
Date: Mon, 1 Oct 2012 11:27:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc changes for 3.7-rc1 - try 2
Message-ID: <20121001182716.GA11969@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid me, I was pointing to the wrong branch, I blame it being Monday
morning, but it's really just my fault in typing the wrong branch
name...


The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.6

for you to fetch changes up to 5dc2db05f2f690d71d95979b14cca50ab8e49f40:

  drivers/misc/lis3lv02d/lis3lv02d_i2c.c: add lis3lv02d device tree init (2012-09-26 14:18:48 -0700)

----------------------------------------------------------------
char/misc driver merge for 3.7-rc1

Here is the "big" char/misc driver tree update for the 3.7-rc1 merge
window.

Nothing major, just a number of driver updates and fixes, all of which
have been in the linux-next releases for a while now either in my tree,
or in Andrew's (the lis3l driver changes came from his tree last week).

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexey Khoroshilov (3):
      ppdev: ppdev_init: do not return zero in case of failure
      virtio: console: fix error handling in init() function
      pcmcia: synclink_cs: fix potential tty NULL dereference

AnilKumar Ch (5):
      lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
      lis3lv02d: fix some comments specific to lis331dlh driver
      drivers/misc/lis3lv02d: remove lis3lv02d driver DT init
      drivers/misc/lis3lv02d/lis3lv02d_spi.c: add lis3lv02d device tree init
      drivers/misc/lis3lv02d/lis3lv02d_i2c.c: add lis3lv02d device tree init

Daniel Mack (4):
      onewire: w1-gpio: add DT bindings
      onewire: w1-gpio: add ext_pullup_enable pin in platform data
      drivers/misc/lis3lv02d: add generic DT matching code
      drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching table passthru code

David Daney (1):
      misc/at25, dt: Improve at25 SPI eeprom device tree bindings.

Devendra Naga (4):
      pch_phub: fix sparse warning
      pch_phub: use module_pci_driver
      tifm: use module_pci_driver
      misc: use module_spi_driver

Felipe Balbi (6):
      w1: omap-hdq: add section annotation to remove
      w1: omap-hdq: don't hardcode resource size
      w1: omap-hdq: convert to module_platform_driver
      w1: omap-hdq: convert to devm_* functions
      w1: omap-hdq: remove unnecessary return
      w1: omap-hdq: drop ARCH dependency

Greg Kroah-Hartman (2):
      Merge v3.6-rc3 into 'char-misc-next'
      char/misc: remove CONFIG_EXPERIMENTAL dependencies

Jiri Slaby (1):
      MISC: hpilo, remove pci_disable_device

Julia Lawall (1):
      drivers/char/tlclk.c: fix error return code

Matthias Kaehlcke (1):
      drivers/misc/ti-st: check chip_awake NULL check

Pavan Savoy (5):
      drivers/misc/ti-st: remove gpio handling
      drivers/misc/ti-st: remove sparse warnings
      drivers/misc/ti-st: chip_disable on timeout
      drivers/misc/ti-st: use cpu friendly completions
      drivers/misc/ti-st: fix read fw version cmd

Peter Senna Tschudin (2):
      drivers/char: removes unnecessary semicolon
      drivers/char/mmtimer.c: Remove useless kfree

Qiang Liu (1):
      carma: remove unnecessary DMA_INTERRUPT capability

Sourav Poddar (1):
      driver: misc: bmp085: remove "of_match_table" property.

Tomas Winkler (16):
      mei: revamp me client search function
      mei: add mei_quirk_probe function
      mei: use KBUILD_MODNAME when allocating resources from the OS
      mei: style : reformat PCI device IDs
      mei: name space for mei device state
      mei: fix device stall after wd is stopped
      mei: wd: add option WDIOF_SETTIMEOUT
      mei: wd: rename watchdog constants to be more descriptive
      mei: wd: decouple and revamp watchdog state machine
      mei: wd: use watchdog_set/get_drvdata for passing mei_device
      mei: rename struct pci_dev *mei_device to mei_pdev
      mei: fix max number of open handles
      mei: add lynx point pci device ids
      mei: add error messages for open count errors
      mei: struct mei_message_data doesn't have to be packed
      mei: don't print buffer as a string

 Documentation/devicetree/bindings/misc/at25.txt   |  34 +++++++----
 Documentation/devicetree/bindings/misc/lis302.txt | 112 ++++++++++++++++++++++++++++++++++++
 Documentation/devicetree/bindings/w1/w1-gpio.txt  |  22 +++++++
 Documentation/misc-devices/lis3lv02d              |   3 +-
 drivers/char/Kconfig                              |   6 +-
 drivers/char/mmtimer.c                            |   3 +-
 drivers/char/nwbutton.c                           |   4 +-
 drivers/char/pcmcia/synclink_cs.c                 |  20 ++++---
 drivers/char/ppdev.c                              |   3 +-
 drivers/char/rtc.c                                |   2 +-
 drivers/char/tlclk.c                              |   4 +-
 drivers/char/virtio_console.c                     |  12 +++-
 drivers/misc/Kconfig                              |  14 ++---
 drivers/misc/bmp085-i2c.c                         |   7 ---
 drivers/misc/bmp085-spi.c                         |  13 +----
 drivers/misc/c2port/Kconfig                       |   5 +-
 drivers/misc/carma/carma-fpga-program.c           |   1 -
 drivers/misc/carma/carma-fpga.c                   |   2 +-
 drivers/misc/eeprom/Kconfig                       |   2 +-
 drivers/misc/eeprom/at25.c                        |  83 ++++++++++++++++++--------
 drivers/misc/hpilo.c                              |  11 +++-
 drivers/misc/lis3lv02d/lis3lv02d.c                | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/misc/lis3lv02d/lis3lv02d.h                |  49 ++++++++++++++--
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c            |  32 ++++++++++-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c            |  21 +++++++
 drivers/misc/mei/Kconfig                          |   2 +-
 drivers/misc/mei/hw.h                             |  83 +++++++++++++-------------
 drivers/misc/mei/init.c                           |  93 ++++++++++++++++++------------
 drivers/misc/mei/interface.h                      |  10 +---
 drivers/misc/mei/interrupt.c                      |  44 ++++++--------
 drivers/misc/mei/iorw.c                           |  59 ++++++++++---------
 drivers/misc/mei/main.c                           | 107 ++++++++++++++++------------------
 drivers/misc/mei/mei_dev.h                        |  78 ++++++++++++++-----------
 drivers/misc/mei/wd.c                             |  91 +++++++++++++++--------------
 drivers/misc/pch_phub.c                           |  15 +----
 drivers/misc/ti-st/st_core.c                      |  12 ++--
 drivers/misc/ti-st/st_kim.c                       | 109 ++++++++++++++---------------------
 drivers/misc/tifm_7xx1.c                          |  14 +----
 drivers/w1/masters/Kconfig                        |   1 -
 drivers/w1/masters/omap_hdq.c                     |  57 +++++-------------
 drivers/w1/masters/w1-gpio.c                      |  66 ++++++++++++++++++++-
 include/linux/ti_wilink_st.h                      |   3 +-
 include/linux/w1-gpio.h                           |   1 +
 43 files changed, 984 insertions(+), 518 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/lis302.txt
 create mode 100644 Documentation/devicetree/bindings/w1/w1-gpio.txt
