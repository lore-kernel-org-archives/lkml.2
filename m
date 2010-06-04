Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0FDUp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:45:29 -0400
Received: from kroah.org ([198.145.64.141]:43907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab0FDUpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:45:05 -0400
Date: Fri, 4 Jun 2010 13:44:55 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes and new drivers for 2.6.35-git
Message-ID: <20100604204455.GD19761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of bugfixes for the drivers/staging tree, as well as 3
new stand-alone drivers.  The new drivers kind of obscure the diffstat
showing the other fixes due to their size.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                            |    6 +
 drivers/staging/Makefile                           |    3 +
 drivers/staging/adis16255/Kconfig                  |    2 +-
 drivers/staging/adis16255/adis16255.c              |    4 +-
 drivers/staging/batman-adv/device.c                |    2 +-
 drivers/staging/batman-adv/main.c                  |    5 +-
 drivers/staging/batman-adv/send.c                  |   24 +-
 drivers/staging/comedi/Kconfig                     |   81 +-
 drivers/staging/comedi/comedi_fops.c               |   44 +-
 drivers/staging/comedi/drivers/Makefile            |    4 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   14 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |    2 +
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_1564.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_1710.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_2016.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_3001.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_3200.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_3300.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |    2 +
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  180 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |   35 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c         |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |    3 +-
 drivers/staging/dt3155/allocator.c                 |    4 +-
 drivers/staging/iio/Documentation/iio_utils.h      |    3 +-
 drivers/staging/iio/ring_sw.c                      |    2 +-
 drivers/staging/mrst-touchscreen/Kconfig           |    7 +
 drivers/staging/mrst-touchscreen/Makefile          |    3 +
 drivers/staging/mrst-touchscreen/TODO              |    2 +
 drivers/staging/mrst-touchscreen/intel-mid-touch.c |  864 ++
 drivers/staging/msm/Kconfig                        |  134 +
 drivers/staging/msm/Makefile                       |   93 +
 drivers/staging/msm/TODO                           |    3 +
 drivers/staging/msm/ebi2_l2f.c                     |  569 ++
 drivers/staging/msm/ebi2_lcd.c                     |  250 +
 drivers/staging/msm/ebi2_tmd20.c                   | 1122 ++
 drivers/staging/msm/hdmi_sii9022.c                 |  248 +
 drivers/staging/msm/lcdc.c                         |  239 +
 drivers/staging/msm/lcdc_external.c                |   54 +
 drivers/staging/msm/lcdc_gordon.c                  |  446 +
 drivers/staging/msm/lcdc_grapefruit.c              |   60 +
 drivers/staging/msm/lcdc_panel.c                   |   88 +
 drivers/staging/msm/lcdc_prism.c                   |   64 +
 drivers/staging/msm/lcdc_sharp_wvga_pt.c           |  290 +
 drivers/staging/msm/lcdc_st15.c                    |  237 +
 drivers/staging/msm/lcdc_st1_wxga.c                |   54 +
 drivers/staging/msm/lcdc_toshiba_wvga_pt.c         |  374 +
 drivers/staging/msm/lcdc_wxga.c                    |   56 +
 drivers/staging/msm/logo.c                         |   98 +
 drivers/staging/msm/mddi.c                         |  375 +
 drivers/staging/msm/mddi_ext.c                     |  320 +
 drivers/staging/msm/mddi_ext_lcd.c                 |   91 +
 drivers/staging/msm/mddi_prism.c                   |  114 +
 drivers/staging/msm/mddi_sharp.c                   |  892 ++
 drivers/staging/msm/mddi_toshiba.c                 | 1741 ++++
 drivers/staging/msm/mddi_toshiba.h                 |   52 +
 drivers/staging/msm/mddi_toshiba_vga.c             |  136 +
 drivers/staging/msm/mddi_toshiba_wvga.c            |   63 +
 drivers/staging/msm/mddi_toshiba_wvga_pt.c         |   64 +
 drivers/staging/msm/mddihost.c                     |  377 +
 drivers/staging/msm/mddihost.h                     |  225 +
 drivers/staging/msm/mddihost_e.c                   |   63 +
 drivers/staging/msm/mddihosti.c                    | 2239 ++++
 drivers/staging/msm/mddihosti.h                    |  547 +
 drivers/staging/msm/mdp.c                          | 1113 ++
 drivers/staging/msm/mdp.h                          |  695 ++
 drivers/staging/msm/mdp4.h                         |  352 +
 drivers/staging/msm/mdp4_debugfs.c                 |  181 +
 drivers/staging/msm/mdp4_overlay.c                 | 1259 +++
 drivers/staging/msm/mdp4_overlay_lcdc.c            |  313 +
 drivers/staging/msm/mdp4_overlay_mddi.c            |  254 +
 drivers/staging/msm/mdp4_util.c                    | 1686 +++
 drivers/staging/msm/mdp_cursor.c                   |  104 +
 drivers/staging/msm/mdp_dma.c                      |  561 +
 drivers/staging/msm/mdp_dma_lcdc.c                 |  379 +
 drivers/staging/msm/mdp_dma_s.c                    |  139 +
 drivers/staging/msm/mdp_dma_tv.c                   |  142 +
 drivers/staging/msm/mdp_hw_init.c                  |  720 ++
 drivers/staging/msm/mdp_ppp.c                      | 1502 +++
 drivers/staging/msm/mdp_ppp_dq.c                   |  347 +
 drivers/staging/msm/mdp_ppp_dq.h                   |   86 +
 drivers/staging/msm/mdp_ppp_v20.c                  | 2486 +++++
 drivers/staging/msm/mdp_ppp_v31.c                  |  828 ++
 drivers/staging/msm/mdp_vsync.c                    |  389 +
 drivers/staging/msm/memory.c                       |  214 +
 drivers/staging/msm/memory_ll.h                    |   61 +
 drivers/staging/msm/msm_fb.c                       | 2354 +++++
 drivers/staging/msm/msm_fb.h                       |  174 +
 drivers/staging/msm/msm_fb_bl.c                    |   79 +
 drivers/staging/msm/msm_fb_def.h                   |  201 +
 drivers/staging/msm/msm_fb_panel.c                 |  136 +
 drivers/staging/msm/msm_fb_panel.h                 |  145 +
 drivers/staging/msm/msm_mdp.h                      |  245 +
 drivers/staging/msm/staging-devices.c              |  323 +
 drivers/staging/msm/tv_ntsc.c                      |  163 +
 drivers/staging/msm/tv_pal.c                       |  213 +
 drivers/staging/msm/tvenc.c                        |  295 +
 drivers/staging/msm/tvenc.h                        |  117 +
 drivers/staging/phison/Kconfig                     |    2 +-
 drivers/staging/rt2860/sta_ioctl.c                 |    2 +
 drivers/staging/sep/sep_driver.c                   |   52 +-
 drivers/staging/vme/bridges/vme_ca91cx42.c         |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c           |    2 +-
 drivers/staging/wlags49_h2/Kconfig                 |   12 +-
 drivers/staging/wlags49_h25/Kconfig                |   12 +-
 drivers/staging/xgifb/Kconfig                      |   11 +
 drivers/staging/xgifb/Makefile                     |    4 +
 drivers/staging/xgifb/TODO                         |   15 +
 drivers/staging/xgifb/XGI.h                        |   10 +
 drivers/staging/xgifb/XGI_accel.c                  |  596 ++
 drivers/staging/xgifb/XGI_accel.h                  |  511 +
 drivers/staging/xgifb/XGI_main.h                   | 1023 ++
 drivers/staging/xgifb/XGI_main_26.c                | 3773 +++++++
 drivers/staging/xgifb/XGIfb.h                      |  215 +
 drivers/staging/xgifb/osdef.h                      |  153 +
 drivers/staging/xgifb/vb_def.h                     | 1017 ++
 drivers/staging/xgifb/vb_ext.c                     | 1370 +++
 drivers/staging/xgifb/vb_ext.h                     |   32 +
 drivers/staging/xgifb/vb_init.c                    | 3444 +++++++
 drivers/staging/xgifb/vb_init.h                    |    7 +
 drivers/staging/xgifb/vb_setmode.c                 |10736 ++++++++++++++++++++
 drivers/staging/xgifb/vb_setmode.h                 |   40 +
 drivers/staging/xgifb/vb_struct.h                  |  534 +
 drivers/staging/xgifb/vb_table.h                   | 4406 ++++++++
 drivers/staging/xgifb/vb_util.c                    |  263 +
 drivers/staging/xgifb/vb_util.h                    |   15 +
 drivers/staging/xgifb/vgatypes.h                   |  325 +
 135 files changed, 59831 insertions(+), 113 deletions(-)
 create mode 100644 drivers/staging/mrst-touchscreen/Kconfig
 create mode 100644 drivers/staging/mrst-touchscreen/Makefile
 create mode 100644 drivers/staging/mrst-touchscreen/TODO
 create mode 100644 drivers/staging/mrst-touchscreen/intel-mid-touch.c
 create mode 100644 drivers/staging/msm/Kconfig
 create mode 100644 drivers/staging/msm/Makefile
 create mode 100644 drivers/staging/msm/TODO
 create mode 100644 drivers/staging/msm/ebi2_l2f.c
 create mode 100644 drivers/staging/msm/ebi2_lcd.c
 create mode 100644 drivers/staging/msm/ebi2_tmd20.c
 create mode 100644 drivers/staging/msm/hdmi_sii9022.c
 create mode 100644 drivers/staging/msm/lcdc.c
 create mode 100644 drivers/staging/msm/lcdc_external.c
 create mode 100644 drivers/staging/msm/lcdc_gordon.c
 create mode 100644 drivers/staging/msm/lcdc_grapefruit.c
 create mode 100644 drivers/staging/msm/lcdc_panel.c
 create mode 100644 drivers/staging/msm/lcdc_prism.c
 create mode 100644 drivers/staging/msm/lcdc_sharp_wvga_pt.c
 create mode 100644 drivers/staging/msm/lcdc_st15.c
 create mode 100644 drivers/staging/msm/lcdc_st1_wxga.c
 create mode 100644 drivers/staging/msm/lcdc_toshiba_wvga_pt.c
 create mode 100644 drivers/staging/msm/lcdc_wxga.c
 create mode 100644 drivers/staging/msm/logo.c
 create mode 100644 drivers/staging/msm/mddi.c
 create mode 100644 drivers/staging/msm/mddi_ext.c
 create mode 100644 drivers/staging/msm/mddi_ext_lcd.c
 create mode 100644 drivers/staging/msm/mddi_prism.c
 create mode 100644 drivers/staging/msm/mddi_sharp.c
 create mode 100644 drivers/staging/msm/mddi_toshiba.c
 create mode 100644 drivers/staging/msm/mddi_toshiba.h
 create mode 100644 drivers/staging/msm/mddi_toshiba_vga.c
 create mode 100644 drivers/staging/msm/mddi_toshiba_wvga.c
 create mode 100644 drivers/staging/msm/mddi_toshiba_wvga_pt.c
 create mode 100644 drivers/staging/msm/mddihost.c
 create mode 100644 drivers/staging/msm/mddihost.h
 create mode 100644 drivers/staging/msm/mddihost_e.c
 create mode 100644 drivers/staging/msm/mddihosti.c
 create mode 100644 drivers/staging/msm/mddihosti.h
 create mode 100644 drivers/staging/msm/mdp.c
 create mode 100644 drivers/staging/msm/mdp.h
 create mode 100644 drivers/staging/msm/mdp4.h
 create mode 100644 drivers/staging/msm/mdp4_debugfs.c
 create mode 100644 drivers/staging/msm/mdp4_overlay.c
 create mode 100644 drivers/staging/msm/mdp4_overlay_lcdc.c
 create mode 100644 drivers/staging/msm/mdp4_overlay_mddi.c
 create mode 100644 drivers/staging/msm/mdp4_util.c
 create mode 100644 drivers/staging/msm/mdp_cursor.c
 create mode 100644 drivers/staging/msm/mdp_dma.c
 create mode 100644 drivers/staging/msm/mdp_dma_lcdc.c
 create mode 100644 drivers/staging/msm/mdp_dma_s.c
 create mode 100644 drivers/staging/msm/mdp_dma_tv.c
 create mode 100644 drivers/staging/msm/mdp_hw_init.c
 create mode 100644 drivers/staging/msm/mdp_ppp.c
 create mode 100644 drivers/staging/msm/mdp_ppp_dq.c
 create mode 100644 drivers/staging/msm/mdp_ppp_dq.h
 create mode 100644 drivers/staging/msm/mdp_ppp_v20.c
 create mode 100644 drivers/staging/msm/mdp_ppp_v31.c
 create mode 100644 drivers/staging/msm/mdp_vsync.c
 create mode 100644 drivers/staging/msm/memory.c
 create mode 100644 drivers/staging/msm/memory_ll.h
 create mode 100644 drivers/staging/msm/msm_fb.c
 create mode 100644 drivers/staging/msm/msm_fb.h
 create mode 100644 drivers/staging/msm/msm_fb_bl.c
 create mode 100644 drivers/staging/msm/msm_fb_def.h
 create mode 100644 drivers/staging/msm/msm_fb_panel.c
 create mode 100644 drivers/staging/msm/msm_fb_panel.h
 create mode 100644 drivers/staging/msm/msm_mdp.h
 create mode 100644 drivers/staging/msm/staging-devices.c
 create mode 100644 drivers/staging/msm/tv_ntsc.c
 create mode 100644 drivers/staging/msm/tv_pal.c
 create mode 100644 drivers/staging/msm/tvenc.c
 create mode 100644 drivers/staging/msm/tvenc.h
 create mode 100644 drivers/staging/xgifb/Kconfig
 create mode 100644 drivers/staging/xgifb/Makefile
 create mode 100644 drivers/staging/xgifb/TODO
 create mode 100644 drivers/staging/xgifb/XGI.h
 create mode 100644 drivers/staging/xgifb/XGI_accel.c
 create mode 100644 drivers/staging/xgifb/XGI_accel.h
 create mode 100644 drivers/staging/xgifb/XGI_main.h
 create mode 100644 drivers/staging/xgifb/XGI_main_26.c
 create mode 100644 drivers/staging/xgifb/XGIfb.h
 create mode 100644 drivers/staging/xgifb/osdef.h
 create mode 100644 drivers/staging/xgifb/vb_def.h
 create mode 100644 drivers/staging/xgifb/vb_ext.c
 create mode 100644 drivers/staging/xgifb/vb_ext.h
 create mode 100644 drivers/staging/xgifb/vb_init.c
 create mode 100644 drivers/staging/xgifb/vb_init.h
 create mode 100644 drivers/staging/xgifb/vb_setmode.c
 create mode 100644 drivers/staging/xgifb/vb_setmode.h
 create mode 100644 drivers/staging/xgifb/vb_struct.h
 create mode 100644 drivers/staging/xgifb/vb_table.h
 create mode 100644 drivers/staging/xgifb/vb_util.c
 create mode 100644 drivers/staging/xgifb/vb_util.h
 create mode 100644 drivers/staging/xgifb/vgatypes.h

---------------

Alexander Kurz (3):
      Staging: comedi: fix 8255 and DAS08 Kconfig dependancies.
      Staging: comedi: fixing ni_tio to mite PCI dependancy
      Staging: comedi: fixing ni_labpc to mite dependancy

Barry Song (1):
      Staging: iio-utils: fix memory overflow for dynamically allocateded memory to hold filename

Dan Carpenter (2):
      Staging: rc2860: return -EFAULT on copy_to_user errors
      Staging: sep: return -EFAULT on copy_to_user errors

Henk de Groot (1):
      Staging: wlags49_h2, wlags49_h25: fixed Kconfig dependencies

Ian Abbott (7):
      Staging: comedi: Give the addi_apci_* drivers different driver names
      Staging: comedi: addi-data: don't overwrite name for request_irq()
      Staging: comedi: adv_pci_dio: Support Advantech PCI-1735U
      Staging: comedi: amplc_dio200: Protect counter subdevice with spinlock
      Staging: comedi: don't write to buffer if command finished
      Staging: comedi: COMEDI_BUFINFO with no async - report no bytes read or written
      Staging: comedi: For COMEDI_BUFINFO, check access to command

Julia Lawall (2):
      staging: Use GFP_ATOMIC when a lock is held
      Staging: Eliminate a NULL pointer dereference

Marek Lindner (1):
      Staging: batman-adv: fix rogue packets on shutdown

Martin Homuth-Rosemann (1):
      Staging: comedi - correct parameter gainlkup for DAQCard-6024E in driver ni_mio_cs.c

Mike Frysinger (2):
      Staging: adis16255: fix typo in Kconfig
      Staging: adis16255: add proper section markings to hotplug funcs

Randy Dunlap (1):
      Staging: phison: depends on ATA_BMDMA

Sreedhara DS (1):
      Staging: mid: Intel MID touch screen driver

Stepan Moskovchenko (1):
      Staging: add MSM framebuffer driver

Sven Eckelmann (3):
      Staging: batman-adv: Call unregister_netdev on failures to get rtnl lock
      Staging: batman-adv: Don't call free_netdev twice
      Staging: batman-adv: Don't allocate icmp packet with GFP_KERNEL

apatard@mandriva.com (1):
      staging: Add framebuffer driver for XGI chipsets

