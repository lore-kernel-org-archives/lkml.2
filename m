Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1E0MvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:51:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:47119 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1E0MvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:51:21 -0400
Message-ID: <4DDF9E3E.1060007@infradead.org>
Date: Fri, 27 May 2011 09:51:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 0/4] treewide: Make usb_device_id declarations const
References: <cover.1306473713.git.joe@perches.com>
In-Reply-To: <cover.1306473713.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-05-2011 02:30, Joe Perches escreveu:
> Saves ~40K of data (just objects and directories, allyesconfig)
> 
>    text	   data	    bss	    dec	    hex	filename
> 3651968	 507047	 922836	5081851	 4d8afb	(TOTALS) old
> 3693376	 465727	 922836	5081939	 4d8b53	(TOTALS) new
> 
> Joe Perches (4):
>   treewide: Make usb_device_id declarations const where possible
>   staging: Make usb_device_id declarations const where possible
>   [media] DVB: Make struct dvb_usb_device_description members const
>   [media] DVB: Make declarations of struct usb_device_id const

Patches look ok to me. However, it is probably too late for merging at -rc1.
If they aren't merged for -rc1, the better is to break them per subsystem,
as, if such things would be applied via a common tree (or via USB one), 
it may cause conflicts when those trees got merged upstream, as those
structs generally receive changes during a development cycle. 

> 
>  drivers/bluetooth/ath3k.c                         |    4 ++--
>  drivers/bluetooth/bfusb.c                         |    2 +-
>  drivers/bluetooth/bpa10x.c                        |    2 +-
>  drivers/bluetooth/btusb.c                         |    4 ++--
>  drivers/hid/usbhid/usbkbd.c                       |    2 +-
>  drivers/hid/usbhid/usbmouse.c                     |    2 +-
>  drivers/input/joystick/iforce/iforce-usb.c        |    2 +-
>  drivers/input/joystick/xpad.c                     |    2 +-
>  drivers/input/misc/ati_remote.c                   |    2 +-
>  drivers/input/misc/ati_remote2.c                  |    2 +-
>  drivers/input/misc/keyspan_remote.c               |    2 +-
>  drivers/input/misc/powermate.c                    |    2 +-
>  drivers/input/mouse/appletouch.c                  |    2 +-
>  drivers/input/tablet/acecad.c                     |    2 +-
>  drivers/input/tablet/kbtab.c                      |    2 +-
>  drivers/isdn/hardware/mISDN/hfcsusb.h             |    2 +-
>  drivers/isdn/hisax/hfc_usb.c                      |    2 +-
>  drivers/isdn/hisax/st5481_init.c                  |    2 +-
>  drivers/media/dvb/b2c2/flexcop-usb.c              |    2 +-
>  drivers/media/dvb/dvb-usb/a800.c                  |    2 +-
>  drivers/media/dvb/dvb-usb/af9005.c                |    2 +-
>  drivers/media/dvb/dvb-usb/af9015.c                |    2 +-
>  drivers/media/dvb/dvb-usb/anysee.c                |    2 +-
>  drivers/media/dvb/dvb-usb/au6610.c                |    2 +-
>  drivers/media/dvb/dvb-usb/az6027.c                |    2 +-
>  drivers/media/dvb/dvb-usb/ce6230.c                |    2 +-
>  drivers/media/dvb/dvb-usb/cinergyT2-core.c        |    2 +-
>  drivers/media/dvb/dvb-usb/cxusb.c                 |    2 +-
>  drivers/media/dvb/dvb-usb/dib0700.h               |    2 +-
>  drivers/media/dvb/dvb-usb/dib0700_devices.c       |    2 +-
>  drivers/media/dvb/dvb-usb/dibusb-mb.c             |    2 +-
>  drivers/media/dvb/dvb-usb/dibusb-mc.c             |    2 +-
>  drivers/media/dvb/dvb-usb/digitv.c                |    2 +-
>  drivers/media/dvb/dvb-usb/dtt200u.c               |    2 +-
>  drivers/media/dvb/dvb-usb/dtv5100.c               |    2 +-
>  drivers/media/dvb/dvb-usb/dvb-usb.h               |    4 ++--
>  drivers/media/dvb/dvb-usb/dw2102.c                |    2 +-
>  drivers/media/dvb/dvb-usb/ec168.c                 |    2 +-
>  drivers/media/dvb/dvb-usb/friio.c                 |    2 +-
>  drivers/media/dvb/dvb-usb/gl861.c                 |    2 +-
>  drivers/media/dvb/dvb-usb/gp8psk.c                |    2 +-
>  drivers/media/dvb/dvb-usb/lmedm04.c               |    2 +-
>  drivers/media/dvb/dvb-usb/m920x.c                 |    2 +-
>  drivers/media/dvb/dvb-usb/nova-t-usb2.c           |    2 +-
>  drivers/media/dvb/dvb-usb/opera1.c                |    2 +-
>  drivers/media/dvb/dvb-usb/technisat-usb2.c        |    2 +-
>  drivers/media/dvb/dvb-usb/ttusb2.c                |    2 +-
>  drivers/media/dvb/dvb-usb/umt-010.c               |    2 +-
>  drivers/media/dvb/dvb-usb/vp702x.c                |    2 +-
>  drivers/media/dvb/dvb-usb/vp7045.c                |    2 +-
>  drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
>  drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    2 +-
>  drivers/media/radio/dsbr100.c                     |    2 +-
>  drivers/media/radio/radio-mr800.c                 |    2 +-
>  drivers/media/radio/si470x/radio-si470x-usb.c     |    2 +-
>  drivers/media/rc/imon.c                           |    2 +-
>  drivers/media/rc/mceusb.c                         |    2 +-
>  drivers/media/rc/redrat3.c                        |    2 +-
>  drivers/media/rc/streamzap.c                      |    2 +-
>  drivers/media/video/au0828/au0828-cards.c         |    2 +-
>  drivers/media/video/au0828/au0828.h               |    2 +-
>  drivers/media/video/cpia2/cpia2_usb.c             |    2 +-
>  drivers/media/video/cx231xx/cx231xx-cards.c       |    2 +-
>  drivers/media/video/cx231xx/cx231xx.h             |    2 +-
>  drivers/media/video/em28xx/em28xx-cards.c         |    2 +-
>  drivers/media/video/em28xx/em28xx.h               |    2 +-
>  drivers/media/video/hdpvr/hdpvr-core.c            |    2 +-
>  drivers/media/video/pvrusb2/pvrusb2-devattr.c     |    2 +-
>  drivers/media/video/pvrusb2/pvrusb2-devattr.h     |    2 +-
>  drivers/media/video/s2255drv.c                    |    2 +-
>  drivers/media/video/stk-webcam.c                  |    2 +-
>  drivers/media/video/tlg2300/pd-main.c             |    2 +-
>  drivers/media/video/usbvision/usbvision-cards.c   |    2 +-
>  drivers/media/video/usbvision/usbvision.h         |    2 +-
>  drivers/media/video/uvc/uvc_driver.c              |    2 +-
>  drivers/media/video/zr364xx.c                     |    2 +-
>  drivers/mmc/host/ushc.c                           |    2 +-
>  drivers/mmc/host/vub300.c                         |    2 +-
>  drivers/net/can/usb/ems_usb.c                     |    2 +-
>  drivers/net/can/usb/esd_usb2.c                    |    2 +-
>  drivers/net/irda/irda-usb.c                       |    2 +-
>  drivers/net/irda/kingsun-sir.c                    |    2 +-
>  drivers/net/irda/ks959-sir.c                      |    2 +-
>  drivers/net/irda/ksdazzle-sir.c                   |    2 +-
>  drivers/net/irda/mcs7780.c                        |    2 +-
>  drivers/net/irda/stir4200.c                       |    2 +-
>  drivers/net/usb/catc.c                            |    2 +-
>  drivers/net/usb/cdc-phonet.c                      |    2 +-
>  drivers/net/usb/ipheth.c                          |    2 +-
>  drivers/net/usb/kaweth.c                          |    2 +-
>  drivers/net/usb/rtl8150.c                         |    2 +-
>  drivers/net/wimax/i2400m/usb.c                    |    3 +--
>  drivers/net/wireless/at76c50x-usb.c               |    2 +-
>  drivers/net/wireless/ath/ath9k/hif_usb.c          |    2 +-
>  drivers/net/wireless/ath/carl9170/usb.c           |    2 +-
>  drivers/net/wireless/libertas/if_usb.c            |    2 +-
>  drivers/net/wireless/libertas_tf/if_usb.c         |    2 +-
>  drivers/net/wireless/orinoco/orinoco_usb.c        |    2 +-
>  drivers/net/wireless/rt2x00/rt2500usb.c           |    2 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c           |    2 +-
>  drivers/net/wireless/rt2x00/rt73usb.c             |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |    2 +-
>  drivers/net/wireless/zd1201.c                     |    2 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c            |    2 +-
>  drivers/staging/bcm/InterfaceInit.c               |    2 +-
>  drivers/staging/easycap/easycap_main.c            |    2 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c    |    2 +-
>  drivers/staging/keucr/usb.c                       |    2 +-
>  drivers/staging/lirc/lirc_igorplugusb.c           |    2 +-
>  drivers/staging/lirc/lirc_imon.c                  |    6 +++---
>  drivers/staging/lirc/lirc_sasem.c                 |    2 +-
>  drivers/staging/lirc/lirc_ttusbir.c               |    2 +-
>  drivers/staging/rtl8712/usb_intf.c                |    2 +-
>  drivers/staging/tm6000/tm6000-cards.c             |    2 +-
>  drivers/staging/usbip/stub_dev.c                  |    2 +-
>  drivers/staging/wlan-ng/prism2usb.c               |    2 +-
>  drivers/usb/atm/speedtch.c                        |    2 +-
>  drivers/usb/core/otg_whitelist.h                  |    4 ++--
>  drivers/usb/host/hwa-hc.c                         |    2 +-
>  drivers/usb/misc/yurex.c                          |    2 +-
>  drivers/usb/serial/ftdi_sio.c                     |    2 +-
>  drivers/usb/serial/ipaq.c                         |    2 +-
>  drivers/usb/serial/qcaux.c                        |    2 +-
>  drivers/usb/serial/visor.c                        |   10 +++++-----
>  drivers/usb/serial/vivopay-serial.c               |    2 +-
>  drivers/usb/storage/alauda.c                      |    2 +-
>  drivers/usb/storage/cypress_atacb.c               |    2 +-
>  drivers/usb/storage/datafab.c                     |    2 +-
>  drivers/usb/storage/ene_ub6250.c                  |    2 +-
>  drivers/usb/storage/freecom.c                     |    2 +-
>  drivers/usb/storage/isd200.c                      |    2 +-
>  drivers/usb/storage/jumpshot.c                    |    2 +-
>  drivers/usb/storage/karma.c                       |    2 +-
>  drivers/usb/storage/onetouch.c                    |    2 +-
>  drivers/usb/storage/sddr09.c                      |    2 +-
>  drivers/usb/storage/sddr55.c                      |    2 +-
>  drivers/usb/storage/shuttle_usbat.c               |    2 +-
>  drivers/usb/storage/uas.c                         |    2 +-
>  drivers/usb/storage/usual-tables.c                |    2 +-
>  drivers/video/udlfb.c                             |    2 +-
>  drivers/w1/masters/ds2490.c                       |    2 +-
>  drivers/watchdog/pcwd_usb.c                       |    2 +-
>  include/linux/usb_usual.h                         |    2 +-
>  sound/usb/6fire/chip.c                            |    2 +-
>  sound/usb/caiaq/device.c                          |    2 +-
>  sound/usb/misc/ua101.c                            |    2 +-
>  sound/usb/usx2y/us122l.c                          |    2 +-
>  sound/usb/usx2y/usbusx2y.c                        |    2 +-
>  148 files changed, 158 insertions(+), 159 deletions(-)
> 

