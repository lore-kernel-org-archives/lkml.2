Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2EVNTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:19:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49546 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2EVNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:19:42 -0400
Date: Tue, 22 May 2012 06:19:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging patches for 3.5-rc1
Message-ID: <20120522131937.GA1408@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.5-rc1

for you to fetch changes up to 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

----------------------------------------------------------------
Staging tree pull request for 3.5-rc1

Here is the big staging tree pull request for the 3.5-rc1 merge window.

Loads of changes here, and we just narrowly added more lines than we
added:
 622 files changed, 28356 insertions(+), 26059 deletions(-)

But, good news is that there is a number of subsystems that moved out of
the staging tree, to their respective "real" portions of the kernel.

Code that moved out was:
	- iio core code
	- mei driver
	- vme core and bridge drivers

There was one broken network driver that moved into staging as a step
before it is removed from the tree (pc300), and there was a few new
drivers added to the tree:
	- new iio drivers
	- gdm72xx wimax USB driver
	- ipack subsystem and 2 drivers

All of the movements around have acks from the various subsystem
maintainers, and all of this has been in the linux-next tree for a
while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------

 .../ABI/testing}/sysfs-bus-iio                     |   52 +-
 Documentation/Makefile                             |    2 +-
 .../devicetree/bindings/arm/atmel-adc.txt          |   65 +
 .../bindings/staging/iio/adc/lpc32xx-adc.txt       |   16 +
 .../bindings/staging/iio/adc/spear-adc.txt         |   26 +
 Documentation/ioctl/ioctl-number.txt               |    1 +
 Documentation/misc-devices/mei/.gitignore          |    1 +
 Documentation/misc-devices/mei/Makefile            |    8 +
 Documentation/misc-devices/mei/TODO                |    2 +
 .../misc-devices}/mei/mei-amt-version.c            |    2 +-
 .../misc-devices}/mei/mei.txt                      |    0
 Documentation/ramoops.txt                          |   16 +-
 {drivers/staging/vme => Documentation}/vme_api.txt |    0
 MAINTAINERS                                        |   21 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |   35 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   37 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   38 +
 arch/arm/mach-at91/at91sam9260.c                   |    8 +
 arch/arm/mach-at91/at91sam9260_devices.c           |   90 +
 arch/arm/mach-at91/at91sam9g45.c                   |    9 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |  101 +
 arch/arm/mach-at91/at91sam9x5.c                    |    6 +
 arch/arm/mach-at91/board-sam9g20ek.c               |   14 +
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   12 +
 drivers/Kconfig                                    |    4 +
 drivers/Makefile                                   |    2 +
 drivers/char/Kconfig                               |    8 -
 drivers/char/Makefile                              |    1 -
 drivers/char/ramoops.c                             |  250 --
 drivers/iio/Kconfig                                |   54 +
 drivers/iio/Makefile                               |   13 +
 drivers/iio/adc/Kconfig                            |   16 +
 drivers/iio/adc/Makefile                           |    5 +
 drivers/iio/adc/at91_adc.c                         |  802 +++++
 drivers/iio/amplifiers/Kconfig                     |   17 +
 drivers/iio/amplifiers/Makefile                    |    5 +
 drivers/iio/amplifiers/ad8366.c                    |  222 ++
 drivers/{staging => }/iio/iio_core.h               |    6 +
 drivers/{staging => }/iio/iio_core_trigger.h       |    0
 drivers/{staging => }/iio/industrialio-buffer.c    |   91 +-
 drivers/{staging => }/iio/industrialio-core.c      |   94 +-
 drivers/{staging => }/iio/industrialio-event.c     |   14 +-
 drivers/{staging => }/iio/industrialio-trigger.c   |   24 +-
 drivers/{staging => }/iio/inkern.c                 |    8 +-
 drivers/{staging => }/iio/kfifo_buf.c              |    3 +-
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/{staging => misc}/mei/Kconfig              |    0
 drivers/{staging => misc}/mei/Makefile             |    0
 drivers/{staging => misc}/mei/hw.h                 |    0
 drivers/{staging => misc}/mei/init.c               |    4 +-
 drivers/{staging => misc}/mei/interface.c          |    2 +-
 drivers/{staging => misc}/mei/interface.h          |    5 +-
 drivers/{staging => misc}/mei/interrupt.c          |    2 +-
 drivers/{staging => misc}/mei/iorw.c               |    2 +-
 drivers/{staging => misc}/mei/main.c               |   41 +-
 drivers/{staging => misc}/mei/mei_dev.h            |    2 +-
 drivers/{staging => misc}/mei/wd.c                 |   76 +-
 drivers/net/wan/Kconfig                            |   31 -
 drivers/net/wan/Makefile                           |    5 -
 drivers/staging/Kconfig                            |   12 +-
 drivers/staging/Makefile                           |    5 +-
 drivers/staging/android/Kconfig                    |   31 +-
 drivers/staging/android/Makefile                   |    2 -
 drivers/staging/android/alarm-dev.c                |  137 +-
 drivers/staging/android/alarm.c                    |  601 ----
 drivers/staging/android/android_alarm.h            |   59 -
 drivers/staging/android/binder.h                   |   10 +-
 drivers/staging/android/logger.c                   |  113 +-
 drivers/staging/android/ram_console.c              |    2 +-
 drivers/staging/android/timed_output.c             |    1 +
 drivers/staging/asus_oled/asus_oled.c              |    6 +-
 drivers/staging/bcm/Adapter.h                      |  883 +++--
 drivers/staging/bcm/DDRInit.c                      |   26 +-
 drivers/staging/bcm/IPv6Protocol.c                 |  409 ++-
 drivers/staging/bcm/Misc.c                         |    2 +-
 drivers/staging/comedi/Kconfig                     |  253 +-
 drivers/staging/comedi/comedi.h                    |    2 +-
 drivers/staging/comedi/comedi_fops.c               | 1403 ++++----
 drivers/staging/comedi/comedidev.h                 |   72 +-
 drivers/staging/comedi/drivers.c                   |  326 +-
 drivers/staging/comedi/drivers/8255.c              |   73 +-
 drivers/staging/comedi/drivers/acl7225b.c          |   55 +-
 .../staging/comedi/drivers/addi-data/addi_common.c | 3556 +++++++-------------
 .../staging/comedi/drivers/addi-data/addi_common.h |  145 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |   18 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |  263 +-
 drivers/staging/comedi/drivers/adl_pci7230.c       |  133 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |   77 +-
 drivers/staging/comedi/drivers/adl_pci7432.c       |  149 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |  301 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  106 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |  182 +-
 drivers/staging/comedi/drivers/adq12b.c            |  250 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  223 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |  103 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  130 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   33 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |  113 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |   99 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |   85 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   87 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  256 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |  120 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |   44 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    9 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |  109 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |  142 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |  175 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |  131 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |  123 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |  132 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |  216 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |   38 +-
 drivers/staging/comedi/drivers/comedi_test.c       |  373 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |  163 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   87 +-
 drivers/staging/comedi/drivers/das08.c             |  132 +-
 drivers/staging/comedi/drivers/das08.h             |    2 +-
 drivers/staging/comedi/drivers/das16.c             |  891 +++--
 drivers/staging/comedi/drivers/das16m1.c           |  219 +-
 drivers/staging/comedi/drivers/das1800.c           |   61 +-
 drivers/staging/comedi/drivers/das6402.c           |   68 +-
 drivers/staging/comedi/drivers/das800.c            |    8 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   15 +-
 drivers/staging/comedi/drivers/dt2801.c            |  283 +-
 drivers/staging/comedi/drivers/dt2811.c            |  309 +-
 drivers/staging/comedi/drivers/dt2814.c            |  116 +-
 drivers/staging/comedi/drivers/dt2815.c            |   42 +-
 drivers/staging/comedi/drivers/dt2817.c            |   37 +-
 drivers/staging/comedi/drivers/dt282x.c            |  397 +--
 drivers/staging/comedi/drivers/dt3000.c            |  234 +-
 drivers/staging/comedi/drivers/dt9812.c            |   43 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   79 +-
 drivers/staging/comedi/drivers/fl512.c             |   47 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   98 +-
 drivers/staging/comedi/drivers/icp_multi.c         |  289 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   36 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |   84 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   98 +-
 drivers/staging/comedi/drivers/me4000.c            |  432 +--
 drivers/staging/comedi/drivers/me_daq.c            |  101 +-
 drivers/staging/comedi/drivers/mite.h              |    4 +-
 drivers/staging/comedi/drivers/mpc624.c            |  236 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |  114 +-
 drivers/staging/comedi/drivers/multiq3.c           |   37 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   10 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    9 +-
 drivers/staging/comedi/drivers/ni_660x.c           |   15 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   12 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  360 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |  238 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |   94 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   82 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |   17 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |   17 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |    9 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |   10 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c         |   13 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |  142 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |  198 +-
 drivers/staging/comedi/drivers/ni_tio_internal.h   |   36 +-
 drivers/staging/comedi/drivers/pcl711.c            |   75 +-
 drivers/staging/comedi/drivers/pcl724.c            |   65 +-
 drivers/staging/comedi/drivers/pcl725.c            |   37 +-
 drivers/staging/comedi/drivers/pcl726.c            |   46 +-
 drivers/staging/comedi/drivers/pcl730.c            |   57 +-
 drivers/staging/comedi/drivers/pcl812.c            |  166 +-
 drivers/staging/comedi/drivers/pcl816.c            |  153 +-
 drivers/staging/comedi/drivers/pcl818.c            |  166 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   51 +-
 drivers/staging/comedi/drivers/pcm3730.c           |   37 +-
 drivers/staging/comedi/drivers/pcmad.c             |   63 +-
 drivers/staging/comedi/drivers/pcmda12.c           |  224 +-
 drivers/staging/comedi/drivers/pcmmio.c            |  663 ++--
 drivers/staging/comedi/drivers/pcmuio.c            |  542 ++-
 drivers/staging/comedi/drivers/poc.c               |  205 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   16 +-
 drivers/staging/comedi/drivers/rtd520.c            |  188 +-
 drivers/staging/comedi/drivers/rti800.c            |   54 +-
 drivers/staging/comedi/drivers/rti802.c            |   37 +-
 drivers/staging/comedi/drivers/s526.c              |  495 ++-
 drivers/staging/comedi/drivers/s626.c              |  137 +-
 drivers/staging/comedi/drivers/serial2002.c        |   69 +-
 drivers/staging/comedi/drivers/skel.c              |    9 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |  223 +-
 drivers/staging/comedi/drivers/unioxx5.c           |  453 ++-
 drivers/staging/comedi/drivers/usbdux.c            |  149 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |   93 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   48 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |  113 +-
 drivers/staging/comedi/internal.h                  |    6 +-
 drivers/staging/et131x/et131x.c                    |   10 +-
 drivers/staging/frontier/alphatrack.c              |   15 +-
 drivers/staging/frontier/tranzport.c               |   16 +-
 drivers/staging/gdm72xx/Kconfig                    |   46 +
 drivers/staging/gdm72xx/Makefile                   |    6 +
 drivers/staging/gdm72xx/TODO                       |    5 +
 drivers/staging/gdm72xx/gdm_qos.c                  |  460 +++
 drivers/staging/gdm72xx/gdm_qos.h                  |   93 +
 drivers/staging/gdm72xx/gdm_sdio.c                 |  754 +++++
 drivers/staging/gdm72xx/gdm_sdio.h                 |   72 +
 drivers/staging/gdm72xx/gdm_usb.c                  |  798 +++++
 drivers/staging/gdm72xx/gdm_usb.h                  |   85 +
 drivers/staging/gdm72xx/gdm_wimax.c                | 1026 ++++++
 drivers/staging/gdm72xx/gdm_wimax.h                |   92 +
 drivers/staging/gdm72xx/hci.h                      |  218 ++
 drivers/staging/gdm72xx/netlink_k.c                |  150 +
 drivers/staging/gdm72xx/netlink_k.h                |   24 +
 drivers/staging/gdm72xx/sdio_boot.c                |  159 +
 drivers/staging/gdm72xx/sdio_boot.h                |   21 +
 drivers/staging/gdm72xx/usb_boot.c                 |  404 +++
 drivers/staging/gdm72xx/usb_boot.h                 |   22 +
 drivers/staging/gdm72xx/usb_ids.h                  |   82 +
 drivers/staging/gdm72xx/wm_ioctl.h                 |   97 +
 drivers/staging/iio/Documentation/device.txt       |    4 +-
 drivers/staging/iio/Documentation/generic_buffer.c |    4 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |    2 +-
 .../light/sysfs-bus-iio-light-tsl2583              |    6 +
 .../light/sysfs-bus-iio-light-tsl2x7x              |   13 +
 .../staging/iio/Documentation/sysfs-bus-iio-ad7192 |   20 +
 .../staging/iio/Documentation/sysfs-bus-iio-dds    |   81 +-
 .../staging/iio/Documentation/sysfs-bus-iio-light  |   15 +-
 drivers/staging/iio/Documentation/trigger.txt      |    2 +-
 drivers/staging/iio/Kconfig                        |   46 +-
 drivers/staging/iio/Makefile                       |    8 +-
 drivers/staging/iio/TODO                           |    2 +-
 drivers/staging/iio/accel/adis16201_core.c         |  123 +-
 drivers/staging/iio/accel/adis16201_ring.c         |    9 +-
 drivers/staging/iio/accel/adis16201_trigger.c      |   10 +-
 drivers/staging/iio/accel/adis16203_core.c         |  108 +-
 drivers/staging/iio/accel/adis16203_ring.c         |   16 +-
 drivers/staging/iio/accel/adis16203_trigger.c      |   10 +-
 drivers/staging/iio/accel/adis16204_core.c         |  115 +-
 drivers/staging/iio/accel/adis16204_ring.c         |   16 +-
 drivers/staging/iio/accel/adis16204_trigger.c      |   10 +-
 drivers/staging/iio/accel/adis16209_core.c         |  159 +-
 drivers/staging/iio/accel/adis16209_ring.c         |   17 +-
 drivers/staging/iio/accel/adis16209_trigger.c      |   10 +-
 drivers/staging/iio/accel/adis16220_core.c         |   39 +-
 drivers/staging/iio/accel/adis16240_core.c         |  129 +-
 drivers/staging/iio/accel/adis16240_ring.c         |   16 +-
 drivers/staging/iio/accel/adis16240_trigger.c      |   10 +-
 drivers/staging/iio/accel/kxsd9.c                  |   16 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |   50 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |   25 +-
 drivers/staging/iio/accel/sca3000_core.c           |   66 +-
 drivers/staging/iio/accel/sca3000_ring.c           |   12 +-
 drivers/staging/iio/adc/Kconfig                    |   27 +-
 drivers/staging/iio/adc/Makefile                   |    1 +
 drivers/staging/iio/adc/ad7192.c                   |   81 +-
 drivers/staging/iio/adc/ad7280a.c                  |   31 +-
 drivers/staging/iio/adc/ad7291.c                   |   26 +-
 drivers/staging/iio/adc/ad7298.h                   |    1 -
 drivers/staging/iio/adc/ad7298_core.c              |   79 +-
 drivers/staging/iio/adc/ad7298_ring.c              |   46 +-
 drivers/staging/iio/adc/ad7476.h                   |    1 -
 drivers/staging/iio/adc/ad7476_core.c              |   60 +-
 drivers/staging/iio/adc/ad7476_ring.c              |   58 +-
 drivers/staging/iio/adc/ad7606_core.c              |   39 +-
 drivers/staging/iio/adc/ad7606_par.c               |    2 +-
 drivers/staging/iio/adc/ad7606_ring.c              |   30 +-
 drivers/staging/iio/adc/ad7606_spi.c               |    2 +-
 drivers/staging/iio/adc/ad7780.c                   |   44 +-
 drivers/staging/iio/adc/ad7793.c                   |  103 +-
 drivers/staging/iio/adc/ad7816.c                   |   26 +-
 drivers/staging/iio/adc/ad7887.h                   |    1 -
 drivers/staging/iio/adc/ad7887_core.c              |   20 +-
 drivers/staging/iio/adc/ad7887_ring.c              |   46 +-
 drivers/staging/iio/adc/ad799x.h                   |    1 -
 drivers/staging/iio/adc/ad799x_core.c              |   62 +-
 drivers/staging/iio/adc/ad799x_ring.c              |   44 +-
 drivers/staging/iio/adc/adt7310.c                  |   40 +-
 drivers/staging/iio/adc/adt7410.c                  |   40 +-
 drivers/staging/iio/adc/lpc32xx_adc.c              |   35 +-
 drivers/staging/iio/adc/max1363_core.c             |   33 +-
 drivers/staging/iio/adc/max1363_ring.c             |   10 +-
 drivers/staging/iio/adc/spear_adc.c                |  448 +++
 drivers/staging/iio/addac/adt7316.c                |  152 +-
 drivers/staging/iio/cdc/ad7150.c                   |   24 +-
 drivers/staging/iio/cdc/ad7152.c                   |   30 +-
 drivers/staging/iio/cdc/ad7746.c                   |   49 +-
 drivers/staging/iio/dac/Kconfig                    |    6 +-
 drivers/staging/iio/dac/ad5064.c                   |   29 +-
 drivers/staging/iio/dac/ad5360.c                   |   21 +-
 drivers/staging/iio/dac/ad5380.c                   |   25 +-
 drivers/staging/iio/dac/ad5421.c                   |   19 +-
 drivers/staging/iio/dac/ad5446.c                   |  293 +-
 drivers/staging/iio/dac/ad5446.h                   |   20 +-
 drivers/staging/iio/dac/ad5504.c                   |   27 +-
 drivers/staging/iio/dac/ad5624r_spi.c              |   23 +-
 drivers/staging/iio/dac/ad5686.c                   |   25 +-
 drivers/staging/iio/dac/ad5764.c                   |   17 +-
 drivers/staging/iio/dac/ad5791.c                   |   25 +-
 drivers/staging/iio/dac/max517.c                   |   15 +-
 drivers/staging/iio/dds/dds.h                      |  110 -
 drivers/staging/iio/{dds => frequency}/Kconfig     |    0
 drivers/staging/iio/{dds => frequency}/Makefile    |    0
 drivers/staging/iio/{dds => frequency}/ad5930.c    |   12 +-
 drivers/staging/iio/{dds => frequency}/ad9832.c    |   36 +-
 drivers/staging/iio/{dds => frequency}/ad9832.h    |    0
 drivers/staging/iio/{dds => frequency}/ad9834.c    |   74 +-
 drivers/staging/iio/{dds => frequency}/ad9834.h    |    0
 drivers/staging/iio/{dds => frequency}/ad9850.c    |   12 +-
 drivers/staging/iio/{dds => frequency}/ad9852.c    |   12 +-
 drivers/staging/iio/{dds => frequency}/ad9910.c    |   12 +-
 drivers/staging/iio/{dds => frequency}/ad9951.c    |   12 +-
 drivers/staging/iio/frequency/dds.h                |  110 +
 drivers/staging/iio/gyro/adis16060_core.c          |   18 +-
 drivers/staging/iio/gyro/adis16080_core.c          |   16 +-
 drivers/staging/iio/gyro/adis16130_core.c          |   12 +-
 drivers/staging/iio/gyro/adis16260_core.c          |  116 +-
 drivers/staging/iio/gyro/adis16260_ring.c          |   16 +-
 drivers/staging/iio/gyro/adis16260_trigger.c       |   10 +-
 drivers/staging/iio/gyro/adxrs450.h                |    2 +-
 drivers/staging/iio/gyro/adxrs450_core.c           |   24 +-
 drivers/staging/iio/iio_dummy_evgen.c              |    4 +-
 drivers/staging/iio/iio_hwmon.c                    |    4 +-
 drivers/staging/iio/iio_simple_dummy.c             |   35 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c      |   21 +-
 drivers/staging/iio/iio_simple_dummy_events.c      |    8 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   83 +-
 drivers/staging/iio/imu/adis16400_core.c           |  141 +-
 drivers/staging/iio/imu/adis16400_ring.c           |   20 +-
 drivers/staging/iio/imu/adis16400_trigger.c        |   10 +-
 drivers/staging/iio/light/Kconfig                  |   37 +-
 drivers/staging/iio/light/Makefile                 |    2 +
 drivers/staging/iio/light/isl29018.c               |  211 +-
 drivers/staging/iio/light/isl29028.c               |  566 ++++
 drivers/staging/iio/light/tsl2563.c                |   24 +-
 drivers/staging/iio/light/tsl2583.c                |   34 +-
 drivers/staging/iio/light/tsl2x7x.h                |  100 +
 drivers/staging/iio/light/tsl2x7x_core.c           | 2082 ++++++++++++
 drivers/staging/iio/magnetometer/Kconfig           |    8 +-
 drivers/staging/iio/magnetometer/ak8975.c          |   19 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |  522 +--
 drivers/staging/iio/meter/ade7753.c                |   22 +-
 drivers/staging/iio/meter/ade7754.c                |   22 +-
 drivers/staging/iio/meter/ade7758_core.c           |  299 +-
 drivers/staging/iio/meter/ade7758_ring.c           |   33 +-
 drivers/staging/iio/meter/ade7758_trigger.c        |   10 +-
 drivers/staging/iio/meter/ade7759.c                |   22 +-
 drivers/staging/iio/meter/ade7854-i2c.c            |   22 +-
 drivers/staging/iio/meter/ade7854-spi.c            |   22 +-
 drivers/staging/iio/meter/ade7854.c                |   28 +-
 drivers/staging/iio/meter/meter.h                  |    2 +-
 drivers/staging/iio/resolver/ad2s1200.c            |   12 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   38 +-
 drivers/staging/iio/resolver/ad2s90.c              |   11 +-
 drivers/staging/iio/ring_sw.c                      |    2 +-
 drivers/staging/iio/ring_sw.h                      |    2 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   10 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |   10 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |    8 +-
 drivers/staging/iio/trigger/iio-trig-sysfs.c       |   10 +-
 drivers/staging/ipack/Kconfig                      |   20 +
 drivers/staging/ipack/Makefile                     |    6 +
 drivers/staging/ipack/TODO                         |   46 +
 drivers/staging/ipack/bridges/Kconfig              |    8 +
 drivers/staging/ipack/bridges/Makefile             |    1 +
 drivers/staging/ipack/bridges/tpci200.c            | 1141 +++++++
 drivers/staging/ipack/bridges/tpci200.h            |  162 +
 drivers/staging/ipack/devices/Kconfig              |    7 +
 drivers/staging/ipack/devices/Makefile             |    1 +
 drivers/staging/ipack/devices/ipoctal.c            |  901 +++++
 drivers/staging/ipack/devices/ipoctal.h            |   80 +
 drivers/staging/ipack/devices/scc2698.h            |  228 ++
 drivers/staging/ipack/ipack.c                      |  205 ++
 drivers/staging/ipack/ipack.h                      |  183 +
 drivers/staging/line6/config.h                     |   48 -
 drivers/staging/line6/driver.c                     |   88 +-
 drivers/staging/line6/midi.c                       |    2 +-
 drivers/staging/line6/midibuf.c                    |    2 +-
 drivers/staging/line6/pcm.c                        |    2 +-
 drivers/staging/line6/toneport.c                   |    2 +-
 drivers/staging/media/as102/as102_fe.c             |    2 -
 drivers/staging/media/as102/as102_fw.c             |    5 +-
 drivers/staging/media/as102/as102_usb_drv.c        |    5 +-
 drivers/staging/media/as102/as102_usb_drv.h        |    2 -
 drivers/staging/media/easycap/easycap_ioctl.c      |    1 +
 drivers/staging/media/easycap/easycap_main.c       |    6 +-
 drivers/staging/media/go7007/README                |    2 +-
 drivers/staging/media/go7007/s2250-loader.c        |   26 +-
 drivers/staging/media/lirc/lirc_imon.c             |   80 +-
 drivers/staging/media/lirc/lirc_sasem.c            |  100 +-
 drivers/staging/media/lirc/lirc_ttusbir.c          |   13 +-
 drivers/staging/mei/TODO                           |   10 -
 drivers/staging/net/Kconfig                        |   38 +
 drivers/staging/net/Makefile                       |    5 +
 drivers/staging/net/TODO                           |    5 +
 drivers/{net/wan => staging/net}/pc300-falc-lh.h   |    0
 drivers/{net/wan => staging/net}/pc300.h           |    0
 drivers/{net/wan => staging/net}/pc300_drv.c       |    0
 drivers/{net/wan => staging/net}/pc300_tty.c       |    0
 drivers/staging/nvec/nvec.h                        |    2 +-
 drivers/staging/octeon/ethernet-rx.c               |    2 +-
 drivers/staging/octeon/ethernet-tx.c               |   10 +-
 drivers/staging/octeon/ethernet-util.h             |    2 +-
 drivers/staging/octeon/ethernet.c                  |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |   29 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c         |    2 +-
 drivers/staging/omapdrm/Makefile                   |    1 +
 drivers/staging/omapdrm/omap_dmm_tiler.c           |    4 +-
 drivers/staging/omapdrm/omap_drv.c                 |    6 +-
 drivers/staging/omapdrm/omap_drv.h                 |   14 +
 drivers/staging/omapdrm/omap_fb.c                  |    7 +-
 drivers/staging/omapdrm/omap_gem.c                 |  130 +-
 drivers/staging/omapdrm/omap_gem_dmabuf.c          |  220 ++
 drivers/staging/omapdrm/tcm-sita.c                 |    2 +-
 drivers/staging/ozwpan/README                      |    2 +-
 drivers/staging/ozwpan/ozappif.h                   |   12 +-
 drivers/staging/ozwpan/ozcdev.c                    |   17 -
 drivers/staging/ozwpan/ozevent.c                   |  195 +-
 drivers/staging/ozwpan/ozevent.h                   |   11 +-
 drivers/staging/ozwpan/ozeventdef.h                |   19 +-
 drivers/staging/ozwpan/ozhcd.c                     |    6 +-
 drivers/staging/ozwpan/ozmain.c                    |    8 +-
 drivers/staging/ozwpan/ozusbsvc.c                  |    2 +-
 drivers/staging/panel/panel.c                      |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    6 +-
 drivers/staging/ramster/Kconfig                    |    2 +-
 drivers/staging/ramster/cluster/tcp.c              |    4 +-
 drivers/staging/ramster/xvmalloc.c                 |    2 +-
 drivers/staging/ramster/zcache-main.c              |    6 +-
 drivers/staging/rtl8187se/Makefile                 |    2 +-
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |   14 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   26 +-
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    7 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    2 +-
 drivers/staging/rtl8187se/r8180.h                  |   10 +-
 drivers/staging/rtl8187se/r8180_core.c             |   33 +-
 drivers/staging/rtl8187se/r8180_dm.c               |   16 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    4 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    6 +-
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            | 1329 ++++----
 drivers/staging/rtl8192e/Kconfig                   |    4 +
 drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c  |    3 -
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r819xE_phyreg.h  |    4 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   13 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h       |    3 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c         |   22 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |    4 +-
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |    2 +-
 drivers/staging/rtl8192e/rtllib.h                  |   18 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   10 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   35 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |    4 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |   14 +-
 drivers/staging/rtl8192e/rtllib_wx.c               |    4 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    4 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    7 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.h             |    2 +-
 drivers/staging/rtl8192u/r8192U.h                  |    9 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   60 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |   74 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |   12 +-
 drivers/staging/rtl8192u/r8192U_wx.h               |    2 +-
 drivers/staging/rtl8192u/r819xU_HTType.h           |    2 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |   12 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |    4 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |   16 +-
 drivers/staging/rtl8192u/r819xU_phyreg.h           |    2 +-
 drivers/staging/rtl8712/big_endian.h               |   94 -
 drivers/staging/rtl8712/drv_types.h                |    2 +-
 drivers/staging/rtl8712/generic.h                  |  178 -
 drivers/staging/rtl8712/hal_init.c                 |    1 -
 drivers/staging/rtl8712/ieee80211.h                |    2 +-
 drivers/staging/rtl8712/if_ether.h                 |  141 -
 drivers/staging/rtl8712/ip.h                       |  137 -
 drivers/staging/rtl8712/little_endian.h            |   94 -
 drivers/staging/rtl8712/os_intfs.c                 |    4 +-
 drivers/staging/rtl8712/osdep_service.h            |    3 -
 drivers/staging/rtl8712/rtl8712_cmd.c              |    7 +-
 drivers/staging/rtl8712/rtl8712_cmd.h              |    2 +-
 drivers/staging/rtl8712/rtl8712_efuse.c            |    2 +-
 drivers/staging/rtl8712/rtl8712_gp_bitdef.h        |    2 +-
 drivers/staging/rtl8712/rtl8712_hal.h              |    4 +-
 drivers/staging/rtl8712/rtl8712_led.c              |    6 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    9 +-
 drivers/staging/rtl8712/rtl8712_xmit.c             |    1 -
 drivers/staging/rtl8712/rtl871x_byteorder.h        |   32 -
 drivers/staging/rtl8712/rtl871x_cmd.c              |    1 -
 drivers/staging/rtl8712/rtl871x_cmd.h              |    2 +-
 drivers/staging/rtl8712/rtl871x_io.h               |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   19 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |    8 +-
 drivers/staging/rtl8712/rtl871x_mlme.h             |    6 +-
 drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h    |    4 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |    4 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |    3 +-
 drivers/staging/rtl8712/rtl871x_xmit.h             |    2 +-
 drivers/staging/rtl8712/swab.h                     |  131 -
 drivers/staging/rtl8712/usb_halinit.c              |    4 +-
 drivers/staging/rtl8712/usb_intf.c                 |   36 +-
 drivers/staging/rtl8712/usb_ops.c                  |    1 -
 drivers/staging/rtl8712/wifi.h                     |    1 -
 drivers/staging/rtl8712/xmit_linux.c               |    6 +-
 drivers/staging/rts5139/ms.c                       |   11 +-
 drivers/staging/rts5139/ms.h                       |    2 -
 drivers/staging/rts5139/ms_mg.c                    |    4 +-
 drivers/staging/rts5139/rts51x.c                   |   83 +-
 drivers/staging/rts5139/rts51x.h                   |   10 -
 drivers/staging/rts5139/rts51x_card.c              |   52 +-
 drivers/staging/rts5139/rts51x_card.h              |   11 -
 drivers/staging/rts5139/rts51x_chip.c              |  178 +-
 drivers/staging/rts5139/rts51x_chip.h              |   95 +-
 drivers/staging/rts5139/rts51x_fop.c               |    5 -
 drivers/staging/rts5139/rts51x_fop.h               |    5 -
 drivers/staging/rts5139/rts51x_scsi.c              |   93 +-
 drivers/staging/rts5139/rts51x_scsi.h              |    5 -
 drivers/staging/rts5139/rts51x_sys.h               |   54 -
 drivers/staging/rts5139/rts51x_transport.c         |  282 +-
 drivers/staging/rts5139/rts51x_transport.h         |   12 -
 drivers/staging/rts5139/sd.c                       |  142 +-
 drivers/staging/rts5139/sd.h                       |   29 -
 drivers/staging/rts5139/sd_cprm.c                  |  166 +-
 drivers/staging/rts5139/xd.c                       |  122 +-
 drivers/staging/rts5139/xd.h                       |    2 -
 drivers/staging/rts_pstor/ms.c                     |    2 +-
 drivers/staging/rts_pstor/rtsx_transport.c         |    4 +-
 drivers/staging/sep/sep_driver_config.h            |    6 +-
 drivers/staging/sep/sep_main.c                     |   12 +-
 drivers/staging/serial/68360serial.c               | 2979 ----------------
 drivers/staging/serial/Kconfig                     |   16 -
 drivers/staging/serial/Makefile                    |    1 -
 drivers/staging/serial/TODO                        |    6 -
 drivers/staging/serqt_usb2/serqt_usb2.c            |    5 +-
 drivers/staging/sm7xx/smtcfb.c                     |  232 +-
 drivers/staging/sm7xx/smtcfb.h                     |    8 -
 drivers/staging/telephony/ixj.c                    |  228 +-
 drivers/staging/tidspbridge/core/io_sm.c           |    2 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |    2 +-
 drivers/staging/usbip/stub_dev.c                   |   12 +-
 drivers/staging/usbip/usbip_common.h               |   17 +
 drivers/staging/usbip/usbip_protocol.txt           |    2 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   20 +-
 drivers/staging/usbip/vhci_hcd.c                   |    8 +-
 drivers/staging/usbip/vhci_rx.c                    |    2 +-
 drivers/staging/usbip/vhci_sysfs.c                 |    4 +-
 drivers/staging/vme/Makefile                       |    7 -
 drivers/staging/vme/TODO                           |    5 -
 drivers/staging/vme/devices/Kconfig                |    3 +-
 drivers/staging/vme/devices/vme_pio2_cntr.c        |    2 +-
 drivers/staging/vme/devices/vme_pio2_core.c        |    3 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c        |    5 +-
 drivers/staging/vme/devices/vme_user.c             |   45 +-
 drivers/staging/vt6655/wpa.c                       |    4 +-
 drivers/staging/vt6656/dpc.c                       |    2 +-
 drivers/staging/vt6656/ioctl.c                     |   24 +-
 drivers/staging/vt6656/main_usb.c                  |    4 +-
 drivers/staging/vt6656/wpa.c                       |    4 +-
 drivers/staging/wlags49_h2/README.ubuntu           |    2 +-
 drivers/staging/wlags49_h2/hcf.c                   |   10 +-
 drivers/staging/wlags49_h2/hcf.h                   |   12 +-
 drivers/staging/wlags49_h2/mmd.c                   |   12 +-
 drivers/staging/wlags49_h2/wl_cs.c                 |    3 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |    9 +-
 drivers/staging/wlags49_h2/wl_pci.c                |    4 +
 drivers/staging/wlags49_h2/wl_profile.c            |    8 +-
 drivers/staging/wlags49_h2/wl_util.c               |   11 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   10 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |    4 +-
 drivers/staging/xgifb/XGI_main.h                   |  221 +-
 drivers/staging/xgifb/XGI_main_26.c                |  101 +-
 drivers/staging/xgifb/XGIfb.h                      |    6 +-
 drivers/staging/xgifb/vb_init.c                    |   78 +-
 drivers/staging/xgifb/vb_setmode.c                 | 1457 +++-----
 drivers/staging/xgifb/vb_struct.h                  |   27 -
 drivers/staging/xgifb/vb_table.h                   |  725 +---
 drivers/staging/xgifb/vgatypes.h                   |    2 -
 drivers/staging/zsmalloc/zsmalloc-main.c           |   40 +-
 drivers/staging/zsmalloc/zsmalloc_int.h            |    2 +-
 drivers/{staging => }/vme/Kconfig                  |    6 +-
 drivers/vme/Makefile                               |    7 +
 drivers/{staging => }/vme/boards/Kconfig           |    0
 drivers/{staging => }/vme/boards/Makefile          |    0
 drivers/{staging => }/vme/boards/vme_vmivme7805.c  |    0
 drivers/{staging => }/vme/boards/vme_vmivme7805.h  |    0
 drivers/{staging => }/vme/bridges/Kconfig          |    0
 drivers/{staging => }/vme/bridges/Makefile         |    0
 drivers/{staging => }/vme/bridges/vme_ca91cx42.c   |    8 +-
 drivers/{staging => }/vme/bridges/vme_ca91cx42.h   |    0
 drivers/{staging => }/vme/bridges/vme_tsi148.c     |  189 +-
 drivers/{staging => }/vme/bridges/vme_tsi148.h     |   21 +-
 drivers/{staging => }/vme/vme.c                    |   41 +-
 drivers/{staging => }/vme/vme_bridge.h             |    0
 fs/pstore/Kconfig                                  |   17 +
 fs/pstore/Makefile                                 |    3 +
 fs/pstore/ram.c                                    |  383 +++
 .../persistent_ram.c => fs/pstore/ram_core.c       |  161 +-
 include/linux/Kbuild                               |    2 +
 include/linux/alarmtimer.h                         |    3 +
 {drivers/staging => include/linux}/iio/buffer.h    |    4 +-
 {drivers/staging => include/linux}/iio/consumer.h  |    2 +-
 {drivers/staging => include/linux}/iio/driver.h    |    0
 {drivers/staging => include/linux}/iio/events.h    |    2 +-
 {drivers/staging => include/linux}/iio/iio.h       |  101 +-
 {drivers/staging => include/linux}/iio/kfifo_buf.h |    4 +-
 {drivers/staging => include/linux}/iio/machine.h   |    0
 {drivers/staging => include/linux}/iio/sysfs.h     |    0
 {drivers/staging => include/linux}/iio/trigger.h   |    8 +-
 .../linux}/iio/trigger_consumer.h                  |    0
 {drivers/staging => include/linux}/iio/types.h     |    2 +
 {drivers/staging/mei => include/linux}/mei.h       |    0
 include/linux/platform_data/at91_adc.h             |   61 +
 .../persistent_ram.h => include/linux/pstore_ram.h |   30 +-
 include/linux/ramoops.h                            |   17 -
 include/linux/uuid.h                               |    4 +
 {drivers/staging/vme => include/linux}/vme.h       |    0
 kernel/time/alarmtimer.c                           |    4 +-
 622 files changed, 28356 insertions(+), 26059 deletions(-)
 rename {drivers/staging/iio/Documentation => Documentation/ABI/testing}/sysfs-bus-iio (96%)
 create mode 100644 Documentation/devicetree/bindings/arm/atmel-adc.txt
 create mode 100644 Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt
 create mode 100644 Documentation/devicetree/bindings/staging/iio/adc/spear-adc.txt
 create mode 100644 Documentation/misc-devices/mei/.gitignore
 create mode 100644 Documentation/misc-devices/mei/Makefile
 create mode 100644 Documentation/misc-devices/mei/TODO
 rename {drivers/staging => Documentation/misc-devices}/mei/mei-amt-version.c (99%)
 rename {drivers/staging => Documentation/misc-devices}/mei/mei.txt (100%)
 rename {drivers/staging/vme => Documentation}/vme_api.txt (100%)
 delete mode 100644 drivers/char/ramoops.c
 create mode 100644 drivers/iio/Kconfig
 create mode 100644 drivers/iio/Makefile
 create mode 100644 drivers/iio/adc/Kconfig
 create mode 100644 drivers/iio/adc/Makefile
 create mode 100644 drivers/iio/adc/at91_adc.c
 create mode 100644 drivers/iio/amplifiers/Kconfig
 create mode 100644 drivers/iio/amplifiers/Makefile
 create mode 100644 drivers/iio/amplifiers/ad8366.c
 rename drivers/{staging => }/iio/iio_core.h (94%)
 rename drivers/{staging => }/iio/iio_core_trigger.h (100%)
 rename drivers/{staging => }/iio/industrialio-buffer.c (92%)
 rename drivers/{staging => }/iio/industrialio-core.c (92%)
 rename drivers/{staging => }/iio/industrialio-event.c (97%)
 rename drivers/{staging => }/iio/industrialio-trigger.c (96%)
 rename drivers/{staging => }/iio/inkern.c (98%)
 rename drivers/{staging => }/iio/kfifo_buf.c (99%)
 rename drivers/{staging => misc}/mei/Kconfig (100%)
 rename drivers/{staging => misc}/mei/Makefile (100%)
 rename drivers/{staging => misc}/mei/hw.h (100%)
 rename drivers/{staging => misc}/mei/init.c (99%)
 rename drivers/{staging => misc}/mei/interface.c (99%)
 rename drivers/{staging => misc}/mei/interface.h (94%)
 rename drivers/{staging => misc}/mei/interrupt.c (99%)
 rename drivers/{staging => misc}/mei/iorw.c (99%)
 rename drivers/{staging => misc}/mei/main.c (96%)
 rename drivers/{staging => misc}/mei/mei_dev.h (99%)
 rename drivers/{staging => misc}/mei/wd.c (82%)
 delete mode 100644 drivers/staging/android/alarm.c
 create mode 100644 drivers/staging/gdm72xx/Kconfig
 create mode 100644 drivers/staging/gdm72xx/Makefile
 create mode 100644 drivers/staging/gdm72xx/TODO
 create mode 100644 drivers/staging/gdm72xx/gdm_qos.c
 create mode 100644 drivers/staging/gdm72xx/gdm_qos.h
 create mode 100644 drivers/staging/gdm72xx/gdm_sdio.c
 create mode 100644 drivers/staging/gdm72xx/gdm_sdio.h
 create mode 100644 drivers/staging/gdm72xx/gdm_usb.c
 create mode 100644 drivers/staging/gdm72xx/gdm_usb.h
 create mode 100644 drivers/staging/gdm72xx/gdm_wimax.c
 create mode 100644 drivers/staging/gdm72xx/gdm_wimax.h
 create mode 100644 drivers/staging/gdm72xx/hci.h
 create mode 100644 drivers/staging/gdm72xx/netlink_k.c
 create mode 100644 drivers/staging/gdm72xx/netlink_k.h
 create mode 100644 drivers/staging/gdm72xx/sdio_boot.c
 create mode 100644 drivers/staging/gdm72xx/sdio_boot.h
 create mode 100644 drivers/staging/gdm72xx/usb_boot.c
 create mode 100644 drivers/staging/gdm72xx/usb_boot.h
 create mode 100644 drivers/staging/gdm72xx/usb_ids.h
 create mode 100644 drivers/staging/gdm72xx/wm_ioctl.h
 create mode 100755 drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
 create mode 100755 drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-ad7192
 create mode 100644 drivers/staging/iio/adc/spear_adc.c
 delete mode 100644 drivers/staging/iio/dds/dds.h
 rename drivers/staging/iio/{dds => frequency}/Kconfig (100%)
 rename drivers/staging/iio/{dds => frequency}/Makefile (100%)
 rename drivers/staging/iio/{dds => frequency}/ad5930.c (94%)
 rename drivers/staging/iio/{dds => frequency}/ad9832.c (90%)
 rename drivers/staging/iio/{dds => frequency}/ad9832.h (100%)
 rename drivers/staging/iio/{dds => frequency}/ad9834.c (83%)
 rename drivers/staging/iio/{dds => frequency}/ad9834.h (100%)
 rename drivers/staging/iio/{dds => frequency}/ad9850.c (92%)
 rename drivers/staging/iio/{dds => frequency}/ad9852.c (96%)
 rename drivers/staging/iio/{dds => frequency}/ad9910.c (97%)
 rename drivers/staging/iio/{dds => frequency}/ad9951.c (95%)
 create mode 100644 drivers/staging/iio/frequency/dds.h
 create mode 100644 drivers/staging/iio/light/isl29028.c
 create mode 100755 drivers/staging/iio/light/tsl2x7x.h
 create mode 100755 drivers/staging/iio/light/tsl2x7x_core.c
 create mode 100644 drivers/staging/ipack/Kconfig
 create mode 100644 drivers/staging/ipack/Makefile
 create mode 100644 drivers/staging/ipack/TODO
 create mode 100644 drivers/staging/ipack/bridges/Kconfig
 create mode 100644 drivers/staging/ipack/bridges/Makefile
 create mode 100644 drivers/staging/ipack/bridges/tpci200.c
 create mode 100644 drivers/staging/ipack/bridges/tpci200.h
 create mode 100644 drivers/staging/ipack/devices/Kconfig
 create mode 100644 drivers/staging/ipack/devices/Makefile
 create mode 100644 drivers/staging/ipack/devices/ipoctal.c
 create mode 100644 drivers/staging/ipack/devices/ipoctal.h
 create mode 100644 drivers/staging/ipack/devices/scc2698.h
 create mode 100644 drivers/staging/ipack/ipack.c
 create mode 100644 drivers/staging/ipack/ipack.h
 delete mode 100644 drivers/staging/line6/config.h
 delete mode 100644 drivers/staging/mei/TODO
 create mode 100644 drivers/staging/net/Kconfig
 create mode 100644 drivers/staging/net/Makefile
 create mode 100644 drivers/staging/net/TODO
 rename drivers/{net/wan => staging/net}/pc300-falc-lh.h (100%)
 rename drivers/{net/wan => staging/net}/pc300.h (100%)
 rename drivers/{net/wan => staging/net}/pc300_drv.c (100%)
 rename drivers/{net/wan => staging/net}/pc300_tty.c (100%)
 create mode 100644 drivers/staging/omapdrm/omap_gem_dmabuf.c
 delete mode 100644 drivers/staging/rtl8712/big_endian.h
 delete mode 100644 drivers/staging/rtl8712/generic.h
 delete mode 100644 drivers/staging/rtl8712/if_ether.h
 delete mode 100644 drivers/staging/rtl8712/ip.h
 delete mode 100644 drivers/staging/rtl8712/little_endian.h
 delete mode 100644 drivers/staging/rtl8712/rtl871x_byteorder.h
 delete mode 100644 drivers/staging/rtl8712/swab.h
 delete mode 100644 drivers/staging/rts5139/rts51x_sys.h
 delete mode 100644 drivers/staging/serial/68360serial.c
 delete mode 100644 drivers/staging/serial/Kconfig
 delete mode 100644 drivers/staging/serial/Makefile
 delete mode 100644 drivers/staging/serial/TODO
 delete mode 100644 drivers/staging/vme/TODO
 rename drivers/{staging => }/vme/Kconfig (73%)
 create mode 100644 drivers/vme/Makefile
 rename drivers/{staging => }/vme/boards/Kconfig (100%)
 rename drivers/{staging => }/vme/boards/Makefile (100%)
 rename drivers/{staging => }/vme/boards/vme_vmivme7805.c (100%)
 rename drivers/{staging => }/vme/boards/vme_vmivme7805.h (100%)
 rename drivers/{staging => }/vme/bridges/Kconfig (100%)
 rename drivers/{staging => }/vme/bridges/Makefile (100%)
 rename drivers/{staging => }/vme/bridges/vme_ca91cx42.c (99%)
 rename drivers/{staging => }/vme/bridges/vme_ca91cx42.h (100%)
 rename drivers/{staging => }/vme/bridges/vme_tsi148.c (94%)
 rename drivers/{staging => }/vme/bridges/vme_tsi148.h (99%)
 rename drivers/{staging => }/vme/vme.c (97%)
 rename drivers/{staging => }/vme/vme_bridge.h (100%)
 create mode 100644 fs/pstore/ram.c
 rename drivers/staging/android/persistent_ram.c => fs/pstore/ram_core.c (85%)
 rename {drivers/staging => include/linux}/iio/buffer.h (98%)
 rename {drivers/staging => include/linux}/iio/consumer.h (99%)
 rename {drivers/staging => include/linux}/iio/driver.h (100%)
 rename {drivers/staging => include/linux}/iio/events.h (99%)
 rename {drivers/staging => include/linux}/iio/iio.h (84%)
 rename {drivers/staging => include/linux}/iio/kfifo_buf.h (70%)
 rename {drivers/staging => include/linux}/iio/machine.h (100%)
 rename {drivers/staging => include/linux}/iio/sysfs.h (100%)
 rename {drivers/staging => include/linux}/iio/trigger.h (92%)
 rename {drivers/staging => include/linux}/iio/trigger_consumer.h (100%)
 rename {drivers/staging => include/linux}/iio/types.h (94%)
 rename {drivers/staging/mei => include/linux}/mei.h (100%)
 create mode 100644 include/linux/platform_data/at91_adc.h
 rename drivers/staging/android/persistent_ram.h => include/linux/pstore_ram.h (71%)
 delete mode 100644 include/linux/ramoops.h
 rename {drivers/staging/vme => include/linux}/vme.h (100%)

---------------

Aaro Koskinen (25):
      staging: xgifb: XGIfb_mode_rate_to_ddata: delete commented-out code
      staging: xgifb: XGIfb_mode_rate_to_ddata: initialize ModeIdIndex properly
      staging: xgifb: XGIfb_mode_rate_to_dclock: delete commented-out code
      staging: xgifb: XGIfb_mode_rate_to_dclock: initialize ModeIdIndex properly
      staging: xgifb: drop XG41 code
      staging: xgifb: drop XG45 code
      staging: xgifb: delete XGI300paneltype
      staging: xgifb: delete rate_idx from mode table
      staging: xgifb: eliminate string comparison from mode search
      staging: xgifb: drop redudant mode table entries
      staging: xgifb: delete mode names from the mode table
      staging: xgifb: delete mode rows and columns
      staging: xgifb: delete MD_XGI300
      staging: xgifb: unwrap mode table lines
      staging: xgifb: drop code for legacy VGA modes
      staging: xgifb: delete SModeIDTable
      staging: xgifb: delete code for EGA or lower modes
      staging: xgifb: truncate XGI330_StandTable
      staging: xgifb: delete StandTableIndex parameters
      staging: xgifb: delete legacy DAC data
      staging: xgifb: XGI_ExtStruct: delete unused fields
      staging: xgifb: delete VB_ExtTVFlickerIndex
      staging: xgifb: delete VB_ExtTVEdgeIndex
      staging: xgifb: eliminate redundant struct definition
      staging: xgifb: inline XGI_GetResInfo()

Andrew Miller (5):
      Staging: rtl8187se: r8185b_init.c: Fixed spacing
      Staging: rtl8187se: r8185b_init.c: Fix function declarations
      Staging: rtl8187se: r8185b_init.c: Fix some spacing issues
      Staging: rtl8187se: r8185b_init.c: Removed old comments
      Staging: rtl8187se: r8185b_init.c: Fix comment blocks

Anton Vorontsov (13):
      persistent_ram: Remove prz->node
      persistent_ram: Fix buffer size clamping during writes
      staging: android: persistent_ram: Introduce persistent_ram_post_init()
      staging: android: persistent_ram: Introduce persistent_ram_new()
      staging: android: persistent_ram: Introduce persistent_ram_vmap()
      staging: android: persistent_ram: Make it possible to use memory outside of bootmem
      staging: android: persistent_ram: Introduce persistent_ram_free()
      staging: android: persistent_ram: Remove never used struct persistent_ram_zone members
      staging: android: persistent_ram: Prepare for modular builds
      ramoops: Move to fs/pstore/ram.c
      staging: android: persistent_ram: Move to fs/pstore/ram_core.c
      pstore/ram: Switch to persistent_ram routines
      pstore/ram: Add ECC support

Axel Köllhofer (1):
      staging/rtl8192e - fix typo in printk message

Axel Lin (2):
      IIO: industrialio-core: Use simple_open
      IIO: industrialio-core: Checking NULL instead of IS_ERR for debugfs_create_dir()

Benedikt Bergenthal (1):
      Drivers: Staging: Comedi: comedi_fops: Fixed a code style issue

Christopher Harvey (2):
      staging: usbip: fix potential segfault because of unchecked return value of strchr.
      staging: usbip: Fix typo in printed text

Dan Carpenter (9):
      Staging: rts5139: a couple off by one fixes
      Staging: rtl8192u: fix some memory corruption
      Staging: rtl8192e: remove some dead code
      Staging: wlags49_h2: reading past the end of array
      Staging: wlan-ng: off by one in prism2mgmt_scan_results()
      staging: comedi vmk80xx: lock held on error path
      Staging: ipack: returning a freed pointer
      Staging: ipack: dereferencing freed memory
      Staging: wlags49_h2: potential NULL dereference

Dan Magenheimer (1):
      ramster: switch over to zsmalloc and crypto interface

Dmitry Eremin-Solenikov (4):
      staging/xgifb: remove unused variable
      staging/xgifb: drop RelIO from vb_device_info
      staging/xgifb: simplify vga I/O ports handling
      staging/xgifb: fix addressing issues on platform with long physical addressing

Emil Goode (1):
      staging: android: binder: fix sparse warnings

Geert Uytterhoeven (1):
      staging: gdm72xx: WIMAX_GDM72XX_USB_PM should depend on USB_SUSPEND

Gerard Snitselaar (1):
      staging: comedi: resolve section mismatch in s626

Greg Kroah-Hartman (21):
      Staging: line6: remove unneeded initialization
      Staging: line6: only allocate a buffer if it is needed
      Staging: line6: remove teardown code from module_exit path
      Staging: line6: use module_usb_driver()
      Staging: media: go7007: use module_usb_driver()
      staging: asus_oled.c: remove err() usage
      staging: line6: toneport.c: remove err() usage
      staging: frontier: tranzport.c: remove err() usage
      staging: frontier: alphatrack.c: remove err() usage
      staging: comedi: vmk80xx.c: remove err() usage
      staging: comedi: dt9812.c: remove err() usage
      Staging: media: easycap: remove err() usage
      Staging: media: lirc: lirc_imon: remove err() usage
      Staging: media: lirc: lirc_sasem: remove err() usage
      Staging: media: lirc: lirc_ttusbir: remove err() usage
      Staging: quatech_usb3: remove err() usage
      Staging: serqt_usb2: remove err() usage
      staging: vme: vme.c: fix minor coding style issues
      Staging: VME: move VME drivers out of staging
      Staging: mei: move the mei code out of staging
      Revert "ramster: switch over to zsmalloc and crypto interface"

H Hartley Sweeten (99):
      staging: comedi: use ARRAY_SIZE instead of custom n_boardtypes macros
      staging: comedi: refactor c6xdigio driver to remove forward declarations
      staging: comedi: refactor aio_iiro_16 driver to remove forward declarations
      staging: comedi: refactor adv_pci7123 driver to remove forward declarations
      staging: comedi: refactor adq12b driver to remove forward declarations
      staging: comedi: refactor adl_pci9111 driver to remove forward declarations
      staging: comedi: refactor adl_pci8164 driver to remove forward declarations
      staging: comedi: refactor adl_pci7432 driver to remove forward declarations
      staging: comedi: refactor adl_pci7296 driver to remove forward declarations
      staging: comedi: refactor adl_pci7230 driver to remove forward declarations
      staging: comedi: refactor the adl_pci6208 driver to remove the forward declarations
      staging: comedi: refactor the acl7225b driver to remove the forward declarations
      staging: comedi: refactor 8255 driver to remove forward declarations
      staging: comedi: introduce 'comedi_board' helper function
      staging: comedi: refactor dt2815 driver to remove forward declarations
      staging: comedi: refactor dt2817 driver to remove forward declarations
      staging: comedi: refactor ke_counter driver to remove forward declarations
      staging: comedi: refactor fl512 driver to remove forward declarations
      staging: comedi: refactor pcl711 driver to remove the forward declarations
      staging: comedi: refactor pcl724 driver to remove the forward declarations
      staging: comedi: refactor pcl725 driver to remove forward declarations
      staging: comedi: refactor pcl726 driver to remove forward declarations
      staging: comedi: refactor pcl730 driver to remove forward declarations
      staging: comedi: refactor pcl812 driver to remove forward declarations
      staging: comedi: refactor pcl816 driver to remove forward declarations
      staging: comedi: refactor pcl818 driver to remove forward declarations
      staging: comedi: refactor pcm3724 driver to remove forward declarations
      staging: comedi: refactor pcm3730 driver to remove forward declarations
      staging: comedi: refactor pcmad driver to remove forward declarations
      staging: comedi: refactor pcmda12 driver to remove forward declarations
      staging: comedi: refactor pcmmio driver to remove forward declarations
      staging: comedi: refactor pcmuio driver to remove forward declarations
      staging: comedi: refactor poc driver to remove forward declarations
      staging: comedi: partial refactor of the rtd520 driver to remove forward declarations
      staging: comedi: refactor rti800 driver to remove forward declarations
      staging: comedi: refactor rti802 driver to remove forward declarations
      staging: comedi: refactor s526 driver to remove forward declarations
      staging: comedi: refactor serial2002 driver to remove forward declarations
      staging: comedi: fix build errors caused by module_init/module_exit refactor
      staging: comedi: Add helper macro for comedi_driver boilerplate
      vme: vme_ca91cx42.c: local functions should not be exposed globally
      staging: comedi: use module_comedi_driver
      staging: comedi: remove debug tracing in vmk80xx driver
      staging: comedi: refactor unioxx5 driver and use module_comedi_driver
      staging: comedi: refactor ssv_dnp driver and use module_comedi_driver
      staging: comedi: partial refactor of s626 driver to remove forward declarations
      staging: comedi: refactor multiq3 driver and use module_comedi_driver
      staging: comedi: refactor mpc8260cpm driver and use module_comedi_driver
      staging: comedi: refactor mpc624 driver and use module_comedi_driver
      staging: comedi: refactor me_daq driver to remove forward declarations
      staging: comedi: refactor me4000 driver to remove forward declarations
      staging: comedi: refactor jr3_pci driver to remove forward declarations
      staging: comedi: refactor the icp_multi driver to remove forward declarations
      staging: comedi: refactor dyna_pci10xx driver to remove forward declarations
      staging: comedi: refactor dt3000 driver to remove forward declarations
      staging: comedi: refactor dt282x driver to remove forward declarations
      staging: comedi: refactor dt2814 driver and use module_comedi_driver
      staging: comedi: rename addi CamelCase function pointers
      staging: comedi: mite: mite_io_addr and daq_io_addr are void __iomem *
      staging: comedi: rtf520: las0, las1, and lcfg are void __iomem *
      staging: comedi: refactor sysfs files in comedi_fops.c
      staging: comedi: register sysfs device attributes with driver core
      staging: comedi: Add helper macro for comedi pci driver boilerplate
      staging: comedi: Use module_comedi_pci_driver and standardize drivers
      staging: comedi: refactor ni_pcimio driver and use module_comedi_pci_driver
      staging: comedi: refactor unioxx5 driver to remove forward declarations
      staging: comedi: refactor ni_atmio driver and use module_comedi_driver
      staging: comedi: refactor ni_atmio16d driver and use module_comedi_driver
      staging: comedi: refactor ni_at_ao driver and use module_comedi_driver
      staging: comedi: refactor ni_at_a2150 driver and use module_comedi_driver
      staging: comedi: refactor ni_pcidio driver and use module_comedi_driver
      staging: comedi: refactor ii_pci20kc driver and use module_comedi_driver
      staging: comedi: refactor gsc_hpdi driver and use module_comedi_pci_driver
      staging: comedi: refactor dt2811 driver and use module_comedi_driver
      staging: comedi: refactor dt2801 driver and use module_comedi_driver
      staging: comedi: refactor das6402 driver and use module_comedi_driver
      staging: comedi: refactor das16m1 driver and use module_comedi_driver
      staging: comedi: refactor comedi_test driver and use module_comedi_driver
      staging: comedi: refactor comedi_parport driver and use module_comedi_driver
      staging: comedi: refactor comedi_bond driver and use module_comedi_driver
      staging: comedi: refactor cb_pcimdda driver and use module_comedi_pci_driver
      staging: comedi: refactor cb_pcimdas driver and use module_comedi_pci_driver
      staging: comedi: refactor cb_pcidio driver and use module_comedi_pci_driver
      staging: comedi: refactor cb_pcidda driver and use module_comedi_pci_driver
      staging: comedi: refactor cb_pcidas driver and use module_comedi_pci_driver
      staging: comedi: refactor cb_pcidas64 driver and use module_comedi_pci_driver
      staging: comedi: refactor amplc_pci230 driver and use module_comedi_pci_driver
      staging: comedi: refactor amplc_pci224 driver and use module_comedi_pci_driver
      staging: comedi: refactor adl_pci9118 driver and use module_comedi_pci_driver
      staging: comedi: refactor adv_pci1_dio driver and use module_comedi_pci_driver
      staging: comedi: refactor adv_pci1710 driver and use module_comedi_pci_driver
      staging: comedi: refactor das1800 driver and use module_comedi_driver
      staging: comedi: refactor daqboard2000 driver and use module_comedi_pci_driver
      staging: comedi: refactor contec_pci_dio driver and use module_comedi_pci_driver
      staging: comedi: refactor das16 driver and use module_comedi_driver
      staging: comedi: Convert struct addi_board initialization to C99 format
      staging: comedi: Add helper macro for comedi usb driver boilerplate
      staging: comedi: remove all 'default N' in Kconfig
      staging: comedi: cleanup all the comedi_driver 'detach' functions

H Hartley Sweeten lin (1):
      vme: vme_tsi148.c: local functions should not be exposed globally

Hitoshi NAKAMORI (1):
      Staging:rts_pstor: fix coding style issue in rtsx_transport.c

Ian Abbott (17):
      staging: comedi: amplc_dio200: separately configure ISA and PCI
      staging: comedi: amplc_pc236: separately configure ISA and PCI
      staging: comedi: amplc_pc263: separately configure ISA and PCI
      staging: comedi: das08: separately configure ISA and PCI
      staging: comedi: pass 'struct comedi_driver *' to comedi_..._auto_config
      staging: comedi: don't disable IRQ for comedi_file_info_table_lock
      staging: comedi: don't hijack hardware device private data
      staging: comedi: pass usb interface to comedi_usb_auto_config
      staging: comedi: refactor comedi_device_attach() a bit
      staging: comedi: add bus-type-specific attach hooks for PCI and USB
      staging: comedi: pass struct comedi_driver * to comedi_auto_config()
      staging: comedi: restrict comedi_auto_config() to single driver
      staging: comedi: amplc_pci224: use attach_pci() hook
      staging: comedi: usbdux: use attach_usb() hook
      staging: comedi: usbdux: remove an unnecessary dev_info()
      staging: comedi: Add module parameters for default buffer size
      staging: comedi: Add kernel config for default buffer sizes

Javier M. Mellid (7):
      staging: sm7xx: remove old references and non updated comments
      staging: sm7xx: dead code removal
      staging: sm7xx: use dynamic debug support
      staging: sm7xx: use dynamic debug support to show info and errors
      staging: sm7xx: merge hardware information in smtcfb_info struct
      staging: sm7xx: remove driver version support
      staging: sm7xx: rename function

Jesper Juhl (8):
      staging/telephony/ixj.c: delete trailing whitespace
      staging: vt6656: Don't needlessly test for NULL before release_firmware()
      staging: as102: Remove redundant NULL check before release_firmware() and pointless comments
      staging: olpc_dcon.c: strings printed with printk() put on a single line
      staging: olpc_dcon.c: Add missing level to a printk()
      staging: olpc_dcon.c: Remove a few spaces between casts and variables
      staging: vt6656: Remove redundant casts from ioctl.c
      staging: vt6656: trivial whitespace cleanups to ioctl.c

Jim Cromie (1):
      staging: replace open-coded ARRAY_SIZEs

Jiri Slaby (1):
      NET: pc300, move to staging as it is broken

Joe Perches (1):
      staging: Remove test of is_broadcast with is_multicast

Johannes Thumshirn (5):
      staging: line6/midibuf.c changed printk(KERN_DEBUG, ... to pr_debug(
      staging: line6/midi.c: Added space between switch and open parenthesis
      staging: line6/pcm.c: Removed trailing whitespace
      staging: line6/config.h: Remove CHECKPOINT macro
      staging: line6/config.h: Delete unused header

John Stultz (5):
      staging: android-alarm: Convert ALARM_ELAPSED_REALTIME to use CLOCK_BOOTTIME
      alarmtimer: Provide accessor to alarmtimer rtc device
      staging: android-alarm: Rework alarm-dev.c to use upstreamed alarmtimers
      android-alarm: Remove unused android alarm in-kernel interfaces
      staging: android-alarm: Switch from wakelocks to wakeup sources

Jon Brenner (2):
      staging: iio: add TAOS tsl2x7x driver
      staging: iio: tsl2x7x: bugfixes

Jonathan Cameron (57):
      staging:iio:buffer example fix typos
      staging:iio:adc:max1363 fix missing update_scan_mask callback.
      staging:iio fill in some missing docs
      staging:iio:max1363 enable use with inkernel interfaces.
      staging:iio:accel:lis3l02dq add symmetry to check for presence of trigger.
      staging:iio: use spi->irq valid rather than querying available modes
      staging:iio:light:tsl2563 channel spec buglet / always reading same adc.
      staging:iio:Documentation: Fix a cut and paste error.
      staging:iio:iio_core.h make less dependent on other included headers
      staging:iio: chan_spec - take extend_name constant.
      staging:iio:accel:adis16201 unwind use of IIO_CHAN macro.
      staging:iio:accel:adis16203 unwind use of IIO_CHAN macro.
      staging:iio:accel:adis16204 unwind use of IIO_CHAN macro.
      staging:iio:accel:adis16209 unwind use of IIO_CHAN macro.
      staging:iio:accel:adis16240 unwind use of IIO_CHAN macro.
      staging:iio:accel:lis3l02dq unwind use of IIO_CHAN macro.
      staging:iio:accel:sca3000 unwind use of IIO_CHAN macro.
      staging:iio:adc:ad7298 unwind use of IIO_CHAN macro.
      staging:iio:adc:ad7476 unwind use of IIO_CHAN macro.
      staging:iio:accel:ad7780 unwind use of IIO_CHAN macro.
      staging:iio:gyro:adis16260 unwind use of IIO_CHAN macro.
      staging:iio:impedance-analyzer:ad5933 unwind use of IIO_CHAN macro.
      staging:iio:meter:ade7758 unwind use of IIO_CHAN macro.
      staging:iio:core drop the IIO_CHAN macro for ease of maintenance.
      staging:iio: add a raw and processed elements to info_mask
      staging:iio:accel Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:adc Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:dac Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:gyro Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:imu Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:light Add IIO_CHAN_INFO_RAW/PROCESSED entries to all drivers.
      staging:iio:magnetometer Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:resolver Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:impedance Add IIO_CHAN_INFO_RAW/PROCESSED entries to all drivers.
      staging:iio:cdc Add IIO_CHAN_INFO_RAW/PROCESSED entries to all drivers.
      staging:iio:isl29028 Add IIO_CHAN_INFO_RAW/PROCESSED entries
      staging:iio: Make read / write attributes for channel values optional.
      staging:iio: drop procesed_val element of chan_spec.
      staging:iio:buffer trivial use of strtobool to remove dodgy equivalent.
      staging:iio:buffer: pull computation of scan length into a utility function.
      staging:iio: scan_index_timestamp move to iio_dev from buffer
      staging:iio: add caching of the number of bytes in a scan.
      staging:iio:adc:ad7192 make use of iio_sw_buffer_preenable.
      staging:iio:adc:ad7298 use iio_sw_buffer_preenable to avoid code repitition.
      staging:iio:adc:ad7476 use iio_sw_buffer_preenable instead of local version.
      staging:iio:adc:ad7793 use iio_sw_buffer_preenable to avoid repitition.
      staging:iio:adc:ad7887 make use of iio_sw_buffer_preenable.
      staging:iio:adc:ad799x use iio_sw_buffer_preenable to avoid code repitiion
      staging:iio:meter:ad7758 use iio_sw_buffer_preenable to avoid code repition
      staging:iio:impedance-analyser make use of iio_sw_buffer_preenable
      staging:iio: Add caching of scan_timestamp to the core as well as buffers.
      staging:iio: pull out demux cleanup for a particular buffer.
      staging:iio:documentation pull a few sysfs entries out of main docs.
      staging:iio:Documentation Trivial typo fixes.
      IIO: Move core headers to include/linux/iio
      IIO: Move the core files to drivers/iio
      IIO: Move the core abi documentation from staging

Julia Lawall (3):
      drivers/staging/wlags49_h2/wl_pci.c: add missing wl_device_dealloc and wl_remove
      drivers/staging/rtl8192u/ieee80211/ieee80211_module.c: add missing free_netdev
      drivers/staging/comedi/comedi_fops.c: add missing vfree

Justin P. Mattock (16):
      staging:nvec:nvec.h Fix typos in staging:nvec
      staging:ozwpan:ozhcd.c Fix typos in staging:ozwpan
      staging:olpc_dcon:olpc_dcon_xo_1.c Fix typo in staging:olpc_dcon
      staging:panel:panel.c Fix typo in staging:panel
      staging:quatech_usb2:quatech_usb2.c Fix typo in staging:quatech_usb2
      staging:octeon Fix typos in staging:octeon
      staging:omapdrm Fix typos in drivers:omapdrm
      staging:ramster Fix typos in staging:ramster
      Staging: rtl8187se: Fix typos.
      staging: rtl8192e: Fix typos.
      staging: rtl8192u Fix typos.
      staging: rtl8192u Fix a typo.
      staging:rtl8192u Fix typos and comments
      staging: "rtl8192e/r8192u" typo change ContiuneDiffCount.
      staging: rtl8712: Fix typos.
      staging: "rts5139" Fix typos.

Kees Cook (1):
      ramoops: use pstore interface

Kevin McKinney (7):
      Staging: bcm: Properly format braces in Adapter.h
      Staging: bcm: Fix all whitespace issues in Adapter.h
      Staging: bcm: Correctly format all comments in Adapter.h
      Staging: bcm: Fix warning: __packed vs. __attribute__((packed)) in Adapter.h
      Staging: bcm: Rename all "INT" to "int" in Adapter.h
      Staging: bcm: Removes the volatile type definition from Adapter.h
      Staging: bcm: Remove two unused variables from Adapter.h

Kim, Milo (1):
      staging: android: timed_output : disable the timed output device when the device is unregistered

Krzysztof Wilczynski (1):
      staging: wlan-ng: Release struct returned by cfg80211_inform_bss to avoid potential memory leak.

Larry Finger (3):
      staging: r8192e: Fix possible error in configuration
      staging: r8192e_pci: Change memcpy to memcmp
      staging: r8712u: Remove needless test for NULL

Lars-Peter Clausen (39):
      staging:iio: Add IIO_CHAN_INFO_RAW entries to the dummy driver
      staging:iio:meter Add IIO_CHAN_INFO_RAW entries to all drivers.
      staging:iio:dac:ad5446: Do not exit powerdown when writing a sample
      staging:iio:dac:ad5446: Remove duplicated write sample functions
      staging:iio:dac:ad5446: Fix 24bit transfers
      staging:iio:dac:ad5446: Remove unused struct field
      staging:iio:dac:ad5446: Do not check for individual chip ids in probe
      staging:iio:dac:ad5446: Remove duplicated chip_info entries
      staging:iio:dac:ad5446: Convert to extended channel attributes
      staging:iio:dac:ad5446: Consolidate store_sample and store_pwr_down functions
      staging:iio:dac:ad5446: Return cached value for 'raw' attribute
      staging:iio:dac:ad5446: Add support for the AD5662
      staging:iio:dac:ad5446: Update Kconfig entry
      staging:iio: Streamline API function naming
      MAINTAINERS: Add new Industrial I/O subsystem location
      staging:iio:dummy: Remove outdated comment
      iio: Add dev_to_iio_dev() helper function
      iio: Use dev_to_iio_dev()
      staging:iio:adis16203_read_ring_data: Pass IIO device directly
      staging:iio:adis16204_read_ring_data: Pass IIO device directly
      staging:iio:adis16209_read_ring_data: Pass IIO device directly
      staging:iio:adis16240_read_ring_data: Pass IIO device directly
      staging:iio:__lis3l02dq_write_data_ready_config: Pass IIO device directly
      staging:iio:adis16260_read_ring_data: Pass IIO device directly
      staging:iio:ade7758_spi_read_burst: Pass IIO device directly
      staging:iio:adis16400_ring: Pass IIO device directly
      staging:iio:adc: Use dev_to_iio_dev()
      staging:iio:accel: Use dev_to_iio_dev()
      staging:iio:addac: Use dev_to_iio_dev()
      staging:iio:cdc: Use dev_to_iio_dev()
      staging:iio:dac: Use dev_to_iio_dev()
      staging:iio:frequency: Use dev_to_iio_dev()
      staging:iio:gyro: Use dev_to_iio_dev()
      staging:iio:impedance-analyzer: Use dev_to_iio_dev()
      staging:iio:imu: Use dev_to_iio_dev()
      staging:iio:light: Use dev_to_iio_dev()
      staging:iio:magnetometer: Use dev_to_iio_dev()
      staging:iio:resolver: Use dev_to_iio_dev()
      staging:iio:meter: Use dev_to_iio_dev()

Laxman Dewangan (6):
      staging: iio: add channel info for sampling frequency
      staging: iio: add driver for isl29028
      staging: iio: light: isl29028: fix correct mask value
      staging: iio: light: convert multiple spaces to tab
      staging: iio: light: of: Fix vendor prefix of isl29018/isl29028
      staging: iio: light: isl29018: use regmap for register access

Marcos Paulo de Souza (5):
      drivers: staging: vme: devices: Remove unneeded include version.h
      drivers: staging: media: easycap: easycap_ioctl: Include version.h header
      drivers: staging: media: as102: as102_usb_drv.h: Remove include of version.h
      drivers: staging: media: as102: as102fe.c: Remove include of version.h
      drivers: staging: rtl8172: Remove unneeded include of version.h

Martyn Welch (4):
      Staging: VME: Convert TSI148 to use dma_map_single
      Staging: VME: Ensure TSI148 link list descriptors are written big endian
      VME: Move API documentation to Documentation folder
      MAINTAINERS: Add maintainers for VME subsystem

Masanari Iida (10):
      staging: Fix typo in wlags49_h2
      staging: Fix typo in multiple files
      staging: Fix typo within android drivers.
      staging, sep: Fix typo in sep
      staging,ozwpan: Fix typo in comments within staging/ozwpan
      staging: iio: Fix typo in iio
      staging: ramster: Fix typo in zcache-main.c
      staging: rts5139: Fix typo in rts5139
      staging: wlags49_h2: Fix spelling Endianess to Endianness in wlags49_h2
      staging: rtl8712: Fix typo in rtl871x_io.h

Max Tottenham (8):
      Staging: bcm: IPv6Protocol.c: Fix coding style
      Staging: bcm: IPv6Protocol.c coding style fix
      Staging: bcm: IPv6Protocol.c fix coding style
      Staging: bcm: IPv6Protocol.c coding style fix
      Staging: bcm: IPv6Protocol.c coding style fix
      Staging: bcm: IPv6Protocol.c coding style fix
      Staging: bcm: IPv6Protocol.c: coding style fix
      Staging: bcm: IPv6Protocol.c: coding style fix

Maxime Ripard (9):
      ARM: AT91: Add platform data for the AT91 ADCs
      ARM: AT91: IIO: Add AT91 ADC driver.
      ARM: AT91: Add the ADC to the sam9g20ek board
      ARM: AT91: ADC: Add support for the AT91SAM9M10G45-EK board
      ARM: AT91: Add the ADC clock to the sam9x5 SoC file
      IIO: AT91: Add DT support to at91_adc driver
      ARM: AT91: Add ADC driver to the at91sam9g45 dtsi
      ARM: AT91: Add ADC driver to the at91sam9x5 dtsi
      ARM: AT91: Add ADC driver to the at91sam9g20 dtsi

Michael Hennerich (8):
      iio: Rename iio/dds to iio/frequency
      iio: core: Introduce IIO_ALTVOLTAGE and appropriate channel info elements
      iio: frequency: Update DDS drivers to use new channel naming convention
      iio: core: iio_chan_spec_ext_info: Add private handle
      staging: iio: adc: convert ADI drivers to use kfifo.
      iio: core: introduce dB scle: IIO_VAL_INT_PLUS_MICRO_DB
      iio: core: introduce IIO_CHAN_INFO_HARDWAREGAIN
      iio: amplifiers: New driver for AD8366 Dual-Digital Variable Gain Amplifier

Minchan Kim (3):
      zsmalloc: use PageFlag macro instead of [set|test]_bit
      staging: zsmalloc: rename zspage_order with zspage_pages
      staging: zsmalloc: add/fix function comment

Oleg Nesterov (1):
      staging: usbip: fix the usage of kthread_stop()

Oleksij Rempel (34):
      staging: rts5139: remove useless functions in rts51x_card.c
      staging: rts5139: remove disabled code in rts51x_chip.c
      staging: rts5139: remove disable code in rts51x_transport.c
      staging: rts5139: remove disabled code in rts51x_scsi.c
      staging: rts5139: remove disabled code in rts51x_fop.*
      staging: rts5139: remove unused LED_AUTO_BLINK code
      staging: rts5139: remove disabled SUPPORT_SD_LOCK code.
      staging: rts5139: remove disabled XD_SPEEDUP code
      staging: rts5139: remove disabled SCSI_SCAN_DELAY code
      staging: rts5139: remove unused clear_first_install_mark
      staging: rts5139: remove useless rts51x_sys.h
      staging: rts5139: make some functions static in rts51x_card.c and rts51x.c
      staging: rts5139: remove unused disable_card_clock
      staging: rts5139: remove unused card_power_off
      staging: rts5139: make some functions static in rts51x_scsi.c
      staging: rts5139: remove unsued *host_info in rts51x_scsi.c
      staging: rts5139: make some functions static in rts51x_transport.*
      staging: rts5139: remove unused rts51x_reset_pipe in rts51x_transport.*
      staging: rts5139: remove soft_reset_sd_card in sd_cprm.c
      staging: rts5139: make some functions static in sd.*
      staging: rts5139: make some functions static in sd_cprm.c
      staging: rts5139: make some functions static in xd.c
      staging: rts5139: remove unused xd_check_err_code in xd.c
      staging: rts5139: make some functions static in ms.c and ms_mg.c
      staging: rts5139: remove disabled code in rts51x_card.c
      staging: rts5139: remove unused led_blink_speed variable
      staging: rts5139: remove unused option->needs_remote_wakeup
      staging: rts5139: remove unused rcc_fail_flag variable
      staging: rts5139: remove unused rcc_bug_fix_en
      staging: rts5139: remove unused polling_time variable
      staging: rts5139: remove unused TUNE_SD18_*
      staging: rts5139: remove unused variable in rts51x.h
      staging: rts5139: remove unused variable in rts51x_chip.h
      staging: rts5139: remove unused variable option.ww_enable

Paul Gortmaker (4):
      staging: evict abandoned 68360serial.c driver from the kernel
      staging: wean rtl8712 off of its ancient duplicate of if_ether.h
      staging: wean rtl8712 off of its ancient duplicate of ip.h
      staging: delete all duplicated endian crap from rtl8712 driver

Paul Stewart (1):
      staging: gdm72xx: Set up parent link in sysfs for gdm72xx devices

Peter Meerwald (10):
      staging: iio: call iio_device_unregister() in max517_remove()
      staging: iio: fix access to hmc5843 private data
      staging: iio: change strict_strtoul() to kstrtoul() in hmc5843
      staging: iio: rename and prefix CONSTANTs to distinguish between HMC5843 and HMC5883
      staging: iio: rework sampling rate setting in hmc5843
      staging: iio: add check for measurement configuration value passed to hmc5843
      staging: iio: cleanup and move comments in hmc5843
      staging: iio: rename function/data to consistently start with hmc5843_
      staging: iio: reorganize hmc5843_set_rate()
      staging: iio: add support for hmc5883/hmc5883l to hmc5843 magnetometer driver

Randy Dunlap (4):
      staging: fix android persistent_ram printk formats
      staging: fix android alarm.c printk format warnings
      ramoops: fix printk format warnings
      staging: gdm72xx depends on NET

Ravishankar Karkala Mallikarjunayya (9):
      Staging: comedi: fix line over 80 character issue in cb_pcidda.c
      Staging: comedi: fix line over 80 character issue in daqboard2000.c
      Staging: comedi: fix line over 80 character issue in cb_pcimdas.c.
      Staging: comedi: fix line over 80 character issue in ni_at_a2150.c
      Staging: comedi: fix line over 80 character issue in usbduxfast.c
      Staging: comedi: fix printk issue in pcmmio.c
      Staging: comedi: fix line indentation issue in dt9812.c
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: fix line over 80 character issue in rtd520.c

Rob Clark (4):
      staging: omap/drm: dmm should return proper errors
      staging: drm/omap: dmabuf/prime support
      staging: drm/omap: dmabuf/prime mmap support
      staging: drm/omap: initial dmabuf/prime import support

Roland Stigge (2):
      iio: Add device tree support to LPC32xx ADC
      staging: iio: lpc32xx-adc: Remove driver conflict due to device tree

Rupesh Gujare (2):
      staging: ozwpan: Replace existing event logging mechanism
      staging: ozwpan: Fix bug where kfree is called twice.

Sage Ahn (1):
      staging: gdm72xx: Add GCT GDM72xx WiMAX driver.

Samuel Iglesias Gonsalvez (15):
      Staging: IndustryPack bus for the Linux Kernel
      Staging: ipack: added support for the TEWS TPCI-200 carrier board
      Staging: ipack: add support for IP-OCTAL mezzanine board
      Staging: move the position of the ipack source line in Kconfig
      Staging: ipack: move the devices source line in Kconfig file
      Staging: ipack: add contact email in TODO file
      Staging: ipack: change the licence to explicitly GPLv2
      Staging: ipack/bridges/tpci200: change the licence to explicitly GPLv2
      Staging: ipack/devices/ipoctal: change the licence to explicitly GPLv2
      Staging: ipack: added more info in Kconfig's help about ipack
      Staging: ipack: fix a few sparse warnings
      Staging: ipack: improve the register of a bus and a device in the bus.
      Staging: ipack: remove board_name and bus_name fields from struct ipack_device
      Staging: ipack/bridges/tpci200: remove TPCI200_SHORTNAME constant
      Staging: ipack/bridges/tpci200: remove unneeded casts

Santosh Nayak (2):
      staging: wlags49_h2: Replace kmalloc+memset by kzalloc and add error handling.
      Staging: vme: Replace semaphore by mutex.

Sasha Levin (1):
      staging: ramster: depend on NET for sock_* functions

Stefan Roese (1):
      staging:iio:adc: Add SPEAr ADC driver

Tim Bird (2):
      staging: android: logger: Allocate logs dynamically at boot (v3)
      staging: android: logger: Fix some sparse and whitespace issues

Tomas Melin (6):
      Staging: Comedi adv_pci1710 : Corrected over 80 column warnings
      Staging: Comedi adv_pci1710 : Corrected over 80 column warnings
      Staging: Comedi adv_pci1710: Move check forward
      Staging: Comedi adv_pci1710: Cleaned up comments
      Staging: Comedi adv_pci1710: Combined two conditions
      Staging: Comedi adv_pci1710: Fixed indentation

Tomas Winkler (16):
      staging/mei: define pr_fmt prefix for pr_ macros
      staging/mei: mei_wd_set_start_timeout should be static
      staging/mei: use dev_err instead of printk
      staging/mei: remove unused variable
      staging/mei: struct amt_wd_dev' should it be static
      staging/mei: cleanup driver naming strings
      staging/mei: refactor mei_wd_host_init function
      staging/mei: wd.c normalize debug and error messages
      mei: use pr_err instead of printk(KERN_ERR
      mei: pci_probe/remove: use dev_err instead of printk(KERN_ERR
      uuid: add uuid.h to exported header list
      mei: export mei.h for the user space
      mei: move doc files Documentation/misc-devices/mei
      mei: update Documentation/ioctl/ioctl-number.txt
      mei: update MAINTAINERS file
      mei: Documentation: add generated example binary into .gitignore file

W. Trevor King (3):
      staging: comedi: COMEDI_CB_EOA is also used to report end-of-output.
      staging: comedi: ni_tio_internal.h: checkpatch.pl line wrapping
      staging: comedi: ni_tio_internal.h: checkpatch.pl cleanups

joseph daniel (1):
      staging: et131x: Fix coding style issues

wwang (1):
      staging:rts_pstor:Fix unbalanced parentheses

