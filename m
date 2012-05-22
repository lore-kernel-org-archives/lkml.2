Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2EVNRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:17:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37787 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2EVNRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:17:00 -0400
Date: Tue, 22 May 2012 06:16:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.5-rc1
Message-ID: <20120522131655.GA15349@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.5-rc1

for you to fetch changes up to 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

----------------------------------------------------------------
USB 3.5-rc1 pull request

Here is the big USB 3.5-rc1 pull request for the 3.5-rc1 merge window.

It's touches a lot of different parts of the kernel, all USB drivers,
due to some API cleanups (getting rid of the ancient err() macro) and
some changes that are needed for USB 3.0 power management updates.

There are also lots of new drivers, pimarily gadget, but others as well.
We deleted a staging driver, which was nice, and finally dropped the
obsolete usbfs code, which will make Al happy to never have to touch
that again.

There were some build errors in the tree that linux-next found a few
days ago, but those were fixed by the most recent changes (all were due
to us not building with CONFIG_PM disabled.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------

 Documentation/ABI/testing/sysfs-bus-usb            |   15 +
 Documentation/devicetree/bindings/usb/isp1301.txt  |   25 +
 .../devicetree/bindings/usb/lpc32xx-udc.txt        |   28 +
 Documentation/devicetree/bindings/usb/ohci-nxp.txt |   24 +
 .../devicetree/bindings/usb/spear-usb.txt          |   39 +
 Documentation/usb/functionfs.txt                   |   67 +
 MAINTAINERS                                        |   14 +
 arch/arm/mach-exynos/Kconfig                       |    3 +
 arch/arm/mach-exynos/include/mach/irqs.h           |    1 +
 arch/arm/mach-exynos/include/mach/map.h            |    4 +
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    3 +
 arch/arm/mach-exynos/mach-nuri.c                   |   10 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |   11 +
 arch/arm/mach-exynos/setup-usb-phy.c               |  100 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    2 +-
 arch/arm/mach-s5pv210/Kconfig                      |    1 +
 arch/arm/mach-s5pv210/mach-goni.c                  |    6 +
 arch/arm/plat-samsung/devs.c                       |    2 +-
 .../arm/plat-samsung/include/plat/regs-usb-hsotg.h |  379 ---
 drivers/acpi/glue.c                                |    2 +
 drivers/acpi/utils.c                               |   30 +
 drivers/bcma/scan.c                                |   19 +-
 drivers/bluetooth/ath3k.c                          |    1 +
 drivers/bluetooth/bcm203x.c                        |    1 +
 drivers/bluetooth/bfusb.c                          |    1 +
 drivers/bluetooth/bpa10x.c                         |    1 +
 drivers/bluetooth/btusb.c                          |    1 +
 drivers/hid/usbhid/hid-core.c                      |   65 +-
 drivers/hid/usbhid/usbmouse.c                      |    7 +-
 drivers/input/joystick/iforce/iforce-main.c        |    3 +-
 drivers/input/joystick/iforce/iforce-packets.c     |   16 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   18 +-
 drivers/input/joystick/iforce/iforce.h             |    1 +
 drivers/input/joystick/xpad.c                      |   35 +-
 drivers/input/misc/cm109.c                         |   33 +-
 drivers/input/misc/keyspan_remote.c                |   23 +-
 drivers/input/misc/powermate.c                     |   13 +-
 drivers/input/misc/yealink.c                       |   31 +-
 drivers/input/mouse/appletouch.c                   |   59 +-
 drivers/input/mouse/bcm5974.c                      |   24 +-
 drivers/input/tablet/acecad.c                      |   15 +-
 drivers/input/tablet/aiptek.c                      |   28 +-
 drivers/input/tablet/gtco.c                        |  110 +-
 drivers/input/tablet/kbtab.c                       |   15 +-
 drivers/input/tablet/wacom_sys.c                   |   11 +-
 drivers/input/tablet/wacom_wac.c                   |   16 +-
 drivers/input/touchscreen/usbtouchscreen.c         |   77 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |    1 +
 drivers/isdn/gigaset/usb-gigaset.c                 |    1 +
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    1 +
 drivers/isdn/hisax/hfc_usb.c                       |    1 +
 drivers/isdn/hisax/st5481_init.c                   |    1 +
 drivers/media/video/gspca/ov534_9.c                |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |    4 +-
 drivers/net/irda/irda-usb.c                        |    2 +-
 drivers/net/irda/kingsun-sir.c                     |   42 +-
 drivers/net/irda/ks959-sir.c                       |   31 +-
 drivers/net/irda/ksdazzle-sir.c                    |   46 +-
 drivers/net/irda/stir4200.c                        |    6 +-
 drivers/net/usb/asix.c                             |    1 +
 drivers/net/usb/catc.c                             |   26 +-
 drivers/net/usb/cdc-phonet.c                       |    1 +
 drivers/net/usb/cdc_eem.c                          |    1 +
 drivers/net/usb/cdc_ether.c                        |    1 +
 drivers/net/usb/cdc_ncm.c                          |    1 +
 drivers/net/usb/cdc_subset.c                       |    1 +
 drivers/net/usb/cx82310_eth.c                      |    1 +
 drivers/net/usb/dm9601.c                           |    1 +
 drivers/net/usb/gl620a.c                           |    1 +
 drivers/net/usb/hso.c                              |    1 +
 drivers/net/usb/int51x1.c                          |    1 +
 drivers/net/usb/ipheth.c                           |   35 +-
 drivers/net/usb/kalmia.c                           |    3 +-
 drivers/net/usb/kaweth.c                           |   64 +-
 drivers/net/usb/lg-vl600.c                         |    1 +
 drivers/net/usb/mcs7830.c                          |    1 +
 drivers/net/usb/net1080.c                          |    1 +
 drivers/net/usb/pegasus.c                          |    1 +
 drivers/net/usb/plusb.c                            |    1 +
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/usb/rndis_host.c                       |    1 +
 drivers/net/usb/rtl8150.c                          |   18 +-
 drivers/net/usb/sierra_net.c                       |    1 +
 drivers/net/usb/smsc75xx.c                         |    1 +
 drivers/net/usb/smsc95xx.c                         |    1 +
 drivers/net/usb/zaurus.c                           |    1 +
 drivers/net/wireless/at76c50x-usb.c                |    3 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    1 +
 drivers/net/wireless/ath/carl9170/usb.c            |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    3 +-
 drivers/net/wireless/libertas/if_usb.c             |    1 +
 drivers/net/wireless/libertas_tf/if_usb.c          |    1 +
 drivers/net/wireless/orinoco/orinoco_usb.c         |    1 +
 drivers/net/wireless/p54/p54usb.c                  |    1 +
 drivers/net/wireless/rndis_wlan.c                  |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c            |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c            |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c              |    1 +
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    1 +
 drivers/net/wireless/zd1201.c                      |    1 +
 drivers/net/wireless/zd1211rw/zd_usb.c             |    1 +
 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/asus_oled/asus_oled.c              |    6 +-
 drivers/staging/ccg/Kconfig                        |   20 +
 drivers/staging/ccg/Makefile                       |    4 +
 drivers/staging/ccg/TODO                           |    6 +
 drivers/staging/ccg/ccg.c                          | 1299 +++++++
 drivers/staging/ccg/sysfs-class-ccg_usb            |  158 +
 drivers/staging/comedi/drivers/dt9812.c            |   16 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    4 +-
 drivers/staging/frontier/alphatrack.c              |   15 +-
 drivers/staging/frontier/tranzport.c               |   16 +-
 drivers/staging/line6/driver.c                     |    5 +-
 drivers/staging/line6/toneport.c                   |    2 +-
 drivers/staging/media/as102/as102_drv.c            |   34 +-
 drivers/staging/media/as102/as102_usb_drv.c        |    7 +-
 drivers/staging/media/easycap/easycap_main.c       |    6 +-
 drivers/staging/media/go7007/go7007.txt            |    1 -
 drivers/staging/media/lirc/lirc_imon.c             |   80 +-
 drivers/staging/media/lirc/lirc_sasem.c            |  100 +-
 drivers/staging/media/lirc/lirc_ttusbir.c          |   13 +-
 drivers/staging/quatech_usb2/Kconfig               |   15 -
 drivers/staging/quatech_usb2/Makefile              |    1 -
 drivers/staging/quatech_usb2/TODO                  |    8 -
 drivers/staging/quatech_usb2/quatech_usb2.c        | 1976 -----------
 drivers/staging/serqt_usb2/serqt_usb2.c            |   79 +-
 drivers/usb/Kconfig                                |    4 +
 drivers/usb/Makefile                               |    2 +
 drivers/usb/atm/cxacru.c                           |   34 +-
 drivers/usb/atm/speedtch.c                         |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |   15 +-
 drivers/usb/atm/usbatm.c                           |   30 +-
 drivers/usb/atm/xusbatm.c                          |    4 -
 drivers/usb/chipidea/Kconfig                       |   32 +
 drivers/usb/chipidea/Makefile                      |   14 +
 drivers/usb/chipidea/bits.h                        |   90 +
 drivers/usb/chipidea/ci.h                          |  313 ++
 drivers/usb/{gadget => chipidea}/ci13xxx_msm.c     |   60 +-
 drivers/usb/{gadget => chipidea}/ci13xxx_pci.c     |  154 +-
 drivers/usb/chipidea/core.c                        |  474 +++
 drivers/usb/chipidea/debug.c                       |  804 +++++
 drivers/usb/chipidea/debug.h                       |   56 +
 drivers/usb/chipidea/host.c                        |  160 +
 drivers/usb/chipidea/host.h                        |   17 +
 drivers/usb/chipidea/udc.c                         | 1809 ++++++++++
 drivers/usb/chipidea/udc.h                         |   93 +
 drivers/usb/class/cdc-acm.c                        |    1 +
 drivers/usb/class/cdc-wdm.c                        |   38 +-
 drivers/usb/class/usblp.c                          |   82 +-
 drivers/usb/core/Kconfig                           |   53 -
 drivers/usb/core/Makefile                          |    2 +-
 drivers/usb/core/devio.c                           |   93 +-
 drivers/usb/core/driver.c                          |  103 +-
 drivers/usb/core/file.c                            |    4 +-
 drivers/usb/core/hcd.c                             |   15 +-
 drivers/usb/core/hub.c                             |  676 +++-
 drivers/usb/core/inode.c                           |  748 -----
 drivers/usb/core/message.c                         |   38 +
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/core/urb.c                             |   21 +
 drivers/usb/core/usb-acpi.c                        |  117 +
 drivers/usb/core/usb.c                             |    9 +-
 drivers/usb/core/usb.h                             |    7 +
 drivers/usb/dwc3/Kconfig                           |    2 +-
 drivers/usb/dwc3/core.c                            |   31 +-
 drivers/usb/dwc3/core.h                            |   40 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   32 +-
 drivers/usb/dwc3/ep0.c                             |  157 +-
 drivers/usb/dwc3/gadget.c                          |  151 +-
 drivers/usb/dwc3/gadget.h                          |    1 +
 drivers/usb/dwc3/host.c                            |   19 +-
 drivers/usb/dwc3/io.h                              |   16 +-
 drivers/usb/gadget/Kconfig                         |   68 +-
 drivers/usb/gadget/Makefile                        |    4 +-
 drivers/usb/gadget/amd5536udc.c                    |   27 +-
 drivers/usb/gadget/amd5536udc.h                    |    1 -
 drivers/usb/gadget/at91_udc.c                      |   77 +-
 drivers/usb/gadget/at91_udc.h                      |    3 -
 drivers/usb/gadget/atmel_usba_udc.c                |   76 +-
 drivers/usb/gadget/atmel_usba_udc.h                |    1 -
 drivers/usb/gadget/ci13xxx_udc.c                   | 2996 -----------------
 drivers/usb/gadget/ci13xxx_udc.h                   |  227 --
 drivers/usb/gadget/composite.c                     |  107 +-
 drivers/usb/gadget/dummy_hcd.c                     |    8 +-
 drivers/usb/gadget/f_fs.c                          |   52 +-
 drivers/usb/gadget/f_hid.c                         |    2 +-
 drivers/usb/gadget/f_loopback.c                    |    4 +-
 drivers/usb/gadget/f_mass_storage.c                |    7 -
 drivers/usb/gadget/f_rndis.c                       |   30 +-
 drivers/usb/gadget/f_sourcesink.c                  |  424 ++-
 drivers/usb/gadget/fsl_qe_udc.c                    |  371 +-
 drivers/usb/gadget/fsl_qe_udc.h                    |    1 -
 drivers/usb/gadget/fsl_udc_core.c                  |   55 +-
 drivers/usb/gadget/fsl_usb2_udc.h                  |   12 +-
 drivers/usb/gadget/fusb300_udc.c                   |    4 +-
 drivers/usb/gadget/fusb300_udc.h                   |    1 -
 drivers/usb/gadget/g_ffs.c                         |  200 +-
 drivers/usb/gadget/g_zero.h                        |    5 +-
 drivers/usb/gadget/gadget_chips.h                  |    3 +
 drivers/usb/gadget/goku_udc.c                      |   32 +-
 drivers/usb/gadget/goku_udc.h                      |    1 -
 drivers/usb/gadget/imx_udc.c                       |   53 +-
 drivers/usb/gadget/langwell_udc.c                  | 3434 -------------------
 drivers/usb/gadget/langwell_udc.h                  |  224 --
 drivers/usb/gadget/lpc32xx_udc.c                   | 3538 ++++++++++++++++++++
 drivers/usb/gadget/m66592-udc.c                    |   10 +-
 drivers/usb/gadget/m66592-udc.h                    |    2 +-
 drivers/usb/gadget/mv_udc.h                        |    1 -
 drivers/usb/gadget/mv_udc_core.c                   |   19 +-
 drivers/usb/gadget/omap_udc.c                      |   19 +-
 drivers/usb/gadget/omap_udc.h                      |    1 -
 drivers/usb/gadget/pch_udc.c                       |   29 +-
 drivers/usb/gadget/printer.c                       |  470 +--
 drivers/usb/gadget/pxa25x_udc.c                    |   26 +-
 drivers/usb/gadget/pxa25x_udc.h                    |    1 -
 drivers/usb/gadget/r8a66597-udc.c                  |   29 +-
 drivers/usb/gadget/r8a66597-udc.h                  |    3 +-
 drivers/usb/gadget/s3c-hsotg.c                     | 1633 +++++----
 drivers/usb/gadget/s3c-hsotg.h                     |  377 +++
 drivers/usb/gadget/s3c-hsudc.c                     |    9 +-
 drivers/usb/gadget/s3c2410_udc.c                   |   14 +-
 drivers/usb/gadget/s3c2410_udc.h                   |    1 -
 drivers/usb/gadget/u_ether.c                       |    8 +-
 drivers/usb/gadget/u_ether.h                       |   46 +-
 drivers/usb/gadget/u_serial.c                      |    4 +-
 drivers/usb/gadget/zero.c                          |   19 +-
 drivers/usb/host/Kconfig                           |   41 +-
 drivers/usb/host/Makefile                          |    2 +
 drivers/usb/host/bcma-hcd.c                        |  335 ++
 drivers/usb/host/ehci-dbg.c                        |    6 +-
 drivers/usb/host/ehci-fsl.c                        |   41 +-
 drivers/usb/host/ehci-fsl.h                        |   13 +-
 drivers/usb/host/ehci-hcd.c                        |   36 +-
 drivers/usb/host/ehci-hub.c                        |   22 +-
 drivers/usb/host/ehci-omap.c                       |   22 +-
 drivers/usb/host/ehci-pci.c                        |    4 +-
 drivers/usb/host/ehci-platform.c                   |    6 +-
 drivers/usb/host/ehci-q.c                          |   19 +-
 drivers/usb/host/ehci-s5p.c                        |    4 +
 drivers/usb/host/ehci-sched.c                      |   55 +-
 drivers/usb/host/ehci-sead3.c                      |  266 ++
 drivers/usb/host/ehci-sh.c                         |    8 +
 drivers/usb/host/ehci-spear.c                      |   36 +-
 drivers/usb/host/ehci-tegra.c                      |   69 +-
 drivers/usb/host/fhci-tds.c                        |    2 +-
 drivers/usb/host/fsl-mph-dr-of.c                   |   41 +
 drivers/usb/host/isp1760-hcd.c                     |    9 +-
 drivers/usb/host/isp1760-if.c                      |    8 +
 drivers/usb/host/ohci-at91.c                       |   16 +-
 drivers/usb/host/ohci-au1xxx.c                     |    3 +-
 drivers/usb/host/ohci-cns3xxx.c                    |    3 +-
 drivers/usb/host/ohci-da8xx.c                      |    2 +
 drivers/usb/host/ohci-dbg.c                        |    4 +-
 drivers/usb/host/ohci-ep93xx.c                     |    9 +-
 drivers/usb/host/ohci-exynos.c                     |    3 +-
 drivers/usb/host/ohci-hcd.c                        |   21 +-
 drivers/usb/host/ohci-nxp.c                        |  173 +-
 drivers/usb/host/ohci-omap.c                       |    5 +-
 drivers/usb/host/ohci-platform.c                   |    4 +-
 drivers/usb/host/ohci-pnx8550.c                    |    3 +-
 drivers/usb/host/ohci-ppc-of.c                     |    5 +-
 drivers/usb/host/ohci-ppc-soc.c                    |    3 +-
 drivers/usb/host/ohci-ps3.c                        |    3 +-
 drivers/usb/host/ohci-pxa27x.c                     |    3 +-
 drivers/usb/host/ohci-s3c2410.c                    |    3 +-
 drivers/usb/host/ohci-sa1111.c                     |    4 +-
 drivers/usb/host/ohci-sh.c                         |    8 +-
 drivers/usb/host/ohci-spear.c                      |   36 +-
 drivers/usb/host/ohci-ssb.c                        |  260 --
 drivers/usb/host/ohci-tmio.c                       |    3 +-
 drivers/usb/host/ohci-xls.c                        |    3 +-
 drivers/usb/host/oxu210hp-hcd.c                    |   13 +-
 drivers/usb/host/pci-quirks.c                      |   32 +-
 drivers/usb/host/r8a66597-hcd.c                    |   20 +-
 drivers/usb/host/ssb-hcd.c                         |  280 ++
 drivers/usb/host/xhci-hub.c                        |   41 +-
 drivers/usb/host/xhci-mem.c                        |   39 +
 drivers/usb/host/xhci-pci.c                        |   14 +
 drivers/usb/host/xhci-ring.c                       |   28 +-
 drivers/usb/host/xhci.c                            |  483 ++-
 drivers/usb/host/xhci.h                            |   17 +-
 drivers/usb/image/mdc800.c                         |   19 +-
 drivers/usb/misc/appledisplay.c                    |   12 +-
 drivers/usb/misc/emi26.c                           |   59 +-
 drivers/usb/misc/emi62.c                           |   62 +-
 drivers/usb/misc/idmouse.c                         |    9 +-
 drivers/usb/misc/iowarrior.c                       |    4 +-
 drivers/usb/misc/ldusb.c                           |   15 +-
 drivers/usb/misc/legousbtower.c                    |   45 +-
 drivers/usb/misc/rio500.c                          |   65 +-
 drivers/usb/misc/usblcd.c                          |   24 +-
 drivers/usb/misc/usbtest.c                         |   17 +-
 drivers/usb/misc/uss720.c                          |   49 +-
 drivers/usb/misc/yurex.c                           |   54 +-
 drivers/usb/musb/Kconfig                           |    8 +-
 drivers/usb/musb/Makefile                          |    1 +
 drivers/usb/musb/cppi_dma.c                        |    1 +
 drivers/usb/musb/musb_core.c                       |    4 +-
 drivers/usb/musb/musb_dsps.c                       |  711 ++++
 drivers/usb/otg/gpio_vbus.c                        |   81 +-
 drivers/usb/otg/twl6030-usb.c                      |    4 +-
 drivers/usb/phy/Kconfig                            |   17 +
 drivers/usb/phy/Makefile                           |    7 +
 drivers/usb/phy/isp1301.c                          |   77 +
 drivers/usb/renesas_usbhs/mod_gadget.c             |   19 +-
 drivers/usb/serial/Kconfig                         |    9 +
 drivers/usb/serial/Makefile                        |    1 +
 drivers/usb/serial/aircable.c                      |   16 +-
 drivers/usb/serial/ark3116.c                       |   36 +-
 drivers/usb/serial/belkin_sa.c                     |   47 +-
 drivers/usb/serial/bus.c                           |    9 +-
 drivers/usb/serial/ch341.c                         |   48 +-
 drivers/usb/serial/console.c                       |    9 +-
 drivers/usb/serial/cp210x.c                        |   32 +-
 drivers/usb/serial/cyberjack.c                     |   27 +-
 drivers/usb/serial/cypress_m8.c                    |   45 +-
 drivers/usb/serial/digi_acceleport.c               |   35 +-
 drivers/usb/serial/empeg.c                         |   13 +-
 drivers/usb/serial/ezusb.c                         |    2 -
 drivers/usb/serial/f81232.c                        |   37 +-
 drivers/usb/serial/ftdi_sio.c                      |   47 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    8 +
 drivers/usb/serial/funsoft.c                       |    9 +-
 drivers/usb/serial/garmin_gps.c                    |   29 +-
 drivers/usb/serial/generic.c                       |   68 +-
 drivers/usb/serial/hp4x.c                          |    9 +-
 drivers/usb/serial/io_edgeport.c                   |    2 +-
 drivers/usb/serial/io_tables.h                     |    7 -
 drivers/usb/serial/io_ti.c                         |   27 +-
 drivers/usb/serial/ipaq.c                          |   52 +-
 drivers/usb/serial/ipw.c                           |   18 +-
 drivers/usb/serial/ir-usb.c                        |   72 +-
 drivers/usb/serial/iuu_phoenix.c                   |   47 +-
 drivers/usb/serial/keyspan.c                       |   53 +-
 drivers/usb/serial/keyspan.h                       |    7 -
 drivers/usb/serial/keyspan_pda.c                   |   17 +-
 drivers/usb/serial/kl5kusb105.c                    |   18 +-
 drivers/usb/serial/kobil_sct.c                     |   19 +-
 drivers/usb/serial/mct_u232.c                      |   33 +-
 drivers/usb/serial/metro-usb.c                     |   92 +-
 drivers/usb/serial/mos7720.c                       |   49 +-
 drivers/usb/serial/mos7840.c                       |  298 +-
 drivers/usb/serial/moto_modem.c                    |    9 +-
 drivers/usb/serial/navman.c                        |   26 +-
 drivers/usb/serial/omninet.c                       |   24 +-
 drivers/usb/serial/opticon.c                       |   53 +-
 drivers/usb/serial/option.c                        |   18 +-
 drivers/usb/serial/oti6858.c                       |   44 +-
 drivers/usb/serial/pl2303.c                        |  114 +-
 drivers/usb/serial/qcaux.c                         |    9 +-
 drivers/usb/serial/qcserial.c                      |   41 +-
 drivers/usb/serial/quatech2.c                      | 1155 +++++++
 drivers/usb/serial/safe_serial.c                   |   11 +-
 drivers/usb/serial/siemens_mpi.c                   |    9 +-
 drivers/usb/serial/sierra.c                        |   56 +-
 drivers/usb/serial/spcp8x5.c                       |   24 +-
 drivers/usb/serial/ssu100.c                        |   33 +-
 drivers/usb/serial/symbolserial.c                  |   30 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   65 +-
 drivers/usb/serial/ti_usb_3410_5052.h              |    1 +
 drivers/usb/serial/usb-serial.c                    |  109 +-
 drivers/usb/serial/usb_debug.c                     |    9 +-
 drivers/usb/serial/usb_wwan.c                      |   50 +-
 drivers/usb/serial/visor.c                         |   98 +-
 drivers/usb/serial/vivopay-serial.c                |    9 +-
 drivers/usb/serial/whiteheat.c                     |  569 +---
 drivers/usb/serial/zio.c                           |    9 +-
 drivers/usb/storage/ene_ub6250.c                   |    6 +-
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/usb/storage/usb.c                          |   22 +-
 drivers/usb/usb-skeleton.c                         |   36 +-
 drivers/video/udlfb.c                              |    2 +-
 include/acpi/acpi_bus.h                            |   36 +
 include/linux/bcma/bcma.h                          |    1 +
 include/linux/fsl_devices.h                        |    9 +-
 include/linux/platform_data/ehci-sh.h              |   28 +
 .../linux/platform_data/s3c-hsotg.h                |    5 +-
 include/linux/usb.h                                |   79 +-
 include/linux/usb/ch11.h                           |    2 +
 include/linux/usb/ch9.h                            |   58 +
 include/linux/usb/chipidea.h                       |   28 +
 include/linux/usb/composite.h                      |    6 +
 include/linux/usb/functionfs.h                     |    4 +-
 include/linux/usb/gpio_vbus.h                      |    2 +
 include/linux/usb/hcd.h                            |   32 +-
 include/linux/usb/isp1301.h                        |   80 +
 include/linux/usb/langwell_udc.h                   |  310 --
 include/linux/usb/serial.h                         |   34 +-
 tools/usb/ffs-test.c                               |    2 +-
 tools/usb/testusb.c                                |    5 +
 395 files changed, 19447 insertions(+), 16215 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/isp1301.txt
 create mode 100644 Documentation/devicetree/bindings/usb/lpc32xx-udc.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-nxp.txt
 create mode 100644 Documentation/devicetree/bindings/usb/spear-usb.txt
 create mode 100644 Documentation/usb/functionfs.txt
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-usb-hsotg.h
 create mode 100644 drivers/staging/ccg/Kconfig
 create mode 100644 drivers/staging/ccg/Makefile
 create mode 100644 drivers/staging/ccg/TODO
 create mode 100644 drivers/staging/ccg/ccg.c
 create mode 100644 drivers/staging/ccg/sysfs-class-ccg_usb
 delete mode 100644 drivers/staging/quatech_usb2/Kconfig
 delete mode 100644 drivers/staging/quatech_usb2/Makefile
 delete mode 100644 drivers/staging/quatech_usb2/TODO
 delete mode 100644 drivers/staging/quatech_usb2/quatech_usb2.c
 create mode 100644 drivers/usb/chipidea/Kconfig
 create mode 100644 drivers/usb/chipidea/Makefile
 create mode 100644 drivers/usb/chipidea/bits.h
 create mode 100644 drivers/usb/chipidea/ci.h
 rename drivers/usb/{gadget => chipidea}/ci13xxx_msm.c (69%)
 rename drivers/usb/{gadget => chipidea}/ci13xxx_pci.c (52%)
 create mode 100644 drivers/usb/chipidea/core.c
 create mode 100644 drivers/usb/chipidea/debug.c
 create mode 100644 drivers/usb/chipidea/debug.h
 create mode 100644 drivers/usb/chipidea/host.c
 create mode 100644 drivers/usb/chipidea/host.h
 create mode 100644 drivers/usb/chipidea/udc.c
 create mode 100644 drivers/usb/chipidea/udc.h
 delete mode 100644 drivers/usb/core/inode.c
 create mode 100644 drivers/usb/core/usb-acpi.c
 delete mode 100644 drivers/usb/gadget/ci13xxx_udc.c
 delete mode 100644 drivers/usb/gadget/ci13xxx_udc.h
 delete mode 100644 drivers/usb/gadget/langwell_udc.c
 delete mode 100644 drivers/usb/gadget/langwell_udc.h
 create mode 100644 drivers/usb/gadget/lpc32xx_udc.c
 create mode 100644 drivers/usb/gadget/s3c-hsotg.h
 create mode 100644 drivers/usb/host/bcma-hcd.c
 create mode 100644 drivers/usb/host/ehci-sead3.c
 delete mode 100644 drivers/usb/host/ohci-ssb.c
 create mode 100644 drivers/usb/host/ssb-hcd.c
 create mode 100644 drivers/usb/musb/musb_dsps.c
 create mode 100644 drivers/usb/phy/Kconfig
 create mode 100644 drivers/usb/phy/Makefile
 create mode 100644 drivers/usb/phy/isp1301.c
 create mode 100644 drivers/usb/serial/quatech2.c
 create mode 100644 include/linux/platform_data/ehci-sh.h
 rename arch/arm/plat-samsung/include/plat/udc-hs.h => include/linux/platform_data/s3c-hsotg.h (90%)
 create mode 100644 include/linux/usb/chipidea.h
 create mode 100644 include/linux/usb/isp1301.h
 delete mode 100644 include/linux/usb/langwell_udc.h

---------------

Adhir Ramjiawan (1):
      USB: serial: removed assignment from if statements in ti_usb_3410_5052.c

Ajay Kumar Gupta (2):
      usb: musb: Add support for ti81xx platform
      usb: musb: enable support for am335x

Alan Stern (8):
      EHCI: don't try to clear the IAAD bit
      EHCI: maintain the ehci->command value properly
      usb-serial: ftdi_sio: fix oops during autosuspend
      usb-serial: clean up unneeded PM-related fields
      USB: xhci-hcd: print URB's expected length in decimal, not hex
      usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player
      USB: EHCI: improve full-speed isochronous scheduling routine
      USB: EHCI: work around bug in the Philips ISP1562 controller

Aleksey Babahin (7):
      USB: serial: metro-usb: Fix idProduct for Uni-Directional mode.
      USB: serial: metro-usb: dummy implement write_int_callback() function.
      USB: serial: metro-usb: get data from device in Uni-Directional mode.
      USB: serial: metro-usb: print errors always, not only in debug mode.
      USB: serial: metro-usb: make debug messages bit more informative.
      USB: serial: metro-usb: remove duplicated #include <linux/errno.h>
      USB: serial: metro-usb: cosmetic fix in driver description.

Alexander Shishkin (31):
      usb: gadget: ci13xxx: fix ep list removal in gadget unregistering code
      usb: gadget: ci13xxx: initialize ep0{out,in} dynamically
      usb: gadget: ci13xxx: rename register layouts
      usb: gadget: ci13xxx_pci: add langwell/penwell pci ids
      usb: gadget: ci13xxx: drop needless parens
      usb: gadget: ci13xxx: move global variables inside struct ci13xxx
      usb: gadget: ci13xxx: redo register access
      usb: gadget: conversion of controllers choice to menu
      usb: gadget: ci13xxx: convert to platform device
      usb: gadget: ci13xxx: replace home-brewed logging with dev_{err,warn,info}
      usb: gadget: ci13xxx: move endpoint (de-)initialization to probe/remove
      usb: gadget: ci13xxx: convert to new style
      usb: gadget: ci13xxx_pci: guard against devices without driver_data
      usb: gadget: ci13xxx: get rid of local tracing for good
      usb: gadget: ci13xxx: fix the context of register map
      usb: gadget: ci13xxx: don't use "advance" feature when setting address
      usb: gadget: ci13xxx: print basic device info when probing
      usb: move ci13xxx and related code to drivers/usb/chipidea
      usb: chipidea: split the driver code into units
      usb: chipidea: add support for roles
      usb: chipidea: remove unused field "regs" from ci13xxx
      usb: chipidea: brush up structure definitions
      usb: chipidea: drop redundant NULL check
      usb: chipidea: drop unused msm register definitions
      usb: chipidea: use common definition for USBMODE bits
      usb: chipidea: add host role
      usb: chipidea: add power_budget limit for ehci to platform data
      usb: chipidea: use generic map/unmap routines
      usb: chipidea: drop unused field "device" from ci13xxx_ep
      usb: gadget: remove langwell_udc
      MAINTAINERS: Add an entry for ChipIdea USB driver

Andiry Xu (2):
      xHCI: keep track of ports being resumed and indicate in hub_status_data
      usbcore: enable USB2 LPM if port suspend fails

Andrzej Pietrasiewicz (4):
      usb: gadget: composite: make module parameters accessible at runtime
      usb: gadget: composite: add iSerialNumber to usb_composite_driver
      FunctionFS: enable multiple functions
      staging: usb: gadget: Add FunctionFS support to Configurable Composite Gadget driver

Axel Lin (1):
      usb: gadget: use module_pci_driver

Ben Minerds (1):
      USB: serial: belkin_sa: Changes to conform with coding style

Benoit Goby (5):
      usb: gadget: composite: Add usb_remove_config
      usb: gadget: composite: Initialize config->interface
      usb: gadget: u_serial: Allow calling gserial_setup after init
      usb: gadget: rndis: Fix re-binding f_rndis
      usb: gadget: f_rndis: Set rndis vendor parameters

Bill Pemberton (2):
      USB: serial: add quatech2 usb to serial driver
      USB: serial: add copyright and license to quatech2

Bjørn Mork (7):
      USB: cdc-wdm: add debug messages on cleanup
      USB: cdc-wdm: poll must return POLLHUP if device is gone
      USB: cdc-wdm: cannot use dev_printk when device is gone
      USB: cdc-wdm: remove from device list on disconnect
      USB: let both new_id and remove_id show dynamic id list
      USB: add read support to usb-serial/../new_id
      USB: serial: generic driver is only for testing

Dan Carpenter (3):
      USB: bcma: suspend() only takes one argument now
      USB: wwan: remove an unneeded check
      usb: gadget: add a sparse endian notation

Darren Hart (1):
      USB: serial: ti_usb_3410_5052: Add support for the FRI2 serial console

David Herrmann (1):
      usb: Kconfig: remove unneeded default value

Donald (1):
      USB: serial: mos7840: add support for MCS7810 devices

Du, ChangbinX (1):
      USB: testusb: add path /dev/bus/usb to default search paths for usbfs

Fabio Estevam (1):
      usb: gadget: Include i.MX processors in the USB_FSL_USB2 help text

Felipe Balbi (9):
      usb: dwc3: core: define more revision macros
      usb: dwc3: workaround: metastability state on Run/Stop bit
      usb: ch9: define Set SEL and Set Isoch Delay macros
      usb: dwc3: gadget: implement Global Command support
      usb: dwc3: ep0: implement Set SEL support
      usb: dwc3: gadget: increase setup buffer size
      usb: dwc3: ep0: implement support for Set Isoch Delay request
      usb: dwc3: define DWC3_EP0_BOUNCE_SIZE
      MAINTAINERS: Add myself as maintainer to the USB PHY Layer

Geert Uytterhoeven (2):
      usb/bcma: Add missing #include <linux/slab.h>
      usb/ssb: Add missing #include <linux/slab.h>

Greg Kroah-Hartman (211):
      USB: serial: visor: remove product and vendor module parameters
      USB: serial: ipaq: remove product and vendor module parameters
      USB: serial: ipaq: delete duplicate id
      USB: asus_oled.c: remove err() usage
      USB: dt9812.c: remove err() usage
      USB: vmk80xx.c: remove err() usage
      USB: alphatrack.c: remove err() usage
      USB: tranzport.c: remove err() usage
      USB: driver.c: remove err() usage
      USB: toneport.c: remove err() usage
      USB: oxu210hp-hcd.c: remove err() usage
      USB: emi26.c: remove err() usage
      USB: emi62.c: remove err() usage
      USB: idmouse.c: remove err() usage
      USB: iowarrior.c: remove err() usage
      USB: ldusb.c: remove err() usage
      USB: legousbtower.c: remove err() usage
      USB: rio500.c: remove err() usage
      USB: usblcd.c: remove err() usage
      USB: uss720.c: remove err() usage
      USB: yurex.c: remove err() usage
      USB: console.c: remove err() usage
      USB: option.c: remove err() usage
      USB: usb_wwan.c: remove err() usage
      USB: Staging: media: easycap: remove err() usage
      USB: Staging: media: lirc: lirc_imon: remove err() usage
      USB: Staging: media: lirc: lirc_sasem: remove err() usage
      USB: Staging: media: lirc: lirc_ttusbir: remove err() usage
      USB: Staging: quatech_usb3: remove err() usage
      USB: Staging: serqt_usb2: remove err() usage
      USB: catc.c: remove err() usage
      USB: ipheth.c: remove err() usage
      USB: kaweth.c: remove err() usage
      USB: rtl8150.c: remove err() usage
      USB: udlfb.c: remove err() usage
      USB: staging: media: as102: convert to use module_usb_driver
      USB: iforce: remove err() usage
      USB: usbmouse.c: remove err() usage
      USB: xpad.c: remove err() usage
      USB: cm109.c: remove err() usage
      USB: keyspan_remote.c: remove err() usage
      USB: powermate.c: remove err() usage
      USB: yealink.c: remove err() usage
      USB: appletouch.c: remove err() usage
      USB: bcm5974.c: remove err() usage
      USB: acecad.c: remove err() usage
      USB: aiptek.c: remove err() usage
      USB: gtco.c: remove err() usage
      USB: kbtab.c: remove err() usage
      USB: wacom_sys.c: remove err() usage
      USB: usbtouchscreen.c: remove err() usage
      USB: ov534_9.c: remove err() usage
      USB: hdpvr-core.c: remove err() usage
      USB: irda-usb.c: remove err() usage
      USB: kingsun-sir.c: remove err() usage
      USB: ks959-sir.c: remove err() usage
      USB: ksdazzle-sir.c: remove err() usage
      USB: stir4200.c: remove err() usage
      USB: at76c50x-usb.c: remove err() usage
      USB: as102_usb_drv.c: remove err() usage
      USB: remove err() macro
      USB: ci13xxx_udc.c: remove err() usage
      USB: ohci-at91.c: remove err() usage
      USB: ohci-cns3xxx.c: remove err() usage
      USB: ohci-ep93xx.c: remove err() usage
      USB: ohci-exynos.c: remove err() usage
      USB: ohci-nxp.c: remove err() usage
      USB: ohci-ppc-of.c: remove err() usage
      USB: ohci-ppc-soc.c: remove err() usage
      USB: ohci-ps3.c: remove err() usage
      USB: ohci-s3c2410.c: remove err() usage
      USB: ohci-sh.c: remove err() usage
      USB: ohci-tmio.c: remove err() usage
      USB: ohci-xls.c: remove err() usage
      USB: usb-skeleton.c: remove err() usage
      USB: remove CONFIG_USB_DEVICEFS
      USB: remove CONFIG_USB_DEVICE_CLASS
      USB: input: joystick: iforce: fix up dev_err() usages
      USB: input: xpad.c: fix up dev_err() usage
      USB: input: cm109.c: fix up dev_err() usage
      USB: input: keyspan_remote.c: fix up dev_err() usage
      USB: input: powermate.c: fix up dev_err() usage
      USB: input: yealink.c: fix up dev_err() usage
      USB: input: appletouch.c: fix up dev_err() usage
      USB: input: bcm5974.c: fix up dev_err() usage
      USB: input: acecad.c: fix up dev_err() usage
      USB: input: aiptek.c: fix up dev_err() usage
      USB: input: gtco.c: fix up dev_err() usage
      USB: input: kbtab.c: fix up dev_err() usage
      USB: input: wacom_sys.c: fix up dev_err() usage
      USB: input: usbtouchscreen.c: fix up dev_err() usage
      USB: wacom: remove dbg() usage
      USB: iforce: remove dbg() usage
      USB: hid-core.c: remove dbg() usage
      USB: xpad.c: remove dbg() usage
      USB: powermate.c: remove dbg() usage
      USB: yealink.c: remove dbg() usage
      USB: appletouch.c: remove dbg() usage
      USB: bcm5974.c: remove dbg() usage
      USB: acecad.c: remove dbg() usage
      USB: aiptek.c: remove dbg() usage
      USB: gtco.c: remove dbg() usage
      USB: kbtab.c: remove dbg() usage
      USB: usbtouchscreen.c: remove dbg() usage
      USB: cxacru.c: remove dbg() usage
      USB: speedtch.c: remove dbg() usage
      USB: usbatm.c: remove dbg() usage
      USB: xusbatm.c: remove dbg() usage
      USB: usblp.c: remove dbg() usage
      USB: file.c: remove dbg() usage
      USB: ehci-q.c: remove dbg() usage
      USB: ehci-sched.c: remove dbg() usage
      USB: ohci-dbg.c: remove dbg() usage
      USB: ohci-ep93xx.c: remove dbg() usage
      USB: ohci-sa1111.c: remove dbg() usage
      USB: oxu210hp-hcd.c: remove dbg() usage
      USB: r8a66597-hcd.c: remove dbg() usage
      USB: mdc800.c: remove dbg() usage
      USB: appledisplay.c: remove dbg() usage
      USB: idmouse.c: remove dbg() usage
      USB: rio500.c: remove dbg() usage
      USB: usblcd.c: remove dbg() usage
      USB: uss720.c: remove dbg() usage
      USB: yurex.c: remove dbg() usage
      USB: serial: pl2303: convert dbg() calls to dev_dbg()
      USB: serial: visor: convert dbg() to dev_dbg()
      USB: belkin_sa.c: remove dbg() tracing calls
      USB: ch341.c: remove dbg() tracing calls
      USB: cp210x.c: remove dbg() tracing calls
      USB: cyberjack.c: remove dbg() tracing calls
      USB: cypress_m8.c: remove dbg() tracing calls
      USB: digi_acceleport.c: remove dbg() tracing calls
      USB: empeg.c: remove dbg() tracing calls
      USB: ezusb.c: remove dbg() tracing calls
      USB: f81232.c: remove dbg() tracing calls
      USB: ftdi_sio.c: remove dbg() tracing calls
      USB: garmin_gps.c: remove dbg() tracing calls
      USB: generic.c: remove dbg() tracing calls
      USB: ipaq.c: remove dbg() tracing calls
      USB: ipw.c: remove dbg() tracing calls
      USB: ir-usb.c: remove dbg() tracing calls
      USB: iuu_phoenix.c: remove dbg() tracing calls
      USB: keyspan.c: remove dbg() tracing calls
      USB: keyspan_pda.c: remove dbg() tracing calls
      USB: kl5kusb105.c: remove dbg() tracing calls
      USB: kobil_sct.c: remove dbg() tracing calls
      USB: mct_u232.c: remove dbg() tracing calls
      USB: mos7720.c: remove dbg() tracing calls
      USB: mos7840.c: remove dbg() tracing calls
      USB: navman.c: remove dbg() tracing calls
      USB: omninet.c: remove dbg() tracing calls
      USB: opticon.c: remove dbg() tracing calls
      USB: option.c: remove dbg() tracing calls
      USB: oti6858.c: remove dbg() tracing calls
      USB: qcserial.c: remove dbg() tracing calls
      USB: sierra.c: remove dbg() tracing calls
      USB: spcp8x5.c: remove dbg() tracing calls
      USB: ssu100.c: remove dbg() tracing calls
      USB: symbolserial.c: remove dbg() tracing calls
      USB: ti_usb_3410_5052.c: remove dbg() tracing calls
      USB: usb_wwan.c: remove dbg() tracing calls
      USB: whiteheat.c: remove dbg() tracing calls
      USB: input: iforce: fix up dev_* messages
      USB: input: xpad.c: fix up dev_* messages
      USB: input: cm109.c: fix up dev_* messages
      USB: input: keyspan_remote.c: fix up dev_* messages
      USB: input: powermate.c: fix up dev_* messages
      USB: input: yealink.c: fix up dev_* messages
      USB: input: appletouch.c: fix up dev_* messages
      USB: input: bcm5974.c: fix up dev_* messages
      USB: input: acecad.c: fix up dev_* messages
      USB: input: aiptek.c: fix up dev_* messages
      USB: input: gtco.c: fix up dev_* messages
      USB: input: kbtab.c: fix up dev_* messages
      USB: input: wacom_sys.c: fix up dev_* messages
      USB: input: usbtouchscreen.c: fix up dev_* messages
      USB: input: appletouch: fix up compiler warning
      USB: gadget: ci13xx_udc: remove unused err() macro
      USB: quatech_usb2.c: remove dbg() tracing calls
      USB: serqt_usb2.c: remove dbg() tracing calls
      USB: serial: remove usb_serial_probe call in all drivers
      USB: serial: remove usb_serial_disconnect call in all drivers
      USB: serial: ch341: remove reset_resume callback
      USB: serial: sierra: remove reset_resume callback
      USB: serial: remove bizarre generic_serial probe function
      USB: serial: rework usb_serial_register/deregister_drivers()
      USB: gadget: ci13xx_udc: fix potential crash in irq handler
      USB: gadget: ci13xx_pci: remove unneeded check in ci13xxx_pci_probe()
      USB: remove staging quatech_usb2 driver
      USB: serqt_usb2: remove duplicate device ids
      USB: serial: opticon: hook up suspend/resume callbacks
      Revert "usb: move struct usb_device->children to struct usb_hub_port->child"
      Revert "usb: add struct usb_hub_port to store port related members."
      USB: serial: hook up reset_resume callback
      USB: serial: ch341: put reset_resume callback back.
      USB: serial: sierra: put reset_resume callback back.
      USB: aircable.c: remove dbg() usage
      USB: ark3116.c: remove dbg() usage
      USB: belkin_sa.c: remove dbg() usage
      USB: f81232.c: remove dbg() usage
      USB: generic.c: remove dbg() usage
      USB: ipaq.c: remove dbg() usage
      USB: ir-usb.c: remove dbg() usage
      USB: navman.c: remove dbg() usage
      USB: qcserial.c: remove dbg() usage
      USB: spcp8x5.c: remove dbg() usage
      USB: symbolserial.c: remove dbg() usage
      USB: serial: ch341: make the reset_resume callback actually work.
      USB: serial: fix up reset_resume callback
      Revert "USB: serial: sierra: put reset_resume callback back."
      Revert "USB: EHCI: work around bug in the Philips ISP1562 controller"

Hans de Goede (1):
      usb-xhci: Handle COMP_TX_ERR for isoc tds

Hauke Mehrtens (5):
      bcma: scan for extra address space
      USB: Add driver for the bcma bus
      USB: Add driver for the ssb bus
      USB: OHCI: remove old SSB OHCI driver
      USB: ehci-platform: remove update_device

Huajun Li (1):
      USB: Remove races in devio.c

Ido Shayevitz (20):
      usb: dwc3: omap: add dwc3_omap_readl/writel functions
      usb: dwc3: core: split host address space
      usb: gadget: Update ci13xxx_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: dwc3: Update dwc3 udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update amd5536udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update at91_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update atmel_usba_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update fsl_qe_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update fsl_udc_core to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update fusb300_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update goku_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update langwell_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update m66592-udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update mv_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update omap_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update pxa25x_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update r8a66597-udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update s3c2410_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update pch_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update s3c-hsudc to use usb_endpoint_descriptor inside the struct usb_ep

Igor Grinberg (1):
      ARM: OMAP: USB: fix warning on EHCI PHY reset path

Jan Luebbe (1):
      ohci-da8xx: set MODULE_ALIAS to allow autoloading

Jarkko Nikula (2):
      USB: ehci-fsl: Use usb_put_transceiver instead of put_device
      USB: ohci-omap: Use usb_put_transceiver instead of put_device

Jeffrin Jose (3):
      USB: storage: fixed C99 comment issue.
      USB: storage: fixed several trailing white spaces issues.
      USB: storage: fixed keyword related space issues.

Jesper Juhl (2):
      usb/storage/ene_ub6250: Remove redundant NULL check before release_firmware() and pointless assignment
      usb/atm/ueagle-atm: Don't test for NULL ptr before calling release_firmware()

Jingoo Han (1):
      USB: ehci-s5p: add clock gating to suspend/resume

Johan Hovold (11):
      USB: whiteheat: remove driver version
      USB: whiteheat: reimplement using generic framework
      USB: io_ti: fix abuse of interface data
      USB: add EOPNOTSUPP to usb_translate_errors
      USB: opticon: fix abuse of interface data
      USB: oti6858: fix abuse of interface data
      USB: pl2303: fix abuse of interface data
      USB: serial: fix interface data use
      USB: serial: remove redundant write-urb kill
      USB: serial: fix double newlines in debug output
      USB: pl2303: remove unused define

Joonyoung Shim (1):
      ARM: EXYNOS: Add s3c-hsotg device support for NURI board

Lan Tianyu (2):
      usb: add struct usb_hub_port to store port related members.
      usb: move struct usb_device->children to struct usb_hub_port->child

Lukasz Majewski (22):
      usb:hsotg:samsung: Remove platform dependency from s3c-hsotg
      usb:hsotg:samsung: Remove platform dependent functions from s3c-hsotg
      usb:hsotg:samsung: Wrappers for USB PHY methods
      usb:hsotg:samsung: Use of regulator_bulk_* functions for USB regulators
      usb:hsotg:samsung: NAK management for EP0 (Setup stage of control transfers)
      usb:hsotg:samsung: Sending ZLP packet for IN EP0 transfers
      usb:hsotg:samsung: Extract core initialization function
      usb:hsotg:samsung: Remove Disconnect Interrupt handler
      usb:hsotg:samsung: Rename s3c_hsotg_disconnect function
      usb:hsotg:samsung: Cable disconnection recovery code
      usb:hsotg:samsung: Determine number of EPs from HW configuration register
      usb:hsotg:samsung: Use new udc_start and udc_stop callbacks
      usb:hsotg:samsung: Comments reorganization and cleanup
      usb:hsotg:samsung: Remove our_hsotg global pointer
      usb:hsotg:samsung: Add release function for hsotg device
      usb:hsotg:samsung: Remove the S3C_ prefix from registers definition.
      usb:hsotg:samsung: Use clk_prepare_enable and clk_disable_unprepare
      usb:hsotg:samsung: err_irq: support for probe function
      usb:hsotg:samsung:cosmetic Move <linux/platform_data/s3c-hsotg.h> to proper place
      ARM: EXYNOS: Add usb otg phy control for EXYNOS4210
      ARM: EXYNOS: Add s3c-hsotg device support for GONI board
      ARM: EXYNOS: Add s3c-hsotg device support for Universal C210 board

Marek Vasut (2):
      USB: CI13xxx: Allow use of CONFIG_USB_EHCI_ROOT_HUB_TT
      USB: CI13xxx: Use usb_put_hcd() on failure to drop HCD

Masanari Iida (1):
      usb: Fix various typo within usb

Matthew Garrett (4):
      ACPI: Add stubs for (un)register_acpi_bus_type
      ACPI: Add _PLD support
      usb: Bind devices to ACPI devices when possible
      usb: Set device removable state based on ACPI USB data

Matthias Fend (1):
      USB: ffs-test: fix length argument of out function call

Michael Grzeschik (5):
      isp1760-if: make module unloads correctly
      isp1760-hcd: don't confuse parsers on kmem_cache_create
      isp1760-hcd: move dequeued qtds to the front in qh
      isp1760-hcd: fix possible memory leak if urb could not be enqueued
      usb: chipidea: isr_reset_handler fix missing locking

Michal Nazarewicz (1):
      usb: gadget: f_mass_storage: remove deprecated fsg_add()

Mike Lockwood (2):
      usb: gadget: Add variant of gether_setup to customize the device name
      staging: usb: gadget: Add Configurable Composite Gadget driver

Ming Lei (2):
      USB: twl6030-usb: pass IRQF_ONESHOT to request_threaded_irq
      USB: EHCI: fix command register configuration lost problem

Nicolas Ferre (3):
      USB: ohci-at91: use resource_size() for memory/io resource length
      USB: ohci-at91: add a reset function to fix race condition
      usb: gadget: at91_udc: fix endpoint descriptor dereference

Nobuhiro Iwamatsu (1):
      usb: ehci-sh: Add PHY init function with platform data

Oliver Neukum (5):
      USB: cdc-wdm: sanitize error returns
      USB: cdc-wdm: fix memory leak
      USB: cdc-wdm: cleanup error codes
      usbhid: prevent deadlock during timeout
      USB: fix resource leak in xhci power loss path

Paul Bolle (1):
      USB: make vendor id of root hubs greppable

Paul Gortmaker (3):
      usb: [MIPS] fix unresolved err() reference in host/ohci-au1xxx.c
      usb: [MIPS] fix unresolved err() reference in host/ohci-pnx8550.c
      usb: [ARM] fix unresolved err() reference in host/ohci-pxa27x.c

Paul Zimmerman (3):
      usb: usbtest: two super speed fixes for usbtest
      usb: dwc3: gadget: issue Update Transfer command after queuing isoc request
      usb: gadget: add isochronous support to gadget zero

Peter Chen (2):
      USB: EHCI: remove wrong debug message for port speed
      usb: gadget: fsl_udc_core: dTD's next dtd pointer need to be updated once written

Peter Korsgaard (1):
      f_fs: ffs_func_free: cleanup requests allocated by autoconfig

Preston Fick (1):
      usb: cp210x: Corrected USB request type definitions

Ramneek Mehresh (1):
      fsl/usb: Add controller version based ULPI and UTMI phy support

Reinhard Tartler (1):
      usb: musb: cppi: add missing include to fix compilation

Richard Zhao (1):
      usb: chipidea: remove zero check of hw_ep_max

Roland Stigge (5):
      ohci-nxp: Driver cleanup
      ohci-nxp: Device tree support
      USB: Add driver for NXP ISP1301 USB transceiver
      USB: gadget driver for LPC32xx
      USB: ohci-nxp: Use isp1301 driver

Russ Dill (1):
      USB: EHCI: OMAP: Finish ehci omap phy reset cycle before adding hcd.

Sarah Sharp (21):
      xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=n
      xhci: Add Lynx Point to list of Intel switchable hosts.
      xhci: Add new short TX quirk for Fresco Logic host.
      xhci: Reset reserved command ring TRBs on cleanup.
      xhci: Add roothub code to set U1/U2 timeouts.
      USB: Make sure to fetch the BOS desc for roothubs.
      USB: Refactor code to set LPM support flag.
      USB: Calculate USB 3.0 exit latencies for LPM.
      USB: Allow drivers to disable hub-initiated LPM.
      USB: Add support to enable/disable USB3 link states.
      USB: Disable USB 3.0 LPM in critical sections.
      xhci: Some Evaluate Context commands must succeed.
      xhci: Reserve one command for USB3 LPM disable.
      USB: Add macros for interrupt endpoint types.
      xhci: Add infrastructure for host-specific LPM policies.
      xhci: Add Intel U1/U2 timeout policy.
      USB: Disable hub-initiated LPM for comms devices.
      brcm80211: Fix compile error for .disable_hub_initiated_lpm.
      USB: Fix core compile with CONFIG_USB_SUSPEND=n
      xhci: Fix compile with CONFIG_USB_SUSPEND=n
      xhci: Fix DIV_ROUND_UP compile error.

Sasha Levin (2):
      usb: gadget: dummy_hcd: fix build when BUG is not set
      usb: fix breakage on systems without ACPI

Sebastian Andrzej Siewior (9):
      usb: dwc3: ep0: add LPM handling
      usb: gadget: at91_udc: convert to new style start/stop interface
      usb: gadget: atmel_usba_udc: convert to newstyle start/stop interface
      usb: gadget: fsl_qe_udc: convert to new style start/stop
      usb: gadget: fsl_qe_udc: remove not implemented callbacks
      usb: gadget: imx_udc: convert to new style start/stop
      usb: gadget: remove DUALSPEED from printer
      usb: gadget: make g_printer use composite
      usb: gadget: dummy_hcd: allow to free requests on disabled endpoints

Shimoda, Yoshihiro (2):
      usb: renesas_usbhs: gadget: add support for set_selfpowered
      usb: gadget: r8a66597-udc: add support for set_selfpowered

Shinya Kuribayashi (9):
      USB: gpio_vbus: fix inconsistent 'dev_id' parameters at free_irq()
      USB: gpio_vbus: provide an appropriate debounce interval
      USB: gpio_vbus: put a missing regulator_put() on error
      USB: gpio_vbus: avoid consecutive vbus_session calls with the same "is_active"
      USB: gpio_vbus: use cached IRQ number for consistency with the probed one
      USB: gpio_vbus: remove IRQF_SAMPLE_RANDOM use
      USB: gpio_vbus: handle IRQ flags properly
      USB: gpio_vbus: a missing cancellation of workqueue in remove() function
      USB: gpio_vbus: wakeup support on GPIO VBUS interrupts

Stefan Roese (1):
      USB: Add DT probing support to ehci-spear and ohci-spear

Steffen Müller (1):
      usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es

Stephen Warren (2):
      USB: EHCI: remove PORT_RWC_BITS when clearing USB_PORT_FEAT_ENABLE
      USB: ehci-tegra: remove PORT_RWC_BITS when setting USB_PORT_FEAT_ENABLE

Steven J. Hill (2):
      usb: host: mips: sead3: USB Host controller support for SEAD-3 platform.
      usb: host: mips: sead3: Fix for big endian.

Venu Byravarasu (2):
      usb: host: tegra: code clean up
      usb: host: tegra: re-arranging ehci functions

Viresh Kumar (1):
      USB: ehci: ohci: Add clk_{un}prepare() support

Yongsul Oh (1):
      usb: gadget: composite: prevent a memory leak when configuration bind fails

girish verma (1):
      USB: xhci: testing sizeof xhci_doorbell_array 2 time

joseph daniel (1):
      usb: dwc3: Fix the dwc3 dependency

Éric Piel (1):
      USB: ftdi-sio: add support for Physik Instrumente E-861

