Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab1GVVFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:05:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab1GVVFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:05:49 -0400
Date: Fri, 22 Jul 2011 23:05:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1107222259390.7300@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive 3.1 merge window updates for HID layer.

It's mostly about adding support for new devices (both into existing 
drivers and adding completely new drivers, such as David Herrmann's 
Nintendo Wiimote driver).

Thanks.

Anssi Hannula (1):
      HID: add FF support for Holtek On Line Grip based gamepads

Ari Savolainen (1):
      HID: fix horizontal wheel for ms comfort mouse 4500

Axel Lin (4):
      HID: ACRUX - add missing hid_hw_stop() in ax_probe() error path
      HID: emsff: properly handle emsff_init failure
      HID: prodikeys: make needlessly global symbols static
      HID: prodikeys: remove a redundant forward declaration of struct pcmidi_snd

David Herrmann (12):
      HID: wiimote: Add Nintendo Wii Remote driver stub
      HID: wiimote: Register wiimote hid driver stub
      HID: wiimote: Add wiimote device structure
      HID: wiimote: Register input device in wiimote hid driver
      HID: wiimote: Synchronize wiimote input and hid event handling
      HID: wiimote: Add wiimote send function
      HID: wiimote: Add output queue for wiimote driver
      HID: wiimote: Add wiimote event handler
      HID: wiimote: Add wiimote input button parser
      HID: wiimote: Add wiimote led request
      HID: wiimote: Cache wiimote led state
      HID: wiimote: Add sysfs support to wiimote driver

Jiri Kosina (2):
      HID: add support for MS Digital Media 3000
      HID: fix support for Microsoft comfort mouse 4500

Michael Bauer (1):
      HID: Fix Logitech Driving Force Pro wheel

Nikolai Kondrashov (1):
      HID: uclogic: Add support for UC-Logic WP1062

Simon Wood (2):
      HID: hid-sony: amend Sixaxis descriptor to enable accelerometers
      HID: hid-sony: fix endiannes of Sixaxis accel/gyro values

Stefan Achatz (4):
      HID: roccat: Add "Roccat Talk" support for koneplus
      HID: roccat: chang Kconfig menu to submenu for roccat devices
      HID: roccat: correction and cleanup of HID feature reports
      HID: roccat: fix NULL pointer dereference, add range checks

Stefan Kriwanek (1):
      HID: Add driver to fix Speedlink VAD Cezanne support

Tomoki Sekiyama (1):
      HID: yurex: recognize GeneralKeys wireless presenter as generic HID

ice chien (1):
      HID: hid-multitouch: add one new multitouch device's VID/PID

 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |    8 +
 Documentation/ABI/testing/sysfs-driver-hid-wiimote |   10 +
 drivers/hid/Kconfig                                |   44 ++-
 drivers/hid/Makefile                               |    3 +
 drivers/hid/hid-axff.c                             |    1 +
 drivers/hid/hid-core.c                             |   13 +-
 drivers/hid/hid-emsff.c                            |    7 +-
 drivers/hid/hid-holtekff.c                         |  240 ++++++++++
 drivers/hid/hid-ids.h                              |   15 +
 drivers/hid/hid-lg.c                               |   74 +++-
 drivers/hid/hid-microsoft.c                        |   28 +-
 drivers/hid/hid-multitouch.c                       |    4 +
 drivers/hid/hid-prodikeys.c                        |   17 +-
 drivers/hid/hid-roccat-arvo.c                      |   21 +-
 drivers/hid/hid-roccat-arvo.h                      |   13 -
 drivers/hid/hid-roccat-common.c                    |   20 +-
 drivers/hid/hid-roccat-common.h                    |    4 +-
 drivers/hid/hid-roccat-kone.c                      |   56 ++-
 drivers/hid/hid-roccat-kone.h                      |    2 +-
 drivers/hid/hid-roccat-koneplus.c                  |   49 ++-
 drivers/hid/hid-roccat-koneplus.h                  |   23 +-
 drivers/hid/hid-roccat-kovaplus.c                  |   25 +-
 drivers/hid/hid-roccat-kovaplus.h                  |    9 -
 drivers/hid/hid-roccat-pyra.c                      |   25 +-
 drivers/hid/hid-roccat-pyra.h                      |    9 -
 drivers/hid/hid-sony.c                             |   35 ++
 drivers/hid/hid-speedlink.c                        |   89 ++++
 drivers/hid/hid-uclogic.c                          |  195 ++++++++
 drivers/hid/hid-wiimote.c                          |  489 ++++++++++++++++++++
 drivers/hid/usbhid/hid-core.c                      |    2 +
 include/linux/hid.h                                |    3 +-
 31 files changed, 1397 insertions(+), 136 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-wiimote
 create mode 100644 drivers/hid/hid-holtekff.c
 create mode 100644 drivers/hid/hid-speedlink.c
 create mode 100644 drivers/hid/hid-wiimote.c

-- 
Jiri Kosina
SUSE Labs
