Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0HEVfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:35:37 -0400
Received: from kroah.org ([198.145.64.141]:40167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0HEVfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:35:33 -0400
Date: Thu, 5 Aug 2010 14:33:08 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING merge for .36
Message-ID: <20100805213308.GA13744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big staging tree merge for the .36 kernel.

There is one patch in here that is outside of the drivers/staging/
subdirectory, it exports a symbol so that the hyperv drivers will work
properly.  That patch was acked by the x86 maintainers and asked that it
go through this tree due to the dependancies.

We added a number of new drivers in this merge:
	- ti dsp bridge driver
	- spectra flash driver
	- solo6x10 MPEG-4 codec card driver
	- easycap USB audio driver
and deleted one driver, dt3155, as there is a duplicate driver for it
already in the tree, that used the proper v4l api interfaces.

Overall we still grew, mostly due to the tidsp driver which just
overshadowed everything else due to its immense size:
	 812 files changed, 106306 insertions(+), 33784 deletions(-)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 arch/x86/kernel/cpu/mshyperv.c                     |    1 +
 drivers/staging/Kconfig                            |   14 +-
 drivers/staging/Makefile                           |    8 +-
 drivers/staging/adis16255/adis16255.c              |    4 +-
 drivers/staging/batman-adv/CHANGELOG               |   12 +
 drivers/staging/batman-adv/Kconfig                 |    2 +-
 drivers/staging/batman-adv/Makefile                |    4 +-
 drivers/staging/batman-adv/README                  |    2 +-
 drivers/staging/batman-adv/TODO                    |    9 +-
 drivers/staging/batman-adv/aggregation.c           |    9 +-
 drivers/staging/batman-adv/aggregation.h           |    5 +
 drivers/staging/batman-adv/bat_debugfs.c           |  341 ++
 drivers/staging/batman-adv/bat_debugfs.h           |   33 +
 drivers/staging/batman-adv/bat_sysfs.c             |  300 +-
 drivers/staging/batman-adv/bat_sysfs.h             |   13 +
 drivers/staging/batman-adv/bitarray.c              |   17 +-
 drivers/staging/batman-adv/bitarray.h              |   13 +-
 drivers/staging/batman-adv/device.c                |  354 --
 drivers/staging/batman-adv/hard-interface.c        |   71 +-
 drivers/staging/batman-adv/hard-interface.h        |    5 +
 drivers/staging/batman-adv/hash.c                  |    2 +-
 drivers/staging/batman-adv/hash.h                  |   12 +-
 drivers/staging/batman-adv/icmp_socket.c           |  334 ++
 .../staging/batman-adv/{device.h => icmp_socket.h} |   24 +-
 drivers/staging/batman-adv/main.c                  |   62 +-
 drivers/staging/batman-adv/main.h                  |   82 +-
 drivers/staging/batman-adv/originator.c            |  156 +-
 drivers/staging/batman-adv/originator.h            |   10 +-
 drivers/staging/batman-adv/packet.h                |   32 +-
 drivers/staging/batman-adv/ring_buffer.h           |    5 +
 drivers/staging/batman-adv/routing.c               |  406 ++-
 drivers/staging/batman-adv/routing.h               |   13 +-
 drivers/staging/batman-adv/send.c                  |   81 +-
 drivers/staging/batman-adv/send.h                  |    7 +-
 drivers/staging/batman-adv/soft-interface.c        |  165 +-
 drivers/staging/batman-adv/soft-interface.h        |   13 +-
 .../staging/batman-adv/sysfs-class-net-batman-adv  |   14 +
 drivers/staging/batman-adv/sysfs-class-net-mesh    |   33 +
 drivers/staging/batman-adv/translation-table.c     |  171 +-
 drivers/staging/batman-adv/translation-table.h     |   14 +-
 drivers/staging/batman-adv/types.h                 |   43 +-
 drivers/staging/batman-adv/vis.c                   |  147 +-
 drivers/staging/batman-adv/vis.h                   |   13 +-
 drivers/staging/comedi/TODO                        |    1 -
 drivers/staging/comedi/comedi_fops.c               |   11 +-
 drivers/staging/comedi/comedidev.h                 |   58 +-
 drivers/staging/comedi/drivers/8255.c              |   17 +-
 drivers/staging/comedi/drivers/acl7225b.c          |   17 +-
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    6 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   38 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |   12 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    8 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |    4 +
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_1564.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_2016.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_3001.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    4 +
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |    4 +
 drivers/staging/comedi/drivers/adl_pci6208.c       |   48 +-
 drivers/staging/comedi/drivers/adl_pci7230.c       |   51 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |   51 +-
 drivers/staging/comedi/drivers/adl_pci7432.c       |   51 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |   51 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  213 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   42 +-
 drivers/staging/comedi/drivers/adq12b.c            |   17 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |   89 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   42 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  355 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   17 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |   17 +-
 drivers/staging/comedi/drivers/am9513.h            |   22 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |   57 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |   57 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   57 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   44 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   50 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |   17 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |   16 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   48 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   48 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |   48 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |   46 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   50 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   46 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |   37 -
 drivers/staging/comedi/drivers/comedi_parport.c    |   17 +-
 drivers/staging/comedi/drivers/comedi_test.c       |   17 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   49 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   44 +-
 drivers/staging/comedi/drivers/das08.c             |   71 +-
 drivers/staging/comedi/drivers/das08_cs.c          |    3 +-
 drivers/staging/comedi/drivers/das16.c             |   17 +-
 drivers/staging/comedi/drivers/das16m1.c           |   17 +-
 drivers/staging/comedi/drivers/das1800.c           |   17 +-
 drivers/staging/comedi/drivers/das6402.c           |   17 +-
 drivers/staging/comedi/drivers/das800.c            |   17 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   99 +-
 drivers/staging/comedi/drivers/dt2801.c            |   17 +-
 drivers/staging/comedi/drivers/dt2811.c            |   17 +-
 drivers/staging/comedi/drivers/dt2814.c            |   17 +-
 drivers/staging/comedi/drivers/dt2815.c            |   17 +-
 drivers/staging/comedi/drivers/dt2817.c            |   17 +-
 drivers/staging/comedi/drivers/dt282x.c            |   17 +-
 drivers/staging/comedi/drivers/dt3000.c            |   42 +-
 drivers/staging/comedi/drivers/dt9812.c            |    6 +-
 drivers/staging/comedi/drivers/fl512.c             |   17 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   72 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   17 +-
 drivers/staging/comedi/drivers/icp_multi.h         |    6 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   17 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |   69 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   48 +-
 drivers/staging/comedi/drivers/me4000.c            |  464 ++-
 drivers/staging/comedi/drivers/me_daq.c            |   48 +-
 drivers/staging/comedi/drivers/mite.c              |   10 +-
 drivers/staging/comedi/drivers/mpc624.c            |   17 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |   13 +-
 drivers/staging/comedi/drivers/multiq3.c           |   17 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   38 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |   38 +-
 drivers/staging/comedi/drivers/ni_660x.c           |   40 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   38 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   17 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |   17 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |   13 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   17 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |    3 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    3 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |  121 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   38 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   38 +-
 drivers/staging/comedi/drivers/ni_tio.c            |   54 +-
 drivers/staging/comedi/drivers/pcl711.c            |   31 +-
 drivers/staging/comedi/drivers/pcl724.c            |   17 +-
 drivers/staging/comedi/drivers/pcl725.c            |   17 +-
 drivers/staging/comedi/drivers/pcl726.c            |   17 +-
 drivers/staging/comedi/drivers/pcl730.c            |   17 +-
 drivers/staging/comedi/drivers/pcl812.c            |  493 ++-
 drivers/staging/comedi/drivers/pcl816.c            |  240 +-
 drivers/staging/comedi/drivers/pcl818.c            |   17 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   19 +-
 drivers/staging/comedi/drivers/pcm3730.c           |   17 +-
 drivers/staging/comedi/drivers/pcm_common.c        |    4 +
 drivers/staging/comedi/drivers/pcmad.c             |   17 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   29 +-
 drivers/staging/comedi/drivers/pcmmio.c            |   34 +-
 drivers/staging/comedi/drivers/pcmuio.c            |   17 +-
 drivers/staging/comedi/drivers/poc.c               |   17 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   58 +-
 drivers/staging/comedi/drivers/rtd520.c            |   42 +-
 drivers/staging/comedi/drivers/rti800.c            |   17 +-
 drivers/staging/comedi/drivers/rti802.c            |   17 +-
 drivers/staging/comedi/drivers/s526.c              |   17 +-
 drivers/staging/comedi/drivers/s626.c              |  163 +-
 drivers/staging/comedi/drivers/s626.h              |    9 -
 drivers/staging/comedi/drivers/serial2002.c        |  115 +-
 drivers/staging/comedi/drivers/skel.c              |  109 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   17 +-
 drivers/staging/comedi/drivers/unioxx5.c           |   26 +-
 drivers/staging/comedi/drivers/usbdux.c            |    4 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    4 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |   22 +-
 drivers/staging/cx25821/cx25821-alsa.c             |    2 +-
 drivers/staging/cxt1e1/functions.c                 |   12 -
 drivers/staging/cxt1e1/hwprobe.c                   |    6 -
 drivers/staging/cxt1e1/linux.c                     |  163 -
 drivers/staging/cxt1e1/musycc.c                    |  204 -
 drivers/staging/cxt1e1/pmc93x6_eeprom.c            |    4 -
 drivers/staging/cxt1e1/pmcc4.h                     |    4 -
 drivers/staging/cxt1e1/pmcc4_drv.c                 |  158 -
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |   11 -
 drivers/staging/dream/camera/msm_vfe8x.c           |   45 +-
 drivers/staging/dream/pmem.c                       |   46 +-
 drivers/staging/dt3155/Kconfig                     |    4 -
 drivers/staging/dt3155/Makefile                    |    6 -
 drivers/staging/dt3155/TODO                        |   10 -
 drivers/staging/dt3155/allocator.README            |   98 -
 drivers/staging/dt3155/allocator.c                 |  294 --
 drivers/staging/dt3155/allocator.h                 |   28 -
 drivers/staging/dt3155/dt3155.h                    |  161 -
 drivers/staging/dt3155/dt3155.sysvinit             |   60 -
 drivers/staging/dt3155/dt3155_drv.c                | 1099 -----
 drivers/staging/dt3155/dt3155_drv.h                |   45 -
 drivers/staging/dt3155/dt3155_io.c                 |  165 -
 drivers/staging/dt3155/dt3155_io.h                 |  358 --
 drivers/staging/dt3155/dt3155_isr.c                |  509 ---
 drivers/staging/dt3155/dt3155_isr.h                |   77 -
 drivers/staging/dt3155v4l/dt3155v4l.c              |   31 +-
 drivers/staging/easycap/Kconfig                    |   17 +
 drivers/staging/easycap/Makefile                   |   13 +
 drivers/staging/easycap/README                     |  130 +
 drivers/staging/easycap/easycap.h                  |  642 +++
 drivers/staging/easycap/easycap_debug.h            |   27 +
 drivers/staging/easycap/easycap_ioctl.c            | 2687 +++++++++++
 drivers/staging/easycap/easycap_ioctl.h            |   28 +
 drivers/staging/easycap/easycap_low.c              | 1041 +++++
 drivers/staging/easycap/easycap_main.c             | 4354 ++++++++++++++++++
 drivers/staging/easycap/easycap_settings.c         |  489 ++
 drivers/staging/easycap/easycap_sound.c            | 1046 +++++
 drivers/staging/easycap/easycap_sound.h            |   28 +
 drivers/staging/easycap/easycap_standard.h         |   27 +
 drivers/staging/easycap/easycap_testcard.c         |  392 ++
 drivers/staging/et131x/et1310_phy.c                |    8 +-
 drivers/staging/hv/Kconfig                         |    2 +-
 drivers/staging/hv/Makefile                        |    2 +-
 drivers/staging/hv/blkvsc.c                        |   12 +-
 drivers/staging/hv/blkvsc_drv.c                    |   26 +-
 drivers/staging/hv/channel.c                       |   54 +-
 drivers/staging/hv/channel_mgmt.c                  |   43 -
 drivers/staging/hv/channel_mgmt.h                  |    8 +-
 drivers/staging/hv/connection.c                    |   23 +-
 drivers/staging/hv/hv.c                            |   29 +-
 drivers/staging/hv/hv_timesource.c                 |  101 +
 drivers/staging/hv/hv_utils.c                      |   12 -
 drivers/staging/hv/logging.h                       |   17 -
 drivers/staging/hv/netvsc.c                        |   65 -
 drivers/staging/hv/netvsc_drv.c                    |   51 +-
 drivers/staging/hv/ring_buffer.c                   |   71 +-
 drivers/staging/hv/ring_buffer.h                   |   35 +-
 drivers/staging/hv/rndis_filter.c                  |   86 +-
 drivers/staging/hv/storvsc.c                       |   36 -
 drivers/staging/hv/storvsc_drv.c                   |   49 +-
 drivers/staging/hv/vmbus.c                         |   18 -
 drivers/staging/hv/vmbus_drv.c                     |   99 +-
 drivers/staging/iio/Documentation/overview.txt     |    2 +-
 drivers/staging/iio/Kconfig                        |    2 +
 drivers/staging/iio/Makefile                       |    4 +-
 drivers/staging/iio/TODO                           |    2 +-
 drivers/staging/iio/accel/Kconfig                  |   50 +-
 drivers/staging/iio/accel/Makefile                 |    3 +-
 drivers/staging/iio/accel/adis16209.h              |   33 +-
 drivers/staging/iio/accel/adis16209_core.c         |   15 +-
 drivers/staging/iio/accel/adis16209_ring.c         |   94 +-
 drivers/staging/iio/accel/adis16209_trigger.c      |   10 +-
 drivers/staging/iio/accel/adis16220.h              |    1 -
 drivers/staging/iio/accel/adis16220_core.c         |   20 +-
 drivers/staging/iio/accel/adis16240.h              |   27 +-
 drivers/staging/iio/accel/adis16240_core.c         |   17 +-
 drivers/staging/iio/accel/adis16240_ring.c         |   91 +-
 drivers/staging/iio/accel/adis16240_trigger.c      |   10 +-
 drivers/staging/iio/accel/kxsd9.c                  |    6 -
 drivers/staging/iio/accel/lis3l02dq.h              |   35 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |  144 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |  210 +-
 drivers/staging/iio/accel/sca3000.h                |   14 +-
 drivers/staging/iio/accel/sca3000_core.c           |   14 +-
 drivers/staging/iio/adc/Makefile                   |    2 +-
 drivers/staging/iio/adc/adc.h                      |    3 +
 drivers/staging/iio/adc/max1363.h                  |   69 +-
 drivers/staging/iio/adc/max1363_core.c             |  861 ++++-
 drivers/staging/iio/adc/max1363_ring.c             |   60 +-
 drivers/staging/iio/chrdev.h                       |    3 -
 drivers/staging/iio/gyro/Makefile                  |    2 +-
 drivers/staging/iio/gyro/adis16260.h               |   25 +-
 drivers/staging/iio/gyro/adis16260_core.c          |   12 +-
 drivers/staging/iio/gyro/adis16260_ring.c          |   92 +-
 drivers/staging/iio/gyro/adis16260_trigger.c       |   10 +-
 drivers/staging/iio/iio.h                          |   51 +-
 drivers/staging/iio/imu/Kconfig                    |   18 +-
 drivers/staging/iio/imu/Makefile                   |    3 +-
 drivers/staging/iio/imu/adis16300.h                |   28 +-
 drivers/staging/iio/imu/adis16300_core.c           |  160 +-
 drivers/staging/iio/imu/adis16300_ring.c           |  142 +-
 drivers/staging/iio/imu/adis16300_trigger.c        |   10 +-
 drivers/staging/iio/imu/adis16350.h                |   40 +-
 drivers/staging/iio/imu/adis16350_core.c           |   17 +-
 drivers/staging/iio/imu/adis16350_ring.c           |   91 +-
 drivers/staging/iio/imu/adis16350_trigger.c        |   10 +-
 drivers/staging/iio/imu/adis16400.h                |   45 +-
 drivers/staging/iio/imu/adis16400_core.c           |  101 +-
 drivers/staging/iio/imu/adis16400_ring.c           |  137 +-
 drivers/staging/iio/imu/adis16400_trigger.c        |   10 +-
 drivers/staging/iio/industrialio-core.c            |   22 +-
 drivers/staging/iio/industrialio-ring.c            |    4 +-
 drivers/staging/iio/industrialio-trigger.c         |   51 +-
 drivers/staging/iio/light/Kconfig                  |    1 -
 drivers/staging/iio/light/light.h                  |    7 +-
 drivers/staging/iio/light/tsl2563.c                |  389 ++-
 drivers/staging/iio/magnetometer/Kconfig           |   15 +
 drivers/staging/iio/magnetometer/Makefile          |    5 +
 drivers/staging/iio/magnetometer/hmc5843.c         |  624 +++
 drivers/staging/iio/ring_generic.h                 |   23 +-
 drivers/staging/iio/ring_sw.c                      |   69 +
 drivers/staging/iio/ring_sw.h                      |   15 +-
 drivers/staging/iio/sysfs.h                        |   14 +-
 drivers/staging/iio/trigger.h                      |   24 +-
 drivers/staging/iio/trigger/Makefile               |    3 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |   12 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   15 +-
 drivers/staging/line6/Kconfig                      |    1 +
 drivers/staging/line6/driver.c                     |   68 +-
 drivers/staging/memrar/TODO                        |    2 +-
 drivers/staging/memrar/memrar-abi                  |    4 +-
 drivers/staging/memrar/memrar_handler.c            |   37 +-
 drivers/staging/msm/Kconfig                        |   10 -
 drivers/staging/msm/Makefile                       |    5 -
 drivers/staging/msm/lcdc_grapefruit.c              |   60 -
 drivers/staging/msm/lcdc_st1_wxga.c                |   54 -
 drivers/staging/msm/lcdc_wxga.c                    |   56 -
 drivers/staging/msm/mddi_toshiba_wvga.c            |   63 -
 drivers/staging/msm/mddihost.h                     |    2 -
 drivers/staging/msm/mdp4_debugfs.c                 |   10 +-
 drivers/staging/msm/mdp4_overlay.c                 |    8 +-
 drivers/staging/msm/msm_fb_def.h                   |    4 -
 drivers/staging/msm/staging-devices.c              |   13 +-
 drivers/staging/octeon/cvmx-cmd-queue.c            |    6 +-
 drivers/staging/octeon/cvmx-fau.h                  |    2 +-
 drivers/staging/octeon/ethernet-spi.c              |    2 +
 drivers/staging/otus/80211core/ctxrx.c             |    2 +-
 drivers/staging/otus/TODO                          |   16 +-
 drivers/staging/otus/apdbg.c                       |   24 +-
 drivers/staging/otus/hal/hpani.c                   |   16 +-
 drivers/staging/otus/hal/hpmain.c                  |   28 +-
 drivers/staging/otus/hal/hpreg.c                   |   17 +-
 drivers/staging/otus/ioctl.c                       |   55 +-
 drivers/staging/otus/wrap_sec.c                    |    2 +-
 drivers/staging/otus/wrap_usb.c                    |    5 +
 drivers/staging/otus/wwrap.c                       |  968 ++---
 drivers/staging/otus/zdusb.c                       |  251 +-
 drivers/staging/panel/panel.c                      | 1071 +++--
 drivers/staging/pohmelfs/inode.c                   |    6 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |   24 +-
 drivers/staging/quickstart/Kconfig                 |   10 +
 drivers/staging/quickstart/Makefile                |    1 +
 drivers/staging/quickstart/quickstart.c            |  474 ++
 drivers/staging/ramzswap/Kconfig                   |   21 -
 drivers/staging/ramzswap/Makefile                  |    3 -
 drivers/staging/ramzswap/ramzswap.txt              |   51 -
 drivers/staging/ramzswap/ramzswap_drv.c            |  837 ----
 drivers/staging/rt2860/ap.h                        |    6 +-
 drivers/staging/rt2860/chlist.h                    |   50 +-
 drivers/staging/rt2860/common/cmm_wpa.c            |    4 +-
 drivers/staging/rt2860/common/rtmp_timer.c         |    4 +-
 drivers/staging/rt2860/mlme.h                      |   21 +-
 drivers/staging/rt2860/rt_linux.c                  |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    4 +-
 drivers/staging/rt2860/usb_main_dev.c              |    9 +-
 drivers/staging/rt3070/md4.h                       |   42 -
 drivers/staging/rtl8187se/Kconfig                  |    1 +
 drivers/staging/rtl8192e/Kconfig                   |    1 +
 drivers/staging/rtl8192e/ieee80211/dot11d.c        |   18 -
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |   97 +-
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |   20 -
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.h   |    8 -
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |   48 -
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |  198 +-
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |   96 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |   68 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |   16 -
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |  185 +-
 .../rtl8192e/ieee80211/ieee80211_softmac_wx.c      |   73 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    9 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |  132 +-
 .../staging/rtl8192e/ieee80211/rtl819x_HTProc.c    |   17 -
 drivers/staging/rtl8192e/r8190_rtl8256.c           |    6 +-
 drivers/staging/rtl8192e/r8192E.h                  |    4 +-
 drivers/staging/rtl8192e/r8192E_core.c             |   69 +-
 drivers/staging/rtl8192e/r8192E_dm.c               |   22 +-
 drivers/staging/rtl8192e/r8192E_wx.c               |  157 +-
 drivers/staging/rtl8192e/r819xE_phy.c              |    2 +-
 drivers/staging/rtl8192su/Kconfig                  |    1 +
 drivers/staging/rtl8192su/TODO                     |    7 +-
 drivers/staging/rtl8192su/ieee80211/dot11d.c       |   28 +-
 drivers/staging/rtl8192su/ieee80211/dot11d.h       |   25 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |   32 +-
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.c  |    5 +-
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.h  |    2 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_ccmp.c     |    7 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_tkip.c     |   31 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_wep.c      |    6 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |   26 +-
 .../staging/rtl8192su/ieee80211/ieee80211_r8192s.h |   43 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |  290 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |   11 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |   17 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_BA.h   |   30 +-
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |   50 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h   |   42 +-
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   |  147 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h  |   88 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_TS.h   |   23 +-
 .../staging/rtl8192su/ieee80211/rtl819x_TSProc.c   |   41 +-
 drivers/staging/rtl8192su/r8192SU_HWImg.c          |   37 +-
 drivers/staging/rtl8192su/r8192SU_HWImg.h          |   22 +-
 drivers/staging/rtl8192su/r8192SU_led.c            |    9 -
 drivers/staging/rtl8192su/r8192S_Efuse.c           |  510 +--
 drivers/staging/rtl8192su/r8192S_Efuse.h           |   70 +-
 drivers/staging/rtl8192su/r8192S_firmware.c        |   26 +-
 drivers/staging/rtl8192su/r8192S_firmware.h        |  100 +-
 drivers/staging/rtl8192su/r8192S_hw.h              |  152 +-
 drivers/staging/rtl8192su/r8192S_phy.c             |  659 +---
 drivers/staging/rtl8192su/r8192U.h                 |  309 +-
 drivers/staging/rtl8192su/r8192U_core.c            |  169 +-
 drivers/staging/rtl8192su/r8192U_dm.c              |   29 +-
 drivers/staging/rtl8192su/r8192U_wx.c              |  128 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |   44 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.h          |    1 +
 drivers/staging/rtl8192u/Kconfig                   |    1 +
 drivers/staging/rtl8192u/dot11d.h                  |    2 +-
 drivers/staging/rtl8192u/ieee80211.h               | 2595 -----------
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    2 +-
 drivers/staging/rtl8192u/r8192U.h                  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   73 +-
 drivers/staging/rtl8192u/r8192U_wx.h               |    2 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |    2 +-
 drivers/staging/sep/sep_driver_api.h               |    2 +-
 drivers/staging/slicoss/slic.h                     |   12 -
 drivers/staging/slicoss/slicoss.c                  | 3952 ++++++++---------
 drivers/staging/sm7xx/smtcfb.c                     |    2 +-
 drivers/staging/solo6x10/Kconfig                   |    7 +
 drivers/staging/solo6x10/Makefile                  |    6 +
 drivers/staging/solo6x10/TODO                      |   28 +
 drivers/staging/solo6x10/solo6010-core.c           |  282 ++
 drivers/staging/solo6x10/solo6010-disp.c           |  271 ++
 drivers/staging/solo6x10/solo6010-enc.c            |  229 +
 drivers/staging/solo6x10/solo6010-g723.c           |  398 ++
 drivers/staging/solo6x10/solo6010-gpio.c           |  103 +
 drivers/staging/solo6x10/solo6010-i2c.c            |  331 ++
 drivers/staging/solo6x10/solo6010-jpeg.h           |  105 +
 drivers/staging/solo6x10/solo6010-offsets.h        |   78 +
 drivers/staging/solo6x10/solo6010-osd-font.h       |  154 +
 drivers/staging/solo6x10/solo6010-p2m.c            |  208 +
 drivers/staging/solo6x10/solo6010-registers.h      |  657 +++
 drivers/staging/solo6x10/solo6010-tw28.c           |  823 ++++
 drivers/staging/solo6x10/solo6010-tw28.h           |   65 +
 drivers/staging/solo6x10/solo6010-v4l2-enc.c       | 1564 +++++++
 drivers/staging/solo6x10/solo6010-v4l2.c           |  859 ++++
 drivers/staging/solo6x10/solo6010.h                |  317 ++
 drivers/staging/spectra/Kconfig                    |   40 +
 drivers/staging/spectra/Makefile                   |   11 +
 drivers/staging/spectra/README                     |   29 +
 drivers/staging/spectra/ffsdefs.h                  |   58 +
 drivers/staging/spectra/ffsport.c                  |  827 ++++
 drivers/staging/spectra/ffsport.h                  |   84 +
 drivers/staging/spectra/flash.c                    | 4731 ++++++++++++++++++++
 drivers/staging/spectra/flash.h                    |  198 +
 drivers/staging/spectra/lld.c                      |  339 ++
 drivers/staging/spectra/lld.h                      |  111 +
 drivers/staging/spectra/lld_cdma.c                 |  910 ++++
 drivers/staging/spectra/lld_cdma.h                 |  123 +
 drivers/staging/spectra/lld_emu.c                  |  780 ++++
 drivers/staging/spectra/lld_emu.h                  |   51 +
 drivers/staging/spectra/lld_mtd.c                  |  687 +++
 drivers/staging/spectra/lld_mtd.h                  |   51 +
 drivers/staging/spectra/lld_nand.c                 | 2601 +++++++++++
 drivers/staging/spectra/lld_nand.h                 |  131 +
 drivers/staging/spectra/nand_regs.h                |  619 +++
 drivers/staging/spectra/spectraswconfig.h          |   82 +
 drivers/staging/ti-st/Kconfig                      |    2 +-
 drivers/staging/ti-st/TODO                         |   13 +-
 drivers/staging/ti-st/bt_drv.c                     |   29 +-
 drivers/staging/ti-st/st.h                         |   66 +-
 drivers/staging/ti-st/st_core.c                    |  202 +-
 drivers/staging/ti-st/st_core.h                    |   74 +-
 drivers/staging/ti-st/st_kim.c                     |  347 +-
 drivers/staging/ti-st/st_kim.h                     |   94 +-
 drivers/staging/ti-st/st_ll.c                      |    8 +-
 drivers/staging/ti-st/st_ll.h                      |    9 +-
 drivers/staging/ti-st/sysfs-uim                    |   12 +
 .../staging/tidspbridge/Documentation/CONTRIBUTORS |   45 +
 drivers/staging/tidspbridge/Documentation/README   |   70 +
 .../staging/tidspbridge/Documentation/error-codes  |  157 +
 drivers/staging/tidspbridge/Kconfig                |   90 +
 drivers/staging/tidspbridge/Makefile               |   34 +
 drivers/staging/tidspbridge/TODO                   |   18 +
 drivers/staging/tidspbridge/core/_cmm.h            |   45 +
 drivers/staging/tidspbridge/core/_deh.h            |   35 +
 drivers/staging/tidspbridge/core/_msg_sm.h         |  142 +
 drivers/staging/tidspbridge/core/_tiomap.h         |  371 ++
 drivers/staging/tidspbridge/core/_tiomap_pwr.h     |   85 +
 drivers/staging/tidspbridge/core/chnl_sm.c         | 1014 +++++
 drivers/staging/tidspbridge/core/dsp-clock.c       |  422 ++
 drivers/staging/tidspbridge/core/io_sm.c           | 2333 ++++++++++
 drivers/staging/tidspbridge/core/msg_sm.c          |  673 +++
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1802 ++++++++
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |  550 +++
 drivers/staging/tidspbridge/core/tiomap_io.c       |  455 ++
 drivers/staging/tidspbridge/core/tiomap_io.h       |  104 +
 drivers/staging/tidspbridge/core/ue_deh.c          |  273 ++
 drivers/staging/tidspbridge/core/wdt.c             |  150 +
 drivers/staging/tidspbridge/dynload/cload.c        | 1953 ++++++++
 .../staging/tidspbridge/dynload/dload_internal.h   |  344 ++
 drivers/staging/tidspbridge/dynload/doff.h         |  354 ++
 drivers/staging/tidspbridge/dynload/getsection.c   |  407 ++
 drivers/staging/tidspbridge/dynload/header.h       |   49 +
 drivers/staging/tidspbridge/dynload/module_list.h  |  159 +
 drivers/staging/tidspbridge/dynload/params.h       |  226 +
 drivers/staging/tidspbridge/dynload/reloc.c        |  484 ++
 drivers/staging/tidspbridge/dynload/reloc_table.h  |  102 +
 .../tidspbridge/dynload/reloc_table_c6000.c        |  257 ++
 drivers/staging/tidspbridge/dynload/tramp.c        | 1143 +++++
 .../tidspbridge/dynload/tramp_table_c6000.c        |  164 +
 drivers/staging/tidspbridge/gen/gb.c               |  167 +
 drivers/staging/tidspbridge/gen/gh.c               |  215 +
 drivers/staging/tidspbridge/gen/gs.c               |   89 +
 drivers/staging/tidspbridge/gen/uuidutil.c         |  113 +
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 +
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 +
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 +
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 +
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 +++
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 +
 .../tidspbridge/include/dspbridge/_chnl_sm.h       |  181 +
 .../tidspbridge/include/dspbridge/brddefs.h        |   39 +
 .../staging/tidspbridge/include/dspbridge/cfg.h    |  222 +
 .../tidspbridge/include/dspbridge/cfgdefs.h        |   81 +
 .../staging/tidspbridge/include/dspbridge/chnl.h   |  130 +
 .../tidspbridge/include/dspbridge/chnldefs.h       |   66 +
 .../tidspbridge/include/dspbridge/chnlpriv.h       |   98 +
 .../staging/tidspbridge/include/dspbridge/clk.h    |  101 +
 .../staging/tidspbridge/include/dspbridge/cmm.h    |  386 ++
 .../tidspbridge/include/dspbridge/cmmdefs.h        |  105 +
 .../staging/tidspbridge/include/dspbridge/cod.h    |  369 ++
 .../staging/tidspbridge/include/dspbridge/dbc.h    |   46 +
 .../staging/tidspbridge/include/dspbridge/dbdcd.h  |  358 ++
 .../tidspbridge/include/dspbridge/dbdcddef.h       |   78 +
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |  514 +++
 .../tidspbridge/include/dspbridge/dbldefs.h        |  141 +
 .../staging/tidspbridge/include/dspbridge/dbll.h   |   62 +
 .../tidspbridge/include/dspbridge/dblldefs.h       |  496 ++
 .../tidspbridge/include/dspbridge/dehdefs.h        |   32 +
 .../staging/tidspbridge/include/dspbridge/dev.h    |  702 +++
 .../tidspbridge/include/dspbridge/devdefs.h        |   26 +
 .../staging/tidspbridge/include/dspbridge/disp.h   |  204 +
 .../tidspbridge/include/dspbridge/dispdefs.h       |   35 +
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 +
 .../staging/tidspbridge/include/dspbridge/drv.h    |  521 +++
 .../tidspbridge/include/dspbridge/drvdefs.h        |   25 +
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |  475 ++
 .../staging/tidspbridge/include/dspbridge/dspapi.h |  167 +
 .../tidspbridge/include/dspbridge/dspchnl.h        |   72 +
 .../tidspbridge/include/dspbridge/dspdefs.h        | 1054 +++++
 .../staging/tidspbridge/include/dspbridge/dspdeh.h |   43 +
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |   62 +
 .../staging/tidspbridge/include/dspbridge/dspio.h  |   41 +
 .../tidspbridge/include/dspbridge/dspioctl.h       |   73 +
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |   56 +
 .../tidspbridge/include/dspbridge/dynamic_loader.h |  492 ++
 drivers/staging/tidspbridge/include/dspbridge/gb.h |   79 +
 .../tidspbridge/include/dspbridge/getsection.h     |  108 +
 drivers/staging/tidspbridge/include/dspbridge/gh.h |   34 +
 drivers/staging/tidspbridge/include/dspbridge/gs.h |   59 +
 .../tidspbridge/include/dspbridge/host_os.h        |   88 +
 drivers/staging/tidspbridge/include/dspbridge/io.h |  114 +
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |  298 ++
 .../staging/tidspbridge/include/dspbridge/iodefs.h |   36 +
 .../staging/tidspbridge/include/dspbridge/ldr.h    |   29 +
 .../staging/tidspbridge/include/dspbridge/list.h   |  225 +
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |  184 +
 .../tidspbridge/include/dspbridge/memdefs.h        |   30 +
 .../staging/tidspbridge/include/dspbridge/mgr.h    |  205 +
 .../tidspbridge/include/dspbridge/mgrpriv.h        |   45 +
 .../staging/tidspbridge/include/dspbridge/msg.h    |   86 +
 .../tidspbridge/include/dspbridge/msgdefs.h        |   29 +
 .../staging/tidspbridge/include/dspbridge/nldr.h   |   57 +
 .../tidspbridge/include/dspbridge/nldrdefs.h       |  293 ++
 .../staging/tidspbridge/include/dspbridge/node.h   |  583 +++
 .../tidspbridge/include/dspbridge/nodedefs.h       |   28 +
 .../tidspbridge/include/dspbridge/nodepriv.h       |  182 +
 .../staging/tidspbridge/include/dspbridge/ntfy.h   |  217 +
 .../staging/tidspbridge/include/dspbridge/proc.h   |  621 +++
 .../tidspbridge/include/dspbridge/procpriv.h       |   25 +
 .../staging/tidspbridge/include/dspbridge/pwr.h    |  107 +
 .../staging/tidspbridge/include/dspbridge/pwr_sh.h |   33 +
 .../include/dspbridge/resourcecleanup.h            |   52 +
 .../staging/tidspbridge/include/dspbridge/rmm.h    |  181 +
 .../staging/tidspbridge/include/dspbridge/rms_sh.h |   95 +
 .../tidspbridge/include/dspbridge/rmstypes.h       |   24 +
 .../tidspbridge/include/dspbridge/services.h       |   50 +
 .../staging/tidspbridge/include/dspbridge/strm.h   |  404 ++
 .../tidspbridge/include/dspbridge/strmdefs.h       |   46 +
 .../staging/tidspbridge/include/dspbridge/sync.h   |  109 +
 .../tidspbridge/include/dspbridge/utildefs.h       |   39 +
 .../tidspbridge/include/dspbridge/uuidutil.h       |   62 +
 .../staging/tidspbridge/include/dspbridge/wdt.h    |   79 +
 drivers/staging/tidspbridge/pmgr/chnl.c            |  163 +
 drivers/staging/tidspbridge/pmgr/chnlobj.h         |   46 +
 drivers/staging/tidspbridge/pmgr/cmm.c             | 1154 +++++
 drivers/staging/tidspbridge/pmgr/cod.c             |  652 +++
 drivers/staging/tidspbridge/pmgr/dbll.c            | 1585 +++++++
 drivers/staging/tidspbridge/pmgr/dev.c             | 1151 +++++
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 +++
 drivers/staging/tidspbridge/pmgr/dspapi.c          | 1906 ++++++++
 drivers/staging/tidspbridge/pmgr/io.c              |  142 +
 drivers/staging/tidspbridge/pmgr/ioobj.h           |   38 +
 drivers/staging/tidspbridge/pmgr/msg.c             |  129 +
 drivers/staging/tidspbridge/pmgr/msgobj.h          |   38 +
 drivers/staging/tidspbridge/rmgr/dbdcd.c           | 1512 +++++++
 drivers/staging/tidspbridge/rmgr/disp.c            |  752 ++++
 drivers/staging/tidspbridge/rmgr/drv.c             |  929 ++++
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |  656 +++
 drivers/staging/tidspbridge/rmgr/drv_interface.h   |   28 +
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |  142 +
 drivers/staging/tidspbridge/rmgr/mgr.c             |  375 ++
 drivers/staging/tidspbridge/rmgr/nldr.c            | 1974 ++++++++
 drivers/staging/tidspbridge/rmgr/node.c            | 3234 +++++++++++++
 drivers/staging/tidspbridge/rmgr/proc.c            | 1936 ++++++++
 drivers/staging/tidspbridge/rmgr/pwr.c             |  176 +
 drivers/staging/tidspbridge/rmgr/rmm.c             |  537 +++
 drivers/staging/tidspbridge/rmgr/strm.c            |  853 ++++
 drivers/staging/tidspbridge/services/cfg.c         |  253 ++
 drivers/staging/tidspbridge/services/ntfy.c        |   31 +
 drivers/staging/tidspbridge/services/services.c    |   70 +
 drivers/staging/tidspbridge/services/sync.c        |  104 +
 drivers/staging/usbip/stub.h                       |   17 +-
 drivers/staging/usbip/stub_dev.c                   |  101 +-
 drivers/staging/usbip/stub_main.c                  |   65 +-
 drivers/staging/usbip/stub_rx.c                    |  101 +-
 drivers/staging/usbip/usbip_common.h               |    2 +-
 drivers/staging/vme/bridges/vme_ca91cx42.c         |   12 +-
 drivers/staging/vme/bridges/vme_tsi148.c           |   10 +-
 drivers/staging/vme/devices/vme_user.c             |   99 +-
 drivers/staging/vt6655/80211hdr.h                  |  118 +-
 drivers/staging/vt6655/80211mgr.c                  |  118 +-
 drivers/staging/vt6655/80211mgr.h                  |  336 +-
 drivers/staging/vt6655/IEEE11h.c                   |   68 +-
 drivers/staging/vt6655/IEEE11h.h                   |    2 +-
 drivers/staging/vt6655/Makefile                    |    1 +
 drivers/staging/vt6655/TODO                        |    3 +-
 drivers/staging/vt6655/aes_ccmp.c                  |  112 +-
 drivers/staging/vt6655/aes_ccmp.h                  |    2 +-
 drivers/staging/vt6655/baseband.c                  |  196 +-
 drivers/staging/vt6655/baseband.h                  |   52 +-
 drivers/staging/vt6655/bssdb.c                     |  351 +-
 drivers/staging/vt6655/bssdb.h                     |  246 +-
 drivers/staging/vt6655/card.c                      | 1369 +-----
 drivers/staging/vt6655/card.h                      |  158 +-
 drivers/staging/vt6655/channel.c                   |  835 ++++
 drivers/staging/vt6655/channel.h                   |   58 +
 drivers/staging/vt6655/country.h                   |   15 -
 drivers/staging/vt6655/datarate.c                  |   90 +-
 drivers/staging/vt6655/datarate.h                  |   24 +-
 drivers/staging/vt6655/desc.h                      |  352 +-
 drivers/staging/vt6655/device.h                    |  526 ++--
 drivers/staging/vt6655/device_cfg.h                |    8 -
 drivers/staging/vt6655/device_main.c               |  566 ++--
 drivers/staging/vt6655/dpc.c                       |  516 +--
 drivers/staging/vt6655/dpc.h                       |    2 +-
 drivers/staging/vt6655/hostap.c                    |   84 +-
 drivers/staging/vt6655/iocmd.h                     |  347 +-
 drivers/staging/vt6655/ioctl.c                     |  128 +-
 drivers/staging/vt6655/ioctl.h                     |    6 +-
 drivers/staging/vt6655/iwctl.c                     |  152 +-
 drivers/staging/vt6655/key.c                       |  288 +-
 drivers/staging/vt6655/key.h                       |  114 +-
 drivers/staging/vt6655/mac.c                       |  363 +-
 drivers/staging/vt6655/mac.h                       |  203 +-
 drivers/staging/vt6655/mib.c                       |  110 +-
 drivers/staging/vt6655/mib.h                       |  429 +-
 drivers/staging/vt6655/michael.c                   |   46 +-
 drivers/staging/vt6655/michael.h                   |    6 +-
 drivers/staging/vt6655/power.c                     |   74 +-
 drivers/staging/vt6655/power.h                     |   12 +-
 drivers/staging/vt6655/rc4.c                       |   40 +-
 drivers/staging/vt6655/rc4.h                       |   12 +-
 drivers/staging/vt6655/rf.c                        |  196 +-
 drivers/staging/vt6655/rf.h                        |   20 +-
 drivers/staging/vt6655/rxtx.c                      | 1104 +++---
 drivers/staging/vt6655/rxtx.h                      |   62 +-
 drivers/staging/vt6655/srom.c                      |   82 +-
 drivers/staging/vt6655/srom.h                      |   80 +-
 drivers/staging/vt6655/tcrc.c                      |   12 +-
 drivers/staging/vt6655/tcrc.h                      |    6 +-
 drivers/staging/vt6655/tether.c                    |   20 +-
 drivers/staging/vt6655/tether.h                    |   60 +-
 drivers/staging/vt6655/tkip.c                      |   14 +-
 drivers/staging/vt6655/tkip.h                      |   10 +-
 drivers/staging/vt6655/tmacro.h                    |   12 +-
 drivers/staging/vt6655/ttype.h                     |   57 +-
 drivers/staging/vt6655/upc.h                       |   22 +-
 drivers/staging/vt6655/vntwifi.c                   |  174 +-
 drivers/staging/vt6655/vntwifi.h                   |   82 +-
 drivers/staging/vt6655/wcmd.c                      |  169 +-
 drivers/staging/vt6655/wcmd.h                      |   18 +-
 drivers/staging/vt6655/wctl.c                      |   62 +-
 drivers/staging/vt6655/wctl.h                      |    9 +-
 drivers/staging/vt6655/wmgr.c                      |  807 ++--
 drivers/staging/vt6655/wmgr.h                      |  192 +-
 drivers/staging/vt6655/wpa.c                       |   62 +-
 drivers/staging/vt6655/wpa.h                       |    8 +-
 drivers/staging/vt6655/wpa2.c                      |   70 +-
 drivers/staging/vt6655/wpa2.h                      |    8 +-
 drivers/staging/vt6655/wpactl.c                    |   80 +-
 drivers/staging/vt6655/wpactl.h                    |    4 +-
 drivers/staging/vt6655/wroute.c                    |   44 +-
 drivers/staging/vt6655/wroute.h                    |    2 +-
 drivers/staging/vt6656/80211mgr.c                  |  516 ++--
 drivers/staging/vt6656/80211mgr.h                  |   33 +-
 drivers/staging/vt6656/aes_ccmp.c                  |    4 +-
 drivers/staging/vt6656/baseband.c                  |    6 +-
 drivers/staging/vt6656/baseband.h                  |   19 +-
 drivers/staging/vt6656/bssdb.c                     |  117 +-
 drivers/staging/vt6656/bssdb.h                     |   12 +-
 drivers/staging/vt6656/card.c                      |    7 +-
 drivers/staging/vt6656/channel.c                   |   45 +-
 drivers/staging/vt6656/channel.h                   |   12 +-
 drivers/staging/vt6656/control.c                   |    2 +-
 drivers/staging/vt6656/control.h                   |   14 +-
 drivers/staging/vt6656/datarate.c                  |   69 +-
 drivers/staging/vt6656/desc.h                      |   79 +-
 drivers/staging/vt6656/device.h                    |   52 +-
 drivers/staging/vt6656/device_cfg.h                |   16 +-
 drivers/staging/vt6656/dpc.c                       |   48 +-
 drivers/staging/vt6656/firmware.c                  |    2 +-
 drivers/staging/vt6656/int.c                       |    7 +-
 drivers/staging/vt6656/int.h                       |    8 +-
 drivers/staging/vt6656/iocmd.h                     |   16 +-
 drivers/staging/vt6656/ioctl.c                     |   12 +-
 drivers/staging/vt6656/iowpa.h                     |   47 +-
 drivers/staging/vt6656/iwctl.c                     |  131 +-
 drivers/staging/vt6656/iwctl.h                     |    4 +-
 drivers/staging/vt6656/key.c                       |   34 +-
 drivers/staging/vt6656/mac.c                       |    4 +-
 drivers/staging/vt6656/mac.h                       |    8 +-
 drivers/staging/vt6656/main_usb.c                  |  321 +-
 drivers/staging/vt6656/mib.c                       |   25 +-
 drivers/staging/vt6656/mib.h                       |   25 +-
 drivers/staging/vt6656/michael.c                   |    4 +-
 drivers/staging/vt6656/michael.h                   |    6 +-
 drivers/staging/vt6656/power.c                     |   10 +-
 drivers/staging/vt6656/power.h                     |    2 +-
 drivers/staging/vt6656/rf.h                        |   19 +-
 drivers/staging/vt6656/rndis.h                     |    2 +-
 drivers/staging/vt6656/rxtx.c                      |   79 +-
 drivers/staging/vt6656/rxtx.h                      |    6 +-
 drivers/staging/vt6656/tether.h                    |   41 +-
 drivers/staging/vt6656/tkip.c                      |    6 +-
 drivers/staging/vt6656/ttype.h                     |   31 -
 drivers/staging/vt6656/usbpipe.c                   |   99 +-
 drivers/staging/vt6656/usbpipe.h                   |   33 +-
 drivers/staging/vt6656/wcmd.c                      |   41 +-
 drivers/staging/vt6656/wcmd.h                      |    3 -
 drivers/staging/vt6656/wctl.c                      |   24 +-
 drivers/staging/vt6656/wmgr.c                      |   75 +-
 drivers/staging/vt6656/wmgr.h                      |   11 +-
 drivers/staging/vt6656/wpa.c                       |    6 +-
 drivers/staging/vt6656/wpa2.h                      |   18 +-
 drivers/staging/vt6656/wpactl.c                    |   12 +-
 drivers/staging/winbond/mac_structures.h           |  144 +-
 drivers/staging/winbond/phy_calibration.c          |  834 ++--
 drivers/staging/winbond/reg.c                      |   36 +-
 drivers/staging/winbond/wbusb.c                    |    2 +-
 drivers/staging/wlags49_h2/hcf.c                   |    2 +-
 drivers/staging/wlags49_h2/mdd.h                   |    4 +-
 drivers/staging/wlags49_h2/wl_cs.c                 |  499 +--
 drivers/staging/wlags49_h2/wl_cs.h                 |    2 -
 drivers/staging/wlags49_h2/wl_netdev.c             |    4 +-
 drivers/staging/wlags49_h2/wl_pci.c                |   16 +-
 drivers/staging/wlags49_h2/wl_pci.h                |    8 +-
 drivers/staging/wlags49_h2/wl_profile.c            |    2 +-
 drivers/staging/wlags49_h2/wl_util.c               |   37 +-
 drivers/staging/wlags49_h2/wl_util.h               |    2 -
 drivers/staging/wlan-ng/Kconfig                    |    2 +-
 drivers/staging/wlan-ng/Makefile                   |    1 -
 drivers/staging/wlan-ng/cfg80211.c                 |  760 ++++
 drivers/staging/wlan-ng/hfa384x.h                  |    4 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |   34 +-
 drivers/staging/wlan-ng/p80211conv.c               |   70 +-
 drivers/staging/wlan-ng/p80211conv.h               |   42 +-
 drivers/staging/wlan-ng/p80211hdr.h                |   24 +-
 drivers/staging/wlan-ng/p80211ioctl.h              |    4 +-
 drivers/staging/wlan-ng/p80211meta.h               |   16 +-
 drivers/staging/wlan-ng/p80211metastruct.h         |   62 +-
 drivers/staging/wlan-ng/p80211mgmt.h               |   24 +-
 drivers/staging/wlan-ng/p80211msg.h                |    4 +-
 drivers/staging/wlan-ng/p80211netdev.c             |   77 +-
 drivers/staging/wlan-ng/p80211netdev.h             |    9 +-
 drivers/staging/wlan-ng/p80211req.c                |   18 +-
 drivers/staging/wlan-ng/p80211wext.c               | 1690 -------
 drivers/staging/wlan-ng/prism2fw.c                 |  118 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |   24 +-
 drivers/staging/wlan-ng/prism2mib.c                |   76 +-
 drivers/staging/wlan-ng/prism2sta.c                |   91 +-
 drivers/staging/wlan-ng/prism2usb.c                |    2 +-
 drivers/staging/xgifb/XGI.h                        |   10 -
 drivers/staging/xgifb/XGI_accel.c                  |  307 --
 drivers/staging/xgifb/XGI_accel.h                  |   14 +-
 drivers/staging/xgifb/XGI_main.h                   |  182 +-
 drivers/staging/xgifb/XGI_main_26.c                |  255 +-
 drivers/staging/xgifb/XGIfb.h                      |   31 +-
 drivers/staging/xgifb/osdef.h                      |  153 -
 drivers/staging/xgifb/vb_def.h                     |    4 +-
 drivers/staging/xgifb/vb_ext.c                     |  510 +--
 drivers/staging/xgifb/vb_ext.h                     |   26 +-
 drivers/staging/xgifb/vb_init.c                    |  895 ++---
 drivers/staging/xgifb/vb_init.h                    |    4 +-
 drivers/staging/xgifb/vb_setmode.c                 | 2060 ++++-----
 drivers/staging/xgifb/vb_setmode.h                 |   66 +-
 drivers/staging/xgifb/vb_struct.h                  |  951 ++--
 drivers/staging/xgifb/vb_table.h                   |  633 ++--
 drivers/staging/xgifb/vb_util.c                    |  137 +-
 drivers/staging/xgifb/vb_util.h                    |   20 +-
 drivers/staging/xgifb/vgatypes.h                   |  271 +-
 drivers/staging/zram/Kconfig                       |   29 +
 drivers/staging/zram/Makefile                      |    3 +
 drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
 drivers/staging/zram/zram.txt                      |   62 +
 drivers/staging/zram/zram_drv.c                    |  805 ++++
 .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |   71 +-
 .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |   21 +-
 812 files changed, 106306 insertions(+), 33784 deletions(-)
 create mode 100644 drivers/staging/batman-adv/bat_debugfs.c
 create mode 100644 drivers/staging/batman-adv/bat_debugfs.h
 delete mode 100644 drivers/staging/batman-adv/device.c
 create mode 100644 drivers/staging/batman-adv/icmp_socket.c
 rename drivers/staging/batman-adv/{device.h => icmp_socket.h} (54%)
 create mode 100644 drivers/staging/batman-adv/sysfs-class-net-batman-adv
 create mode 100644 drivers/staging/batman-adv/sysfs-class-net-mesh
 delete mode 100644 drivers/staging/dt3155/Kconfig
 delete mode 100644 drivers/staging/dt3155/Makefile
 delete mode 100644 drivers/staging/dt3155/TODO
 delete mode 100644 drivers/staging/dt3155/allocator.README
 delete mode 100644 drivers/staging/dt3155/allocator.c
 delete mode 100644 drivers/staging/dt3155/allocator.h
 delete mode 100644 drivers/staging/dt3155/dt3155.h
 delete mode 100644 drivers/staging/dt3155/dt3155.sysvinit
 delete mode 100644 drivers/staging/dt3155/dt3155_drv.c
 delete mode 100644 drivers/staging/dt3155/dt3155_drv.h
 delete mode 100644 drivers/staging/dt3155/dt3155_io.c
 delete mode 100644 drivers/staging/dt3155/dt3155_io.h
 delete mode 100644 drivers/staging/dt3155/dt3155_isr.c
 delete mode 100644 drivers/staging/dt3155/dt3155_isr.h
 create mode 100644 drivers/staging/easycap/Kconfig
 create mode 100644 drivers/staging/easycap/Makefile
 create mode 100644 drivers/staging/easycap/README
 create mode 100644 drivers/staging/easycap/easycap.h
 create mode 100644 drivers/staging/easycap/easycap_debug.h
 create mode 100644 drivers/staging/easycap/easycap_ioctl.c
 create mode 100644 drivers/staging/easycap/easycap_ioctl.h
 create mode 100644 drivers/staging/easycap/easycap_low.c
 create mode 100644 drivers/staging/easycap/easycap_main.c
 create mode 100644 drivers/staging/easycap/easycap_settings.c
 create mode 100644 drivers/staging/easycap/easycap_sound.c
 create mode 100644 drivers/staging/easycap/easycap_sound.h
 create mode 100644 drivers/staging/easycap/easycap_standard.h
 create mode 100644 drivers/staging/easycap/easycap_testcard.c
 create mode 100644 drivers/staging/hv/hv_timesource.c
 create mode 100644 drivers/staging/iio/magnetometer/Kconfig
 create mode 100644 drivers/staging/iio/magnetometer/Makefile
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843.c
 delete mode 100644 drivers/staging/msm/lcdc_grapefruit.c
 delete mode 100644 drivers/staging/msm/lcdc_st1_wxga.c
 delete mode 100644 drivers/staging/msm/lcdc_wxga.c
 delete mode 100644 drivers/staging/msm/mddi_toshiba_wvga.c
 create mode 100644 drivers/staging/quickstart/Kconfig
 create mode 100644 drivers/staging/quickstart/Makefile
 create mode 100644 drivers/staging/quickstart/quickstart.c
 delete mode 100644 drivers/staging/ramzswap/Kconfig
 delete mode 100644 drivers/staging/ramzswap/Makefile
 delete mode 100644 drivers/staging/ramzswap/ramzswap.txt
 delete mode 100644 drivers/staging/ramzswap/ramzswap_drv.c
 delete mode 100644 drivers/staging/rt3070/md4.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211.h
 create mode 100644 drivers/staging/solo6x10/Kconfig
 create mode 100644 drivers/staging/solo6x10/Makefile
 create mode 100644 drivers/staging/solo6x10/TODO
 create mode 100644 drivers/staging/solo6x10/solo6010-core.c
 create mode 100644 drivers/staging/solo6x10/solo6010-disp.c
 create mode 100644 drivers/staging/solo6x10/solo6010-enc.c
 create mode 100644 drivers/staging/solo6x10/solo6010-g723.c
 create mode 100644 drivers/staging/solo6x10/solo6010-gpio.c
 create mode 100644 drivers/staging/solo6x10/solo6010-i2c.c
 create mode 100644 drivers/staging/solo6x10/solo6010-jpeg.h
 create mode 100644 drivers/staging/solo6x10/solo6010-offsets.h
 create mode 100644 drivers/staging/solo6x10/solo6010-osd-font.h
 create mode 100644 drivers/staging/solo6x10/solo6010-p2m.c
 create mode 100644 drivers/staging/solo6x10/solo6010-registers.h
 create mode 100644 drivers/staging/solo6x10/solo6010-tw28.c
 create mode 100644 drivers/staging/solo6x10/solo6010-tw28.h
 create mode 100644 drivers/staging/solo6x10/solo6010-v4l2-enc.c
 create mode 100644 drivers/staging/solo6x10/solo6010-v4l2.c
 create mode 100644 drivers/staging/solo6x10/solo6010.h
 create mode 100644 drivers/staging/spectra/Kconfig
 create mode 100644 drivers/staging/spectra/Makefile
 create mode 100644 drivers/staging/spectra/README
 create mode 100644 drivers/staging/spectra/ffsdefs.h
 create mode 100644 drivers/staging/spectra/ffsport.c
 create mode 100644 drivers/staging/spectra/ffsport.h
 create mode 100644 drivers/staging/spectra/flash.c
 create mode 100644 drivers/staging/spectra/flash.h
 create mode 100644 drivers/staging/spectra/lld.c
 create mode 100644 drivers/staging/spectra/lld.h
 create mode 100644 drivers/staging/spectra/lld_cdma.c
 create mode 100644 drivers/staging/spectra/lld_cdma.h
 create mode 100644 drivers/staging/spectra/lld_emu.c
 create mode 100644 drivers/staging/spectra/lld_emu.h
 create mode 100644 drivers/staging/spectra/lld_mtd.c
 create mode 100644 drivers/staging/spectra/lld_mtd.h
 create mode 100644 drivers/staging/spectra/lld_nand.c
 create mode 100644 drivers/staging/spectra/lld_nand.h
 create mode 100644 drivers/staging/spectra/nand_regs.h
 create mode 100644 drivers/staging/spectra/spectraswconfig.h
 create mode 100644 drivers/staging/tidspbridge/Documentation/CONTRIBUTORS
 create mode 100644 drivers/staging/tidspbridge/Documentation/README
 create mode 100644 drivers/staging/tidspbridge/Documentation/error-codes
 create mode 100644 drivers/staging/tidspbridge/Kconfig
 create mode 100644 drivers/staging/tidspbridge/Makefile
 create mode 100644 drivers/staging/tidspbridge/TODO
 create mode 100644 drivers/staging/tidspbridge/core/_cmm.h
 create mode 100644 drivers/staging/tidspbridge/core/_deh.h
 create mode 100644 drivers/staging/tidspbridge/core/_msg_sm.h
 create mode 100644 drivers/staging/tidspbridge/core/_tiomap.h
 create mode 100644 drivers/staging/tidspbridge/core/_tiomap_pwr.h
 create mode 100644 drivers/staging/tidspbridge/core/chnl_sm.c
 create mode 100644 drivers/staging/tidspbridge/core/dsp-clock.c
 create mode 100644 drivers/staging/tidspbridge/core/io_sm.c
 create mode 100644 drivers/staging/tidspbridge/core/msg_sm.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap3430.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap3430_pwr.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap_io.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap_io.h
 create mode 100644 drivers/staging/tidspbridge/core/ue_deh.c
 create mode 100644 drivers/staging/tidspbridge/core/wdt.c
 create mode 100644 drivers/staging/tidspbridge/dynload/cload.c
 create mode 100644 drivers/staging/tidspbridge/dynload/dload_internal.h
 create mode 100644 drivers/staging/tidspbridge/dynload/doff.h
 create mode 100644 drivers/staging/tidspbridge/dynload/getsection.c
 create mode 100644 drivers/staging/tidspbridge/dynload/header.h
 create mode 100644 drivers/staging/tidspbridge/dynload/module_list.h
 create mode 100644 drivers/staging/tidspbridge/dynload/params.h
 create mode 100644 drivers/staging/tidspbridge/dynload/reloc.c
 create mode 100644 drivers/staging/tidspbridge/dynload/reloc_table.h
 create mode 100644 drivers/staging/tidspbridge/dynload/reloc_table_c6000.c
 create mode 100644 drivers/staging/tidspbridge/dynload/tramp.c
 create mode 100644 drivers/staging/tidspbridge/dynload/tramp_table_c6000.c
 create mode 100644 drivers/staging/tidspbridge/gen/gb.c
 create mode 100644 drivers/staging/tidspbridge/gen/gh.c
 create mode 100644 drivers/staging/tidspbridge/gen/gs.c
 create mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
 create mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 create mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 create mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 create mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 create mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 create mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/_chnl_sm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/brddefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfg.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnldefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnlpriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/clk.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cmmdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cod.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbc.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdcd.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdcddef.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbll.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dehdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dev.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/devdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/disp.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dispdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/drv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/drvdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspapi.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdeh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdrv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspio.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dynamic_loader.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/gb.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/getsection.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/gh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/gs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/host_os.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/io.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/io_sm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/iodefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/ldr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/list.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/memdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/mgr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/mgrpriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/msg.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/msgdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nldr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/node.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nodedefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/ntfy.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/proc.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/procpriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr_sh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/resourcecleanup.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/rmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/rmstypes.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/services.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/strm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/strmdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/sync.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/utildefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/wdt.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/chnl.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/chnlobj.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/cmm.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/cod.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dbll.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dev.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dspapi.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/io.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/ioobj.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/msg.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/msgobj.h
 create mode 100644 drivers/staging/tidspbridge/rmgr/dbdcd.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/disp.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/drv.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.h
 create mode 100644 drivers/staging/tidspbridge/rmgr/dspdrv.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/mgr.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/nldr.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/node.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/proc.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/pwr.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/rmm.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/strm.c
 create mode 100644 drivers/staging/tidspbridge/services/cfg.c
 create mode 100644 drivers/staging/tidspbridge/services/ntfy.c
 create mode 100644 drivers/staging/tidspbridge/services/services.c
 create mode 100644 drivers/staging/tidspbridge/services/sync.c
 create mode 100644 drivers/staging/vt6655/channel.c
 create mode 100644 drivers/staging/vt6655/channel.h
 create mode 100644 drivers/staging/wlan-ng/cfg80211.c
 delete mode 100644 drivers/staging/wlan-ng/p80211wext.c
 delete mode 100644 drivers/staging/xgifb/XGI.h
 delete mode 100644 drivers/staging/xgifb/osdef.h
 create mode 100644 drivers/staging/zram/Kconfig
 create mode 100644 drivers/staging/zram/Makefile
 rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
 create mode 100644 drivers/staging/zram/zram.txt
 create mode 100644 drivers/staging/zram/zram_drv.c
 rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (69%)
 rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (68%)

---------------

Adam Latham (2):
      Staging: winbond: Fix C99 Comment issues in mac_structures.h
      Staging: winbond: Fix for brace style, length and whitespace in mac_structures.h

Alan Olsen (1):
      Moorestown "Post Beta" nand driver.

Andrea Gelmini (1):
      Staging: ti-st: Fix a typo in the Kconfig file

Andreas Herrmann (1):
      Staging: rtl81xx: Fix build problems when CONFIG_CRYPTO=n

Andres More (25):
      Staging: vt6656: code cleanup, fixed 'for' statements
      Staging: vt6656: code cleanup, resolved checkpatch findings in headers
      Staging: vt6656: removed '#if 0' definitions
      Staging: vt6656: code cleanup in vt6656_suspend()/vt6656_resume()
      Staging: vt6656: code cleanup of vt6656_disconnect()
      Staging: vt6656: replaced IS_BROADCAST_ADDRESS with is_broadcast_ether_addr
      staging: vt6656: replace IS_ETH_ADDRESS_EQUAL with compare_ether_addr
      staging: vt6656: removed unused IS_NULL_ADDRESS definition
      staging: vt6656: removed TxInSleep definition
      staging: vt6656: removed SndEvt_ToAPI definition
      staging: vt6656: removed '#if 1'/'#if 0' definitions
      staging: vt6656: code cleanup in vt6656_probe()
      staging: vt6656: code cleanup in vt6656 DMA TX
      staging: vt6656: removed Safe_Close definition
      staging: vt6656: removed Adhoc_STA definition
      staging: vt6656: removed update_BssList definition
      staging: vt6656: removed WPA_SM_Transtatus definition
      staging: vt6656: removed Calcu_LinkQual definition
      staging: vt6656: replaced U_CRC_LEN with ETH_FCS_LEN
      staging: vt6656: replaced MAX_DATA_LEN with ETH_DATA_LEN
      staging: vt6656: replaced MIN_PACKET_LEN with ETH_ZLEN
      staging: vt6656: replaced MAX_PACKET_LEN with ETH_FRAME_LEN
      staging: vt6656: code cleanup in device_netdev_ops' device_xmit()
      staging: vt6656: simplified tests involving both multi/broad-casts
      staging: vt6656: removed NTSTATUS definition

Andy Shevchenko (7):
      Staging: don't use custom hex_to_bin() implementation
      staging: tidspbridge: gen: simplify and clean up
      staging: panel: change own pieces of code by strtoul()
      staging: rtl8192su: don't use own isxdigit() method
      staging: otus: remove unused methods
      staging: wlags49_h2: remove custom hex_to_bin() method
      staging: wlan-ng: remove own bin2hex converter

Angelo Arrifano (1):
      Staging: add quickstart acpi key driver

Antonio Quartulli (1):
      Staging: batman-adv: Convert names from Java to C style

Armando Uribe (9):
      staging: tidspbridge: Remove Redundant wrappers
      staging: tidspbridge: Remove redundant macros in io_sm.c
      staging: tidspbridge: Change macros to static inline functions in io_sm
      staging: tidspbridge: Change macros to static inline functions used in cload
      staging: tidspbridge: Remove redundant macro from cod.c
      staging: tidspbridge: Remove unused magic number
      staging: tidspbridge: Remove macros used as cast
      staging: tidspbridge: Change macros to static inline functions
      staging: tidspbridge: Remove unused macros

Arnd Bergmann (2):
      Staging: use llseek in all file operations
      Staging: autoconvert trivial BKL users to private mutex

Arun Thomas (4):
      Staging: comedi: Remove COMEDI_MODULES_MACRO
      Staging: comedi: Remove COMEDI_INITCLEANUP macro
      Staging: comedi: Remove COMEDI_PCI_INITCLEANUP macro
      Staging: comedi: Remove typedefs

Barry Song (4):
      Staging: iio: adis16300: fix some minor issues and clean-up
      Staging: iio: adis16400: fix some minor issues and clean-up
      Staging: iio: adis16209/220/240/350: tuning spi delay to make hardware more stable
      staging: iio: Add a bits per element element to ring_generic allowing a general ring_sw_preenable_function.

Ben Collins (4):
      Staging: solo6x10: New driver (staging) for Softlogic 6x10
      Staging: solo6x10: Add kconfig/kbuild fairy dust for solo6x10
      Staging: solo6x10: Support for tw2865 in cascade/full modes
      Staging: solo6x10: Add TODO

Ben Hutchings (2):
      Staging: rtl8192su: Clean up in case of an error in module initialisation
      Staging: rtl8192su: Fix procfs code for interfaces not named wlan0

Bill Pemberton (25):
      Staging: xgifb: use %lx instead of %x in printk format
      Staging: xgifb: remove use of LINUX_VERSION_CODE
      Staging: xgifb: Remove code for WIN2000
      Staging: xgifb: Remove use of WINCE_HEADER define
      Staging: xgifb: Remove use of TC define
      Staging: xgifb: Remove use of LINUX_XF86 define
      Staging: xgifb: Remove use of LINUX_KERNEL define
      Staging: xgifb: Remove XGI_SetMemory and XGI_MemoryCopy
      Staging: xgifb: Remove port macros in osdef.h
      Staging: xgifb: Remove defines for TRUE, FALSE, and NULL
      Staging: xgifb: Remove PUCHAR typedef
      Staging: xgifb: Remove PUSHORT, PLONGU, and PVOID typedefs
      Staging: xgifb: Remove unused code
      Staging: xgifb: Remove USHORT, ULONG, BOOLEAN, and VOID typedefs
      Staging: xgifb: Remove SHORT, UCHAR, and LONG typedef
      Staging: xgifb: Remove XGI_LCD_TYPE and XGI_VB_CHIP_TYPE typedefs
      Staging: xgifb: Remove XGI_DSReg and PXGI_DSReg typedefs
      Staging: xgifb: Remove XGI_HW_DEVICE_INFO and PXGI_HW_DEVICE_INFO typedefs
      Staging: xgifb: Remove typedefs in vb_struct.h
      Staging: xgifb: Remove typedefs in XGIfb.h
      Staging: xgifb: Remove XGI_TV_PLUG typedef
      Staging: xgifb: remove XGI.h
      Staging: xgifb: remove __KERNEL__ #ifdef in XGIfb.h
      Staging: xgifb: remove externs in XGI_accel.c
      Staging: xgifb: increase VBIOS_VER_MAX_LENGTH to 5

Bob Beattie (1):
      Staging: comedi: drivers: fix space coding style in am9513.h

Charles Clément (38):
      Staging: vt6655: use ETH_ZLEN macro instead of custom one
      Staging: vt6655: use is_multicast_ether_addr instead of custom macro
      Staging: vt6655: use is_broadcast_ether_addr instead of custom macro
      Staging: vt6655: use is_zero_ether_addr instead of custom macro
      Staging: vt6655: use compare_ether_addr instead of custom macro
      Staging: vt6655: remove unused argument in ChannelValid function
      Staging: vt6655: remove double definition of Calcu_LinkQual
      Staging: vt6655: remove unused OUT definition
      Staging: vt6655: remove I8 custom macro
      Staging: vt6655: remove U8 custom macro
      Staging: vt6655: remove U16 custom macro
      Staging: vt6655: remove U32 custom macro
      Staging: vt6655: removed custom CHAR typedef
      Staging: vt6655: removed custom SHORT typedef
      Staging: vt6655: remove custom INT typedef
      Staging: vt6655: remove custom LONG typedef
      Staging: vt6655: remove custom UCHAR typedef
      Staging: vt6655: remove custom USHORT typedef
      Staging: vt6655: remove custom UINT typedef
      Staging: vt6655: remove custom ULONG typedef
      Staging: vt6655: remove custom ULONGLONG typedef
      Staging: vt6655: remove PBYTE typedef
      Staging: vt6655: remove PWORD typedef
      Staging: vt6655: remove PDWORD typedef
      Staging: vt6655: include linux/ headers instead of asm/
      Staging: vt6655: struct pci_driver cleanup
      Staging: vt6655: move channel mapping code from card.c to channel.c
      Staging: vt6655: remove ULONG_PTR typedef
      Staging: vt6655: remove DWORD_PTR pointer typedef
      Staging: vt6655: remove DWORD typedef
      Staging: vt6655: remove WORD typedef
      Staging: vt6655: remove BYTE typedef
      Staging: vt6655: remove PUINT typedef
      Staging: vt6655: Add TODO entries on x86-64 pointers and .data size
      Staging: vt6655: simplify broadcast and multicast ethernet address test
      Staging: vt6655: replace TRUE with in kernel true
      Staging: vt6655: replace FALSE with in kernel false
      Staging: vt6655: replace BOOL with in kernel bool

Christoph Fritz (1):
      Staging: wlan-ng: Update prism2_set_tx_power() to use mBm

Cody Harmon (1):
      Staging: comedi: ni_tio: fixed brace coding style issues and a few errors

Dan Carpenter (5):
      Staging: comedi: cleanup: remove unneeded null checks
      Staging: iio: add file pointer to sysfs callbacks
      Staging: wlan-ng: silence a sparse warning
      Staging: otus: fix strcpy() overflow
      Staging: batman-adv: return -EFAULT on copy_to_user errors

Daniel Seither (1):
      Staging: batman-adv: record route for ICMP messages

Daniele Boncompagni (1):
      Staging: comedi : fix brace coding style issue in wwrap.c

Dave Jones (1):
      Staging: rtl8192u: remove a copy of 80211.h

David Woodhouse (6):
      spectra: Make it build as a module
      spectra: Clean up emulation vs. hardware backend support
      spectra: Don't overwrite nand_debug_level. It's a module param
      spectra: Add basic mtd support
      spectra: Move to drivers/staging
      spectra: Rename config options

Denis Kirjanov (2):
      Staging: slicoss: kill functions prototypes and reorder functions
      Staging: slicoss: Remove net_device_stats from the driver's private

Edgardo Hames (8):
      Staging: wlan-ng: fix style in p80211netdev.c
      Staging: wlan-ng: removed typedef from prism2fw.c
      Staging: wlan-ng: fix style in cfg80211.c
      Staging: wlan-ng: fix style issues for p80211hdr.h
      Staging: wlan-ng: fix style issues in p80211conv.h
      Staging: wlan-ng: remove typedef in p80211ioctl.h
      Staging: wlan-ng: fix checkpatch issues in headers.
      Staging: wlan-ng: remove typedef in p80211hdr.h

Endre Kollar (3):
      Staging: usbip: fix multiple interfaces
      Staging: usbip: simplify get_ep_from_epnum
      Staging: usbip: Filtering illegal flags from remote driver

Ernesto Ramos (26):
      staging:ti dspbridge: remove unused typedef REG16
      staging:ti dspbridge: remove unnecessary check for NULL pointer in cmm.c
      staging:ti dspbridge: remove function delete_strm_mgr
      staging:ti dspbridge: remove unnecessary volatile variables
      staging:ti dspbridge: replace simple_strtoul by strict_strtoul
      staging:ti dspbridge: remove DSP_SUCCEEDED macro from core
      staging:ti dspbridge: remove DSP_SUCCEEDED macro from pmgr
      staging:ti dspbridge: remove DSP_SUCCEEDED macro from rmgr
      staging:ti dspbridge: remove DSP_SUCCEEDED macro from services
      staging:ti dspbridge: remove DSP_SUCCEEDED macro definition
      staging:ti dspbridge: remove DSP_FAILED macro from core
      staging:ti dspbridge: remove DSP_FAILED macro from pmgr
      staging:ti dspbridge: remove DSP_FAILED macro from rmgr
      staging:ti dspbridge: remove DSP_FAILED macro from services
      staging:ti dspbridge: remove DSP_FAILED macro definition
      staging:ti dspbridge: fix bridge_brd_stop so IVA2 is set OFF
      staging:ti dspbridge: proc_load/start should set IVA2 to OFF in case of failure
      staging:ti dspbridge: make sure IVA2 is OFF when dev is created
      staging:ti dspbridge: remove bridge_brd_delete function
      staging:ti dspbridge: remove find_gcf from nldr.c
      staging: ti dspbridge: avoid possible NULL dereference panic
      staging: ti dspbridge: use node id instead of kernel address
      staging: ti dspbridge: avoid errors if node handle is zero
      staging: ti dspbridge: use processor handle from context instead of user's
      staging: ti dspbridge: use stream id instead of kernel address
      staging: ti dspbridge: avoid errors if stream id is zero

Felipe Contreras (18):
      staging: ti dspbridge: remove contributor leftovers
      staging: ti dspbridge: deh: trivial cleanups
      staging: ti dspbridge: mmufault: trivial cleanups
      staging: ti dspbridge: deh: free dummy page immediately
      staging: ti dspbridge: remove unused code
      staging: ti dspbridge: mmu: add hw_mmu_tlb_flush_all()
      staging: ti dspbridge: deh: ensure only tlb #0 is enabled
      staging: ti dspbridge: deh: refactor in mmu_fault_print_stack()
      staging: ti dspbridge: deh: remove get_info
      staging: ti dspbridge: deh: remove err_info
      staging: ti dspbridge: access deh directly
      staging: ti dspbridge: move mmufault to deh
      staging: ti dspbridge: deh: tidying up
      staging: ti dspbridge: deh: update copyright notice
      staging: ti dspbridge: prefix configs with TIDSPBRIDGE
      staging: ti dspbridge: improve Kconfig
      staging: ti dspbridge: use _DEBUG for debug trace
      staging: ti dspbridge: add _BACKTRACE config

Florian Schilhabel (33):
      staging: rtl8192su: fix a compiler warning
      staging: rtl8192su: update rtl819x_set_channel_map()
      staging: rtl8192su: cosmetics in r8192S_Efuse.c
      staging: rtl8192su: update to r8192S_Efuse.c, r8192xU_cmdpkt.c
      staging: rtl819ssu: clean r8192S_hw.h
      staging: rtl8192su: r8192S_phy.c, remove unused code
      staging: rtl8192su: r8192S_phy.c, remove unused code; 2nd part
      staging: rtl8192su: r8192U.h, clean header
      staging: rtl8192su: update r8192U.h
      staging: rtl8192su: some work on dm_check_edca_turbo()
      staging: rtl8192su: clean dot11d.[c|h]
      staging: rtl8192su: clean ieee80211_crypt.c
      staging: rtl8192su: cleanup in ieee80211_tx.c, ieee80211_wx.c
      staging: rtl8192su: code cleanup
      staging: rtl8192su: more code cleanup
      staging: rtl8192su: remove some unused code, cleanup
      staging: rtl8192su: updated r8192SU_HWImg.c, r8192SU_HWImg.h
      staging: rtl819esu: cleanup; r8192S_Efuse.c, r8192S_Efuse.h
      staging: rtl8192su: various updates
      staging: rtl8192su: update TODO
      staging: rtl8192su: merge changes in r8192U_wx.c
      staging: rtl8192su: remove a section mismatch warning
      staging: rtl819su: ieee80211_associate_procedure_wq() update
      staging: rtl819su: update probe_rq_parse()
      staging: rtl819su: update MgntQuery_MgntFrameTxRate()
      staging: rtl819su: merge changes in softmac_ps_mgmt_xmit()
      staging: rtl8192su: cleanup in ieee80211_softmac.c
      staging: rtl8192su: merge changes in ieee80211_authentication_req()
      staging: rtl8192su: merge changes in ieee80211_tkip_data()
      staging: rtl8192su: merge updated ieee80211_crypto_ops()
      staging: rtl8192su: merge changes into ieee80211_rx_ADDBARsp()
      staging: rtl8192su: merge changes in rtl819x_HTProc.c; still incomplete
      staging: rtl8192su: added ioctl[SIOCSIWPMKSA] implementation

Greg Kroah-Hartman (10):
      Staging: vt6655: fix up U32 conversion
      Staging: winbond: fix build errors
      Staging: quickstart: add the quickstart driver to the build
      Staging: hv: remove DPRINT_ENTER macro
      Staging: hv: remove DPRINT_EXIT macro
      Staging: usbip: fix up build error
      Staging: hv: remove RING_BUFFER_DEBUG_INFO typedef
      Staging: hv: remove RING_BUFFER_INFO typedef
      Staging: hv: remove RING_BUFFER typedef
      Staging: dt3155: remove the driver

Gustavo Silva (8):
      Staging: comedi: drivers: fix coding style issues in me4000.c
      Staging: comedi: drivers: Fix coding style issues in pcl711.c
      Staging: comedi: drivers: fix coding style issues in pcl816.c
      Staging: comedi: drivers: fix coding style issues in pcmda12.c
      Staging: comedi: drivers: fix coding style issues in quatech_daqp_cs.c
      Staging: comedi: drivers: fix coding style issues in pcl812.c
      Staging: otus: fix coding style issues in ioctl.c
      Staging: comedi: kcomedilib: fix coding style issues in kcomedilib_main.c

H Hartley Sweeten (11):
      Staging: dt3155: fix different address spaces noise in dt3155_drv.c
      Staging: dt3155: remove DT_3155_* errno defines
      Staging: dt3155: Cleanup memory mapped i/o access
      Staging: d53155_drv.c: cleanup fbuffer usage
      Staging: dt3155_drv.c: dereference dt3155_status[]
      Staging: dt3155: remove unused 32-bit and 8-bit global registers
      Staging: dt3155: remove remaining 32-bit and 8-bit global registers
      Staging: dt3155_isr: cleanup fbuffer usage
      Staging: dt3155: use the fbuffer pointer instead of looking it up
      Staging: dt3155: make module_{init/exit} functions static
      Staging: dt3155: make local functions static

Haiyang Zhang (1):
      staging: hv: Fix Kconfig dependency of hv_blkvsc

Henri Häkkinen (1):
      staging:panel: Fixed coding conventions.

Huang Weiyi (2):
      Staging: XGI: remove duplicated #include
      Staging: MSM: remove duplicated #include

Ian Abbott (8):
      Staging: comedi: Allow 'open' driver method to fail
      Staging: comedi: serial2002: handle allocation failures on 'open'
      Staging: comedi: serial2002: Fix memory leak on detach
      Staging: comedi: serial2002: Reduce stack usage on 'open'
      Staging: comedi: serial2002: Use NULL instead of 0 for pointers
      Staging: comedi: drivers: das08: Add whitespace to driver comment block
      Staging: comedi: drivers: skel: Add whitespace to example comment block
      Staging: Comedi: drivers: Remove comment copied from skel.c

Javier Martinez Canillas (6):
      Staging: pohmelfs: fix compile warning
      Staging: batman-adv: fix function prototype
      Staging: spectra: remove non existing blk_fs_request wrapper
      Staging: wlags49_h2: remove unused function prototype
      Staging: quatech_usb2: remove unused qt2_box_flush function
      Staging: wlags49_h2: use common PCI_VENDOR/DEVICE_ID name format

Jiri Kosina (4):
      Staging: cxt1e1: remove all code dependent on LINUX_VERSION_CODE
      Staging: rtl8192su: remove all code dependent on LINUX_VERSION_CODE
      Staging: cxt1e1: remove code guarded by GENERIC_HDLC_VERSION
      Staging: rtl8192e: remove all code dependent on LINUX_VERSION_CODE

Joe Eloff (2):
      Staging: dt3155: Change include to linux header
      Staging: dt3155: Fixed all printk warnings found by checkpatch.pl

Joe Perches (3):
      Staging: otus: TODO: Don't bother, for documentation purposes only
      Staging: batman-adv: Convert MAC_FMT to %pM
      Staging: Remove unnecessary casts of private_data

John Sheehan (4):
      Staging: comedi: fix code style errors in unioxx5.c
      Staging: comedi: fix code warnings in s626.c
      Staging: comedi: fix code style errors in s626.c
      Staging: comedi: fix code warnings in s626.c

Jonathan Cameron (29):
      Staging: iio: Add mailing list to the TODO file.
      staging:iio:max1363 use device_id instead of searching on name again
      staging:iio:max1363 trivial code and comment cleanups.
      staging:iio:lis3l02dq cleanups
      staging:iio:kxsd9 remove unnecessary includes
      staging:iio: Remove used iio_work_cont definition and all references
      staging:iio: Remove unnecessary event_idr and all references
      staging:iio: Code cleanups
      staging:iio: Fix IIO_EVENT_ATTR initialization of list head
      staging:iio: tsl2563 abi fixes and interrupt handling
      staging:iio: Add ability to have event attributes with awkward names
      staging:iio:max1363 add theshold event support
      staging: iio: Use kasprintf to allocate and fill trig->name
      staging: iio: Add and convert drivers to use iio_alloc_pollfunc
      staging: iio: Add iio_triggered_ring postenable and predisable + use in drivers
      staging: iio: remove timestamp field from trigger and pass instead through pollfuncs
      staging: iio: replace combine_8_to_16 with be16_to_cpup where possible.
      staging: iio: imu: allow adis16300 and adis16400 to build without ring buffer support.
      staging: iio: Add stubs for iio_ring_buffer_[un]register and equivalent driver stubs
      staging: iio: Fix scan_element naming issue
      staging: iio: Make extensive use of iio_sw_ring_preenable
      staging: iio: Add iio_sw_ring_helper_state and functions to cover common case.
      staging: iio: lis3l02dq: use iio_sw_ring_helper_state and funcs
      staging: iio: iio_sw_ring_helper_state - add dummy case for no buffer builds.
      staging: iio: lis3l02dq add a thresh_timestamp field to state for no ring case
      staging: iio: adis16350 add dummy ring functions for no ring build case
      staging: iio: ring_sw Add select of triggers to avoid build issue.
      staging: iio: ring_sw remove unnecessary function stub.
      staging: iio: ring_sw Fix pointer arithmetic for 64bit arches by using phys_addr_t

Julia Lawall (2):
      Staging: vme: bridges: Add missing unlocks
      Staging: dream: camera: Use memdup_user

Karl Relton (1):
      Staging: wlan-ng: Switch from wext to cfg80211

Kulikov Vasiliy (36):
      Staging: vt6655: use for_each_pci_dev()
      Staging: comedi: use for_each_pci_dev()
      staging: slicoss: Change return codes to -EYYY.
      staging: slicoss: Remove STATUS_XXX defines.
      staging: slicoss: error handling with goto
      staging: slicoss: error handling with goto
      Staging: otus: use ARRAY_SIZE
      Staging: otus: use ARRAY_SIZE
      Staging: rtl8192e: use ARRAY_SIZE
      Staging: rtl8192u: use ARRAY_SIZE
      Staging: winbond: use ARRAY_SIZE
      Staging: wlags49_h2: use ARRAY_SIZE
      Staging: otus: use ARRAY_SIZE
      Staging: otus: wrap_sec: remove casts from void*
      Staging: comedi: pcm3724: remove casts from void*
      Staging: crystalhd_lnx: remove casts from void*
      Staging: dream: pmem: remove casts from void*
      Staging: rt2860: rtmp_timer: remove casts from void*
      Staging: rt2860: rt_linux: remove casts from void*
      Staging: rt2860: usb_main_dev: remove casts from void*
      Staging: wlags49_h2: wl_profile: remove casts from void*
      Staging: wlags49_h2: wl_pci: remove casts from void*
      Staging: wlags49_h2: wl_netdev: remove casts from void*
      Staging: vme: vme_tsi148: remove casts from void*
      Staging: vme: vme_ca91cx42: remove casts from void*
      staging: tidspbridge: check kmalloc() result
      Staging: line6: fix leaks in line6_probe()
      staging: usbip: fix memory leak
      Staging: panel: fix memory leak
      staging: msm: formatting of pointers in printk()
      staging: comedi: formatting of pointers in printk()
      staging: hv: check kzalloc() result
      staging: octeon: check request_irq() return value
      staging: otus: check kmalloc() return value
      staging: panel: fix error path
      staging: rtl8192su: check whether requests succeeded

Ky Srinivasan (2):
      x86: Export the symbol ms_hyperv
      Staging: hyperv: add clocksource driver

Larry Finger (1):
      staging: rt2870: Add USB ID for Belkin F6D4050 v2

Lars Lindley (1):
      Staging: et131x: Small format/style tidyups

Linus Lüssing (4):
      Staging: batman-adv: Adding netfilter-bridge hooks
      Staging: batman-adv: permit setting ogm interval to JITTER*2
      Staging: batman-adv: Avoid rounding issues for local hna timeout
      Staging: batman-adv: Add last-seen in originator table

Marek Lindner (9):
      Staging: batman-adv: remove redundant struct declaration
      Staging: batman-adv: Add information about batman-adv sysfs entries
      Staging: batman-adv: convert all sysfs files to single value files
      Staging: batman-adv: remove superfluous hint to "translation table"
      Staging: batman-adv: replace manual calculation by msecs_to_jiffies() for better readability
      Staging: batman-adv: adapting source version to revised versioning scheme
      Staging: batman-adv: Add sysfs abi documentation about bonding
      Staging: batman-adv: fix early debugfs deinitialization
      Staging: batman-adv: add routing debug log accessible via debugfs

Marin Mitov (1):
      Staging: dt3155v4l: correcting a pointer mismatch bug and cleanups

Mark (4):
      Staging: comedi: Coding style cleanups in adv_pci_dio.c
      Staging: comedi: Cleanup adv_pci1710.c from checkpatch.pl
      Staging: comedi: Cleanup on dmm32at.c from checkpatch.pl
      Staging: comedi: Cleanup style issues in adl_pci9111.c

Mark Rankilor (2):
      Staging: comedi: Checkpatch cleanups in adl_pci9111.c
      Staging: comedi: Fixed long lines in gsc_hpdi.c

Matthias Brugger (2):
      Staging: adis16255: missing spacess in log messages added
      Staging: IIO: typo in Documentation/overview.txt

Matti Lammi (2):
      Staging: otus: Removed one unnecessary space
      Staging: memrar: memrar_handler.c: Fixed whitespace and tab warnings

Maurice Dawson (2):
      Staging: comedi: fix printk() coding style issue in ni_labpc.c
      Staging: comedi: fix over 80 character coding style issue in ni_labpc.c

Menon, Nishanth (6):
      staging: tidspbridge: remove GlobalTypes.h
      staging: tidspbridge: replace CONST with c standard const
      staging: tidspbridge: remove IN modifier
      staging: tidspbridge: remove OPTIONAL
      staging: tidspbridge: remove OUT define
      staging: tidspbridge: remove dbdefs.h

Mike Frysinger (3):
      Staging: iio: standardize kconfig/makefile spacing/style
      Staging: iio: kill off spurious semicolons
      Staging: iio: pull in slab.h for kmalloc funcs

Mike Gilks (1):
      staging: rtl8192u: fix checkpatch.pl issues to line 514

Mike McCormack (9):
      staging: rtl8192e: Make some static structs const
      staging: rtl8192e: Make static variables const
      staging: rtl8192e: Make functions static
      staging: rtl8192e: Make structs const, move prototypes to top
      staging: rtl8192e: Delete unused code
      staging: rtl8192e: Remove macro already in the kernel
      staging: rtl8192e: Remove useless debug code
      staging: rtl8192e: Make arrays const
      staging: rtl8192e: Delete some redundant code

Mike Thomas (3):
      Staging: easycap: Add dependencies to Kconfig
      Staging: easycap: Replace some global variables
      Staging: easycap: Upsample microphone audio

Nanakos Chrysostomos (3):
      Staging: vme: devices: vme_user.c: Fix checkpatch.pl issues.
      Staging: dream: pmem.c: Fix checkpatch.pl issues.
      Staging: dt3155: dt3155_isr.c: Fix checkpatch.pl issues.

Naveen Jain (3):
      Staging: ti-st: cleanup sysfs code
      Staging: ti-st: add version info to sysfs
      Staging: ti-st: fix protocol counting

Neil Leeder (1):
      staging: msm: remove video drivers for obsolete platforms

Neil Munro (1):
      Staging: RT2860: Cleaned all bar one in chlist.h

Niadh (2):
      Staging: RT2860 Fixed all errors in mlme.h and all but one in rtmp.h.
      Staging: RT2860: Fixed everything in ap.h.

Nishanth Menon (5):
      staging: tidspbridge: remove custom TRUE FALSE
      staging: tidspbridge: no need for custom NULL
      staging: tidspbridge: remove std.h
      staging: tidspbridge: remove custom typedef reg_uword32
      staging: tidspbridge: remove RET_OK RET_FAIL

Nitin Gupta (4):
      Staging: ramzswap: Support generic I/O requests
      Staging: Rename ramzswap files to zram
      Staging: zram: Rename ramzswap to zram in code
      Staging: zram: Rename ramzswap to zram in documentation

Ohad Ben-Cohen (1):
      staging: ti dspbridge: add TODO file

Omar Ramirez Luna (10):
      staging: ti dspbridge: add driver documentation
      staging: ti dspbridge: add core driver sources
      staging: ti dspbridge: add platform manager code
      staging: ti dspbridge: add resource manager
      staging: ti dspbridge: add MMU support
      staging: ti dspbridge: add generic utilities
      staging: ti dspbridge: add services
      staging: ti dspbridge: add DOFF binaries loader
      staging: ti dspbridge: add header files
      staging: ti dspbridge: enable driver building

Ossama Othman (2):
      memrar: Address kernel oops during resource cleanup
      memrar: Updated maintainer contact information

Otavio Salvador (1):
      Staging: vt6656: fix up built-in compilation together with rt2870

Pavan Savoy (10):
      Staging: Update TI-ST's TODO
      Staging: ti-st: Update TODO
      Staging: ti-st: remove global references
      Staging: ti-st: make use of linux err codes
      Staging: ti-st: smarten, reduce logs
      Staging: ti-st: cleanup code comments
      Staging: ti-st: give proto drivers context
      Staging: ti-st: mv sysfs entries to debugfs
      Staging: ti-st: update ABI and TODO
      Staging: ti-st: update TODO

Peter Huewe (1):
      Staging: panel: Prevent double-calling of parport_release - fix oops.

Prashant P. Shah (4):
      Staging: wl_cs.c: fixed space style issues in wl_cs.c
      Staging: wl_cs.c: converted space to tabs in wl_cs.c
      Staging: wl_cs.c: fixed invalid UTF-8 style issues in wl_cs.c
      Staging: wl_cs.c: fixed style issues in wl_cs.c

R.M. Thomas (1):
      Staging: easycap: add easycap driver

Randy Dunlap (8):
      Staging: zram: fix build errors, depends on BLOCK
      Staging: fix wlan-ng depends
      Staging: solo: depends on SND
      Staging: solo: add delay.h header
      Staging: batman-adv: don't use default init_module/cleanup_module function names
      Staging: dt3155: don't use default init_module/cleanup_module function names
      Staging: line6: needs to select SND_PCM
      Staging: quickstart: depends on INPUT

Rene Sapiens (17):
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: fix compilation error
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: Rename words with camel case.
      staging: ti dspbridge: Rename words with camel case
      staging: ti dspbridge: make variables in prototypes match within functions definitions

Roel Van Nyen (1):
      Staging: vt6656: Remove PUINT from ttype.h

Samuel Ortiz (3):
      Staging: rtl8192e: Do not mess with carrier settings while scanning
      Staging: rtl8192e: Do not send NULL BSSID events when not associated
      Staging: rtl8192e: Do not autoconnect based on probe response

Samuel Richardson (1):
      Staging: comedi: fixed brace coding style issue in ni_tio.c

Scott Kidder (3):
      Staging: otus: fix style issues in zdusb.c
      Staging: cx25821: added KERN_ facility levels
      Staging: crystalhd: removed kfree(NULL) checks

Sebastian Andrzej Siewior (2):
      block/spectra: rename nand_release()
      block/spectra: use do_div() for 64bit divs

Shubhrajyoti D (1):
      Staging: iio: add digital compass hmc5843 driver

Simon Wunderlich (6):
      Staging: batman-adv: convert vis_interval into define
      Staging: batman-adv: Add release information for version 2010.0.0
      Staging: batman-adv: 32bit sequence number and TTL for broadcasts
      Staging: batman-adv: Add bonding functionality
      Staging: batman-adv: bonding and interface alternating
      Staging: batman-adv: Lower resolution for timeouts

Stefan Lippers-Hollmann (1):
      Staging: rt3070: remove dead code

Sven Eckelmann (10):
      Staging: batman-adv: Move device for icmp injection to debugfs
      Staging: batman-adv: Move tables from sysfs to debugfs
      Staging: batman-adv: Mark locally used symbols as static
      Staging: batman-adv: Ignore debugfs on kernels without debugfs support
      Staging: batman-adv: Add include guards to all header files
      Staging: batman-adv: Allow to build it inside the kernel
      Staging: batman-adv: Remove dependency to PROCFS
      Staging: batman-adv: Move printk to simplified macros
      Staging: batman-adv: Don't increment stats of foreign device
      Staging: batman-adv: Update TODO with new points from review

Timofey Trofimov (2):
      Staging: winbond: fix some checkpatch.pl issues in phy_calibration.c
      Staging: vt6656: fix coding style issues in 80211mgr.c

Tobias Klauser (1):
      Staging: hv: Storage class should be before const qualifier

Uwe Kleine-König (4):
      Staging: vt665*: fix typos concerning "management"
      staging/trivial: fix typos concerning "initiali[zs]e"
      Staging: usbip: fix typos concerning "sequential"
      Staging: fix typos concerning "address"

Wu Zhangjin (1):
      staging: sm7xx: Fixup of the section mismatch

