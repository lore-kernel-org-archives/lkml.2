Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0ETUeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:34:06 -0400
Received: from kroah.org ([198.145.64.141]:53468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0ETUaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:30:13 -0400
Date: Thu, 20 May 2010 13:28:19 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.35
Message-ID: <20100520202819.GA25922@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big USB merge for the .35 kernel.

It includes a bunch of patches, some touching portions outside of the
USB core.  The majority of the changes outside of drivers/usb/ are for
an api change, to try to make the naming of the usb buffer allocation
functions be more sane.

The other out-of-drivers/usb/ changes are due to the new gadgetfs
functionality.  All of those changes have been acked by the respective
maintainers, so all is good there as well.

For details as to the changes, see the shortlog below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/ABI/obsolete/sysfs-bus-usb           |   31 +
 Documentation/ABI/testing/sysfs-bus-usb            |   28 -
 .../testing/sysfs-devices-platform-_UDC_-gadget    |    9 +
 Documentation/DocBook/writing_usb_driver.tmpl      |    2 +-
 Documentation/usb/bulk-streams.txt                 |   78 +
 Documentation/usb/dma.txt                          |   22 +-
 Documentation/usb/gadget_hid.txt                   |  445 ++++
 Documentation/usb/power-management.txt             |   19 +-
 Documentation/usb/usb-serial.txt                   |   29 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    3 +
 arch/arm/mach-omap2/usb-ehci.c                     |  155 ++
 arch/arm/mach-omap2/usb-musb.c                     |    1 +
 arch/arm/plat-omap/include/plat/usb.h              |   24 +
 drivers/hid/usbhid/hid-core.c                      |   20 +-
 drivers/hid/usbhid/usbhid.h                        |    1 -
 drivers/hid/usbhid/usbkbd.c                        |   16 +-
 drivers/hid/usbhid/usbmouse.c                      |    6 +-
 drivers/input/joystick/xpad.c                      |   16 +-
 drivers/input/misc/ati_remote.c                    |   12 +-
 drivers/input/misc/ati_remote2.c                   |    4 +-
 drivers/input/misc/cm109.c                         |   28 +-
 drivers/input/misc/keyspan_remote.c                |    6 +-
 drivers/input/misc/powermate.c                     |   17 +-
 drivers/input/misc/yealink.c                       |   25 +-
 drivers/input/mouse/appletouch.c                   |   12 +-
 drivers/input/mouse/bcm5974.c                      |   24 +-
 drivers/input/tablet/acecad.c                      |    6 +-
 drivers/input/tablet/aiptek.c                      |   14 +-
 drivers/input/tablet/gtco.c                        |   12 +-
 drivers/input/tablet/kbtab.c                       |    6 +-
 drivers/input/tablet/wacom_sys.c                   |   10 +-
 drivers/input/touchscreen/usbtouchscreen.c         |    8 +-
 drivers/media/dvb/dvb-usb/usb-urb.c                |    7 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    6 +-
 drivers/media/video/au0828/au0828-video.c          |    4 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |   14 +-
 drivers/media/video/em28xx/em28xx-core.c           |    4 +-
 drivers/media/video/gspca/benq.c                   |    4 +-
 drivers/media/video/gspca/gspca.c                  |   30 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    8 +-
 drivers/media/video/tlg2300/pd-main.c              |    2 +-
 drivers/media/video/tlg2300/pd-video.c             |   14 +-
 drivers/media/video/usbvision/usbvision-core.c     |   16 +-
 drivers/media/video/uvc/uvc_video.c                |    4 +-
 drivers/net/can/usb/ems_usb.c                      |   18 +-
 drivers/net/usb/ipheth.c                           |   24 +-
 drivers/net/usb/kaweth.c                           |   12 +-
 drivers/net/wimax/i2400m/usb.c                     |    2 +-
 drivers/net/wireless/ath/ar9170/usb.c              |    8 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |   10 +-
 drivers/staging/rt2860/iface/rtmp_usb.h            |    4 +-
 drivers/staging/udlfb/udlfb.c                      |    8 +-
 drivers/staging/usbip/stub_rx.c                    |    2 +-
 drivers/staging/usbip/usbip_common.c               |    2 +-
 drivers/staging/usbip/vhci.h                       |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |  347 ++--
 drivers/usb/c67x00/c67x00-hcd.h                    |    2 +-
 drivers/usb/class/cdc-acm.c                        |   22 +-
 drivers/usb/class/cdc-acm.h                        |    4 +-
 drivers/usb/class/cdc-wdm.c                        |   38 +-
 drivers/usb/class/usblp.c                          |    2 +-
 drivers/usb/core/buffer.c                          |    2 +-
 drivers/usb/core/config.c                          |  214 +--
 drivers/usb/core/devices.c                         |   19 +-
 drivers/usb/core/devio.c                           |    3 +-
 drivers/usb/core/driver.c                          |   60 +-
 drivers/usb/core/generic.c                         |    2 +-
 drivers/usb/core/hcd-pci.c                         |    2 +-
 drivers/usb/core/hcd.c                             |  246 ++-
 drivers/usb/core/hub.c                             |   30 +-
 drivers/usb/core/inode.c                           |    2 +-
 drivers/usb/core/message.c                         |  133 +-
 drivers/usb/core/quirks.c                          |    4 +
 drivers/usb/core/sysfs.c                           |   22 +-
 drivers/usb/core/urb.c                             |   18 +-
 drivers/usb/core/usb.c                             |   94 +-
 drivers/usb/gadget/Kconfig                         |   58 +-
 drivers/usb/gadget/Makefile                        |    8 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    3 +-
 drivers/usb/gadget/composite.c                     |   60 +-
 drivers/usb/gadget/config.c                        |    4 +-
 drivers/usb/gadget/dummy_hcd.c                     |    4 +-
 drivers/usb/gadget/epautoconf.c                    |   12 +-
 drivers/usb/gadget/f_acm.c                         |   32 +-
 drivers/usb/gadget/f_ecm.c                         |   33 +-
 drivers/usb/gadget/f_fs.c                          | 2442 ++++++++++++++++++++
 drivers/usb/gadget/f_hid.c                         |  673 ++++++
 drivers/usb/gadget/f_mass_storage.c                |  138 +-
 drivers/usb/gadget/f_rndis.c                       |   33 +-
 drivers/usb/gadget/f_uvc.c                         |  661 ++++++
 drivers/usb/gadget/f_uvc.h                         |  376 +++
 .../usb/gadget/{fsl_mx3_udc.c => fsl_mxc_udc.c}    |   14 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    2 +-
 drivers/usb/gadget/g_ffs.c                         |  426 ++++
 drivers/usb/gadget/hid.c                           |  298 +++
 drivers/usb/gadget/pxa27x_udc.h                    |    2 +-
 drivers/usb/gadget/u_ether.c                       |    4 +-
 drivers/usb/gadget/uvc.h                           |  241 ++
 drivers/usb/gadget/uvc_queue.c                     |  583 +++++
 drivers/usb/gadget/uvc_queue.h                     |   89 +
 drivers/usb/gadget/uvc_v4l2.c                      |  374 +++
 drivers/usb/gadget/uvc_video.c                     |  386 +++
 drivers/usb/gadget/webcam.c                        |  399 ++++
 drivers/usb/host/Kconfig                           |   15 +
 drivers/usb/host/ehci-au1xxx.c                     |   27 +-
 drivers/usb/host/ehci-fsl.c                        |    2 +
 drivers/usb/host/ehci-hcd.c                        |    3 +-
 drivers/usb/host/ehci-hub.c                        |  182 ++-
 drivers/usb/host/ehci-omap.c                       |   21 +-
 drivers/usb/host/ehci-pci.c                        |   18 +-
 drivers/usb/host/ehci-q.c                          |    2 +-
 drivers/usb/host/ehci.h                            |   18 +-
 drivers/usb/host/fhci-dbg.c                        |    2 +-
 drivers/usb/host/fhci-hcd.c                        |    2 +-
 drivers/usb/host/fhci-hub.c                        |    2 +-
 drivers/usb/host/fhci-mem.c                        |    2 +-
 drivers/usb/host/fhci-q.c                          |    2 +-
 drivers/usb/host/fhci-sched.c                      |    2 +-
 drivers/usb/host/fhci-tds.c                        |    2 +-
 drivers/usb/host/fhci.h                            |   11 +-
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/host/isp116x-hcd.c                     |    2 +-
 drivers/usb/host/isp1362-hcd.c                     |    6 +-
 drivers/usb/host/isp1760-hcd.c                     |   29 +-
 drivers/usb/host/isp1760-if.c                      |   13 +-
 drivers/usb/host/ohci-hcd.c                        |   33 +-
 drivers/usb/host/ohci-omap3.c                      |  735 ++++++
 drivers/usb/host/oxu210hp-hcd.c                    |   31 +-
 drivers/usb/host/r8a66597-hcd.c                    |   39 +-
 drivers/usb/host/sl811-hcd.c                       |   60 +-
 drivers/usb/host/u132-hcd.c                        |    6 +-
 drivers/usb/host/uhci-hcd.c                        |    2 +-
 drivers/usb/host/whci/debug.c                      |    2 +-
 drivers/usb/host/whci/qset.c                       |    6 +-
 drivers/usb/host/xhci-dbg.c                        |   24 +
 drivers/usb/host/xhci-hub.c                        |   39 +-
 drivers/usb/host/xhci-mem.c                        |  489 ++++-
 drivers/usb/host/xhci-pci.c                        |    8 +-
 drivers/usb/host/xhci-ring.c                       |  329 ++-
 drivers/usb/host/xhci.c                            |  416 ++++-
 drivers/usb/host/xhci.h                            |  112 +-
 drivers/usb/misc/appledisplay.c                    |    6 +-
 drivers/usb/misc/ftdi-elan.c                       |   20 +-
 drivers/usb/misc/iowarrior.c                       |   12 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   13 +-
 drivers/usb/misc/sisusbvga/sisusb_con.c            |    8 +-
 drivers/usb/misc/usblcd.c                          |    8 +-
 drivers/usb/misc/usbtest.c                         |   17 +-
 drivers/usb/mon/mon_bin.c                          |    4 +-
 drivers/usb/mon/mon_main.c                         |    3 +-
 drivers/usb/mon/mon_text.c                         |    6 +-
 drivers/usb/musb/Kconfig                           |    6 +-
 drivers/usb/musb/Makefile                          |   14 +-
 drivers/usb/musb/blackfin.c                        |   96 +-
 drivers/usb/musb/davinci.c                         |    2 +-
 drivers/usb/musb/musb_core.c                       |  147 +-
 drivers/usb/musb/musb_core.h                       |   10 +-
 drivers/usb/musb/musb_debug.h                      |   13 +
 drivers/usb/musb/musb_debugfs.c                    |  294 +++
 drivers/usb/musb/musb_gadget_ep0.c                 |   25 +
 drivers/usb/musb/musb_regs.h                       |   10 +
 drivers/usb/musb/musb_virthub.c                    |    4 +-
 drivers/usb/musb/musbhsdma.h                       |   16 +-
 drivers/usb/musb/omap2430.c                        |   29 +-
 drivers/usb/musb/tusb6010.c                        |    2 +-
 drivers/usb/otg/isp1301_omap.c                     |    2 +-
 drivers/usb/otg/twl4030-usb.c                      |  108 +-
 drivers/usb/otg/ulpi.c                             |   50 +-
 drivers/usb/serial/Kconfig                         |   23 +
 drivers/usb/serial/Makefile                        |    2 +
 drivers/usb/serial/aircable.c                      |  499 +----
 drivers/usb/serial/ark3116.c                       |  111 +-
 drivers/usb/serial/belkin_sa.c                     |  130 +-
 drivers/usb/serial/belkin_sa.h                     |   10 +-
 drivers/usb/serial/ch341.c                         |    5 +-
 drivers/usb/serial/console.c                       |   27 +-
 drivers/usb/serial/cp210x.c                        |   63 +-
 drivers/usb/serial/cypress_m8.c                    |  242 +--
 drivers/usb/serial/cypress_m8.h                    |   53 +-
 drivers/usb/serial/digi_acceleport.c               |    4 +-
 drivers/usb/serial/empeg.c                         |  401 +----
 drivers/usb/serial/ftdi_sio.c                      |  457 +----
 drivers/usb/serial/ftdi_sio.h                      |  126 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |   42 +-
 drivers/usb/serial/generic.c                       |  330 +--
 drivers/usb/serial/io_edgeport.c                   |    3 +-
 drivers/usb/serial/io_edgeport.h                   |   16 +-
 drivers/usb/serial/io_ionsp.h                      |   95 +-
 drivers/usb/serial/io_ti.c                         |  228 +--
 drivers/usb/serial/io_ti.h                         |   92 +-
 drivers/usb/serial/io_usbvend.h                    |   87 +-
 drivers/usb/serial/ipaq.c                          |  357 +---
 drivers/usb/serial/ipaq.h                          |   54 -
 drivers/usb/serial/ipw.c                           |  184 +--
 drivers/usb/serial/ir-usb.c                        |  272 +--
 drivers/usb/serial/iuu_phoenix.c                   |   30 +-
 drivers/usb/serial/kl5kusb105.c                    |  436 +---
 drivers/usb/serial/kl5kusb105.h                    |   47 +-
 drivers/usb/serial/kobil_sct.c                     |    3 +-
 drivers/usb/serial/kobil_sct.h                     |   75 +-
 drivers/usb/serial/mct_u232.c                      |    7 +-
 drivers/usb/serial/mct_u232.h                      |  254 ++-
 drivers/usb/serial/mos7720.c                       | 1130 +++++++---
 drivers/usb/serial/mos7840.c                       |    1 -
 drivers/usb/serial/option.c                        |  841 ++-----
 drivers/usb/serial/oti6858.c                       |  254 +--
 drivers/usb/serial/pl2303.c                        |  430 +----
 drivers/usb/serial/pl2303.h                        |    6 +-
 drivers/usb/serial/qcaux.c                         |    5 +
 drivers/usb/serial/qcserial.c                      |   64 +-
 drivers/usb/serial/safe_serial.c                   |  231 +--
 drivers/usb/serial/spcp8x5.c                       |  407 +---
 drivers/usb/serial/ti_usb_3410_5052.c              |  179 +--
 drivers/usb/serial/usb-serial.c                    |   47 +-
 drivers/usb/serial/usb-wwan.h                      |   67 +
 drivers/usb/serial/usb_debug.c                     |   12 +-
 drivers/usb/serial/usb_wwan.c                      |  665 ++++++
 drivers/usb/serial/visor.c                         |  344 +---
 drivers/usb/serial/visor.h                         |    9 +-
 drivers/usb/serial/zio.c                           |   64 +
 drivers/usb/storage/isd200.c                       |    4 +-
 drivers/usb/storage/onetouch.c                     |   12 +-
 drivers/usb/storage/transport.c                    |    2 -
 drivers/usb/storage/unusual_devs.h                 |   24 +-
 drivers/usb/storage/usb.c                          |   87 +-
 drivers/usb/storage/usb.h                          |    3 +-
 drivers/usb/usb-skeleton.c                         |   10 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    2 -
 drivers/usb/wusbcore/wusbhc.h                      |    4 +-
 drivers/watchdog/pcwd_usb.c                        |    6 +-
 fs/timerfd.c                                       |   25 +-
 include/linux/usb.h                                |  137 +-
 include/linux/usb/Kbuild                           |    1 +
 include/linux/usb/atmel_usba_udc.h                 |    2 +-
 include/linux/usb/audio.h                          |    6 +-
 include/linux/usb/cdc.h                            |   94 +
 drivers/usb/core/hub.h => include/linux/usb/ch11.h |   60 +-
 include/linux/usb/ch9.h                            |   16 +-
 include/linux/usb/composite.h                      |    1 +
 include/linux/usb/ehci_def.h                       |    6 +-
 include/linux/usb/functionfs.h                     |  199 ++
 include/linux/usb/g_hid.h                          |   32 +
 include/linux/usb/gadget.h                         |    6 +-
 include/linux/usb/gadgetfs.h                       |    2 +-
 {drivers/usb/core => include/linux/usb}/hcd.h      |   75 +-
 include/linux/usb/langwell_udc.h                   |    2 +-
 include/linux/usb/musb.h                           |   40 +-
 include/linux/usb/ncm.h                            |  114 +
 include/linux/usb/net2280.h                        |    6 +-
 include/linux/usb/quirks.h                         |    4 +
 include/linux/usb/rndis_host.h                     |   70 +-
 include/linux/usb/serial.h                         |   36 +-
 include/linux/usb/ulpi.h                           |  140 ++
 include/linux/usb/usbnet.h                         |   40 +-
 include/linux/usb/wusb-wa.h                        |    2 +-
 include/linux/wait.h                               |  149 ++
 kernel/sched.c                                     |    1 +
 sound/usb/ua101.c                                  |   16 +-
 sound/usb/usbaudio.c                               |   18 +-
 sound/usb/usbmidi.c                                |   14 +-
 tools/usb/ffs-test.c                               |  554 +++++
 tools/usb/testusb.c                                |  547 +++++
 262 files changed, 17254 insertions(+), 8372 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-bus-usb
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
 create mode 100644 Documentation/usb/bulk-streams.txt
 create mode 100644 Documentation/usb/gadget_hid.txt
 create mode 100644 drivers/usb/gadget/f_fs.c
 create mode 100644 drivers/usb/gadget/f_hid.c
 create mode 100644 drivers/usb/gadget/f_uvc.c
 create mode 100644 drivers/usb/gadget/f_uvc.h
 rename drivers/usb/gadget/{fsl_mx3_udc.c => fsl_mxc_udc.c} (89%)
 create mode 100644 drivers/usb/gadget/g_ffs.c
 create mode 100644 drivers/usb/gadget/hid.c
 create mode 100644 drivers/usb/gadget/uvc.h
 create mode 100644 drivers/usb/gadget/uvc_queue.c
 create mode 100644 drivers/usb/gadget/uvc_queue.h
 create mode 100644 drivers/usb/gadget/uvc_v4l2.c
 create mode 100644 drivers/usb/gadget/uvc_video.c
 create mode 100644 drivers/usb/gadget/webcam.c
 create mode 100644 drivers/usb/host/ohci-omap3.c
 create mode 100644 drivers/usb/musb/musb_debugfs.c
 delete mode 100644 drivers/usb/serial/ipaq.h
 create mode 100644 drivers/usb/serial/usb-wwan.h
 create mode 100644 drivers/usb/serial/usb_wwan.c
 create mode 100644 drivers/usb/serial/zio.c
 rename drivers/usb/core/hub.h => include/linux/usb/ch11.h (72%)
 create mode 100644 include/linux/usb/functionfs.h
 create mode 100644 include/linux/usb/g_hid.h
 rename {drivers/usb/core => include/linux/usb}/hcd.h (89%)
 create mode 100644 include/linux/usb/ncm.h
 create mode 100644 tools/usb/ffs-test.c
 create mode 100644 tools/usb/testusb.c

---------------

Ajay Kumar Gupta (3):
      usb: musb: Add extvbus in musb_board_data
      usb: ehci-omap: fix compilation warning
      USB: ehci-omap: fix Si version related programming

Alan Stern (15):
      USB: remove bogus USB_PORT_FEAT_*_SPEED symbols
      USB: straighten out port feature vs. port status usage
      USB: remove uses of URB_NO_SETUP_DMA_MAP
      USB: fix usbmon and DMA mapping for scatter-gather URBs
      USB: improve runtime remote wakeup settings
      USB: don't enable remote wakeup by default
      USB: use PM core routines to enable/disable autosuspend
      USB: deprecate the power/level sysfs attribute
      USB: remove leftover references to udev->autosuspend_disabled
      USB: export the new ch11.h file to userspce
      USB: remove the usb_host_ss_ep_comp structure
      USB: remove URB_NO_SETUP_DMA_MAP
      USB: simplify usb_sg_init()
      USB: fix interface runtime-PM settings
      USB: EHCI: fix controller wakeup flag settings during suspend

Alek Du (1):
      USB: EHCI: clear PHCD before resuming

Alessio Igor Bogani (3):
      USB: sisusbvga: Remove the BKL from ioctl
      USB: sisusbvga: Remove the BKL from open
      USB: mos7840: Cleanup useless header

Anand Gadiyar (6):
      usb: musb: omap2430: remove unused define
      usb: musb: omap2430.c: remove unnecessary includes
      USB: omap3: add platform init code for OHCI driver
      USB: ohci: introduce omap3 ohci-hcd driver
      USB: ohci: Add Kconfig entries for ohci-omap3
      USB: ehci-omap: Fix resume failures after bus suspend

Andiry Xu (2):
      USB: usbcore: Do not disable USB3 protocol ports in hub_activate()
      USB: xHCI: Fix wrong usage of macro TRB_TYPE

Anssi Hannula (1):
      USB: qcserial: Add support for Qualcomm Gobi 2000 devices

Anton Vorontsov (2):
      USB: isp1760: Soften DW3 X/transaction error bit handling
      USB: FHCI: cq_get() should check kfifo_out()'s return value

Bill Pemberton (4):
      USB: whci: declare functions as static
      USB: oti6858: declare send_data() as static
      usb: sisusb_con.c: fix shadows sparse warning
      usb: u132-hcd.c: fix shadows sparse warning

Carlos Sánchez Acosta (1):
      USB: devices: fix Coding Styles

Cliff Cai (2):
      USB: musb: allow the Blackfin vrsel gpio to be active low
      USB: musb: support host/gadget role switching on Blackfin parts

Craig Shelley (1):
      USB: CP210x New Device IDs 11 New device IDs

Dan Williams (1):
      USB: qcaux: add Samsung U520 device ID

Daniel Mack (1):
      USB: rename usb_buffer_alloc() and usb_buffer_free() users

David Brownell (1):
      USB: testusb: an USB testing application

David Miller (1):
      USB: ehci: Elide I/O watchdog on NEC parts

Dinh Nguyen (2):
      USB: mxc: gadget: Fix bitfield for calculating maximum packet size
      USB: mxc: gadget: remove 60mhz clock requirement for freescale mx51 usb core

Eric Lescouet (3):
      USB: make hcd.h public (drivers dependency)
      USB: make hub.h public (drivers dependency)
      USB: split hub.h into ch11.h and merge-in hcd.h

Eric Raymond (1):
      USB: Short new 'graph for usb-serial.txt

Fabien Chouteau (3):
      USB: gadget: add HID gadget driver
      USB: Composite framework: Add suspended sysfs entry
      USB: Mass storage gadget: Handle eject request

Felipe Balbi (6):
      usb: musb: allow board to pass down fifo mode
      usb: musb: add debugfs support
      usb: musb: gadget: support musb-specific test modes
      usb: musb: hsdma: use musb_read/writel
      usb: musb: debugfs: musb_exit_debugfs() can be called on probe
      usb: musb: Makefile: remove unexistent config option

Felipe Contreras (2):
      USB: usb-storage: trivial debug improvements
      usb-storage: always print quirks

Greg Kroah-Hartman (14):
      USB: staging: fix up usb_buffer_alloc calls in the staging tree
      USB: mct_u232.h: checkpatch cleanups
      USB: belkin_sa.h: checkpatch cleanups
      USB: cypress_m8.h: checkpatch cleanups
      USB: ftdi_sio: checkpatch cleanups
      USB: io_edgeport: checkpatch cleanups
      USB: kl5kusb105.h: checkpatch cleanups
      USB: kobil_sct.h: checkpatch cleanups
      USB: pl2303.h: checkpatch cleanups
      USB: visor.h: checkpatch cleanups
      USB: usb.h: checkpatch cleanups
      USB: include/usb/*.h checkpatch cleanup
      USB: xhci: fix compiler warning.
      USB: remove unused usb_buffer_alloc and usb_buffer_free macros

Hans de Goede (2):
      USB: Add a new quirk: USB_QUIRK_HONOR_BNUMINTERFACES
      USB: unusual-dev: Add bad sense flag for Appotech ax203 based picture frames

Heikki Krogerus (4):
      usb: musb: add ulpi access operations
      usb: otg: add global ULPI register definitions
      USB: otg: ulpi: use the global ULPI register definitions
      usb: otg: twl4030: use the global ULPI register definitions

Huang Weiyi (1):
      USB: remove duplicated #include

Ian Munsie (1):
      USB: Remove large struct from the stack in USB storage isd200 driver

James Maki (1):
      USB: option.c: option_indat_callback: Resubmit some unsuccessful URBs

Jason Wessel (2):
      usb-serial: Use tty_port version console instead of usb_serial_port
      usb-console: pass baud from console to the initial tty open

Javier Blanco de Torres (Neurowork) (1):
      USB: ueagle: fix Coding Styles

Johan Hovold (73):
      USB: serial: allow drivers to define bulk buffer sizes
      USB: cp210x: increase the bulk-out buffer size to 256 byte
      USB: cp210x: increase bulk-in buffer size to 256 byte
      USB: pl2303: increase the bulk-out buffer size to 256 byte
      USB: pl2303: increase bulk-in buffer size to 256 byte
      USB: serial: fix generic chars_in_buffer
      USB: serial: fix missing locking on fifo in write callback
      USB: serial: clear fifo on close
      USB: serial: refactor generic close
      USB: serial: refactor read urb submission in generic driver
      USB: serial: remove unnecessary re-initialisation of generic urbs
      USB: cp210x: use generic submit_read_urb at open
      USB: serial: clean up read processing in generic driver
      USB: serial: generalise generic read implementation
      USB: pl2303: switch to generic read implementation
      USB: serial: export generic throttle and unthrottle
      USB: ftdi_sio: switch to generic read implementation
      USB: serial: clean up some error and debug messages in generic driver
      USB: serial: clean up generic write start busy test
      USB: pl2303: switch to generic write implementation
      USB: pl2303: use generic close
      USB: usb_debug: use the generic kfifo-based write implementation
      USB: serial: allow custom multi-urb write bulk callbacks
      USB: serial: re-implement multi-urb writes in generic driver
      USB: serial: generalise write buffer preparation
      USB: ftdi_sio: fix some coding style issues
      USB: ftdi_sio: switch to generic write implementation
      USB: ftdi_sio: clean up SIO write support
      USB: aircable: rewrite using generic read and write implementations
      USB: serial: reimplement generic fifo-based writes
      USB: serial: remove multi-urb write from generic driver
      USB: tty: fix incorrect use of tty_insert_flip_string_fixed_flag
      USB: ark3116: reimplement read processing
      USB: ftdi_sio: use tty_insert_flip_string_fixed_flag
      USB: pl2303: use tty_insert_flip_string_fixed_flag
      USB: ftdi_sio: clean up line-status handling
      USB: ir-usb: fix double free
      USB: ir-usb: allow custom bulk buffer size without reallocation
      USB: ir-usb: fix set_termios race
      USB: ir-usb: reimplement using generic framework
      USB: ipw: clean up dtr-rts handling
      USB: ipw: remove dummy port_probe and port_remove
      USB: ipw: reimplement using generic framework
      USB: cp210x: remove redundant disconnect()
      USB: kobil: fix memory leak
      USB: serial: add special case for processing of empty read urbs
      USB: empeg: reimplement using generic framework
      USB: ipaq: reimplement using generic framework
      USB: spcp8x5: reimplement using generic framework
      USB: visor: fix memory leak
      USB: visor: reimplement using generic framework
      USB: cp210x: use generic open to start reading from device
      USB: belkin_sa: minor clean-ups
      USB: belkin_sa: clean up open
      USB: belkin_sa: implement line status handling
      USB: visor: increase bulk-out buffer size
      USB: usb_debug: set bulk out size at probe
      USB: cypress_m8: remove unused drain define
      USB: cypress_m8: use kfifo to implement write buffering
      USB: oti6858: use kfifo to implement write buffering
      USB: oti6858: use port write fifo
      USB: safe_serial: reimplement write using generic framework
      USB: safe_serial: reimplement read using generic framework
      USB: safe_serial: straighten out read processing
      USB: aircable: fix incorrect write-buffer length
      USB: ir-usb: fix incorrect write-buffer length
      USB: ti_usb: use kfifo to implement write buffering
      USB: io_ti: remove unsused private counter
      USB: io_ti: use kfifo to implement write buffering
      USB: kl5usb105: fix memory leak
      USB: kl5usb105: minor clean ups
      USB: kl5usb105: reimplement using generic framework
      USB: ftdi_sio: fix legacy SIO-device header

John Youn (1):
      USB: xhci: Transfer ring link TRB activation change.

Julia Lawall (2):
      USB: io_edgeport: Use kzalloc
      USB: gadget: Use kmemdup

Laurent Pinchart (2):
      USB gadget: video class function driver
      USB gadget: Webcam device

Manuel Lauss (1):
      USB: ehci-au1xxx does not need EHCI IO watchdog

Matt Reimer (1):
      USB: pxa27x_udc: use four bits to store endpoint addresses

Matthew Garrett (3):
      usb serial: Add generic USB wwan support
      USB: option: Use generic USB wwan code
      USB: qcserial: Use generic USB wwan code

Matthew Wilcox (4):
      USB: Add definition for the Pipe Usage descriptor
      USB: Add a usb_pipe_endpoint() convenience function
      USB: Turn interface_to_usbdev into an inline function
      USB: Change the scatterlist type in struct urb

Maulik Mankad (3):
      usb: musb: Set transceiver interface type
      USB: MUSB: Build MUSB driver for OMAP4
      USB: MUSB: Add OMAP4 support in MUSB driver

Michal Nazarewicz (11):
      USB: f_mass_storage: dynamic buffers for better alignment
      USB: gadget: f_mass_storage: per function
      USB: core: config.c: usb_get_configuration() simplified
      wait_event_interruptible_locked() interface
      fs/timerfd.c: make use of wait_event_interruptible_locked_irq()
      USB: gadget: __init and __exit tags removed
      USB: f_fs: the FunctionFS driver
      USB: g_ffs: the FunctionFS gadget driver
      USB: ffs-test: FunctionFS testing program
      USB: testusb: testusb compatibility with FunctionFS gadget
      USB: gadget: f_mass_storage: fix in error recovery

Mike Dunn (2):
      USB: usbserial: mos7720: add support for parallel port on moschip 7715
      USB: usbserial: mos7720: cleanup, consolidation, replace send_mos_cmd with {read,write}_mos_reg

Ming Lei (3):
      USB: add missing "{}" in map_urb_for_dma
      USB: remove usb_find_device
      USB: remove match_device

Nils Radtke (1):
      USB: option.c: OLIVETTI OLICARD100 support

Peter Korsgaard (1):
      USB: g_hid: unregister platform driver on probe/usb_composite_register errors

Phil Dibowitz (1):
      USB: storage: Remove unneeded SL11R unusual_devs entry

Randy Dunlap (8):
      USB: cdc-acm: make bitfields unsigned
      usb: fix serial build when SYSRQ is disabled
      USB: usbserial: fix mos7720 dependencies
      USB: clean up some host controller sparse warnings
      USB: gadget webcam: depends on VIDEO_DEV
      USB: fix u132-hcd code/data warning
      USB: gadget: f_fs.c needs to include pagemap.h
      USB: fix functionfs for CONFIG_NET disabled

Robert Lukassen (2):
      usb: gadget: Allow larger configuration descriptors
      USB: gadget: Allow function access to device ID data during bind()

Sarah Sharp (10):
      USB: xhci: Fix issue with set interface after stall.
      USB: xhci: Limit bus sg_tablesize to 62 TRBs.
      USB: xhci: Fix check for room on the ring.
      USB: Add parsing of SuperSpeed endpoint companion descriptor.
      USB: Add stream ID field to struct urb.
      USB: xhci: Add memory allocation for USB3 bulk streams.
      USB: xhci: Correct assumptions about number of rings per endpoint.
      USB: Support for allocating USB 3.0 streams.
      USB: xhci: Avoid double free after streams are disabled.
      USB: xhci: Set stream ID to 0 after cleaning up stalls.

Sergei Shtylyov (4):
      MUSB: OMAP: remove omap_vbus_power()
      MUSB: Blackfin: remove bfin_vbus_power()
      MUSB: OMAP: make musb_platform_suspend() 'static'
      MUSB: Blackfin: remove musb_platform_{suspend|resume}()

Tejun Heo (1):
      usb: musb: update gfp/slab.h includes

Tobias Klauser (1):
      USB: isp1760: Use resource_size

Vijay Kumar (1):
      USB Serial Driver: ZIO Motherboard

Viral Mehta (1):
      USB: omap: switch to subsys_initcall for isp1301 transceiver

William Gulland (1):
      USB: xhci: Remove the arbitrary limit of 15 xHCI ports

Yauheni Kaliuta (2):
      usb: cdc: ncm constants and structures added
      USB: ncm: added ncm.h with auxiliary definitions

zhao1980ming (1):
      USB: option: add PID for ZTE product

