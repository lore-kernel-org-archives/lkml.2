Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2LLVyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:54:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab2LLVyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:54:03 -0500
Date: Wed, 12 Dec 2012 22:53:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1212122206330.19767@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID subsystem.

1) Support for HID over I2C bus has been added by Benjamin Tissoires. ACPI 
   device discovery is still in the works.
2) Support for Win8 Multitiouch protocol is being added, most work done by 
   Benjamin Tissoires as well
3) EIO/ERESTARTSYS is fixed in hiddev/hidraw, fixes by Andrew Duggan and 
   Jiri Kosina
4) ION iCade driver added by Bastien Nocera
5) Support for a couple new Roccat devices has been added by Stefan Achatz
6) HID sensor hubs are now auto-detected instead of having to list all the 
   VID/PID combinations in the blacklist array
7) other random fixes and support for new device IDs

Thanks.



Alan Cox (1):
      HID: sensor-hub: Remove pointless NULL check

Alexander Holler (2):
      HID: sensors: autodetect USB HID sensor hubs
      Revert "HID: sensors: add to special driver list"

Andrew Duggan (1):
      HID: hidraw: fix signaling SIGIO when hidraw reports an event

Bastien Nocera (1):
      HID: Add driver for ION iCade

Ben Hutchings (1):
      HID: Add Apple wireless keyboard 2011 ANSI to special driver list

Benjamin Tissoires (31):
      HID: export hidinput_calc_abs_res
      HID: round return value of hidinput_calc_abs_res
      HID: fix unit exponent parsing
      HID: add usage_index in struct hid_usage.
      HID: multitouch: support arrays for the split of the touches in a report
      HID: multitouch: get maxcontacts also from logical_max value
      HID: multitouch: support T and C for win8 devices
      HID: multitouch: move ALWAYS_VALID quirk check
      Input: introduce EV_MSC Timestamp
      Input: mt: add input_mt_is_used
      HID: multitouch: add MT_QUIRK_IGNORE_DUPLICATES
      HID: multitouch: support for hovering devices
      HID: multitouch: fix Win 8 protocol
      HID: usbhid: add quirk HID_QUIRK_NOGET to TPV optical touchscreen
      HID: i2c-hid: introduce HID over i2c specification implementation
      HID: hid-input: factorize hid_input allocation
      HID: i2c-hid: change I2C name
      HID: i2c-hid: enhance Kconfig
      HID: i2c-hid: fix checkpatch.pl warning
      HID: i2c-hid: fix i2c_hid_dbg macro
      HID: i2c-hid: remove unused static declarations
      HID: i2c-hid: fix return paths
      HID: i2c-hid: fix error messages
      HID: i2c-hid: also call i2c_hid_free_buffers in i2c_hid_remove
      HID: i2c-hid: i2c_hid_get_report may fail
      HID: i2c-hid: remove unneeded test in i2c_hid_remove
      HID: i2c-hid: fix memory corruption due to missing hid declaration
      HID: i2c-hid: reorder allocation/free of buffers
      HID: i2c-hid: remove extra .irq field in struct i2c_hid
      HID: i2c-hid: fix i2c_hid_get_raw_report count mismatches
      HID: i2c-hid: add mutex protecting open/close race

Forest Bond (1):
      HID: Ignore D-WAV/eGalax devices handled by usbtouchscreen

Founder Fang (1):
      HID: hidraw: fix nonblock read return EAGAIN after device removed

Ingo Ruhnke (1):
      HID: fix incorrect handling of devices with high button count

Jiri Kosina (5):
      HID: remove spurious brackets for iCade
      HID: i2c-hid: fix memory leak during probe
      HID: hiddev: fix nonblocking read semantics wrt EIO/ERESTARTSYS
      HID: i2c-hid: remove superfluous include
      HID: i2c-hid: fix ret_count check

Johannes Thumshirn (1):
      HID: apple: Set APPLE_ISO_KEYBOARD at USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO

Lamarque V. Souza (1):
      HID: hidp: fallback to input session properly if hid is blacklisted

Marco Biscaro (1):
      HID: add support to novatec wireless mouse

Marek Vasut (1):
      HID: add quirk for Freescale i.MX23 ROM recovery

Ortwin Glück (1):
      HID: add battery quirk for Apple 2009_ISO keyboard

Stefan Achatz (14):
      HID: roccat: add support for Roccat Lua
      HID: roccat: allow readout of koneplus sensor register data
      HID: roccat: add support for KoneXTD
      HID: roccat: enable Savu device reset
      HID: roccat: enable Koneplus device reset
      HID: roccat: Cleanup of koneplus module
      HID: roccat: cleanup of kovaplus module
      HID: roccat: cleanup of pyra module
      HID: roccat: clean up isku driver
      HID: roccat: add sysfs attr "reset" for Isku
      HID: roccat: deprecated some Pyra attributes
      HID: roccat: deprecate some Koneplus attributes
      HID: roccat: deprecate some Kovaplus attributes
      HID: roccat: fix wrong attr size for koneplus tcu

Tushar Behera (1):
      HID: hiddev: Remove redundant check on unsigned variable

 .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  |   38 +
 .../ABI/obsolete/sysfs-driver-hid-roccat-kovaplus  |   66 ++
 .../ABI/obsolete/sysfs-driver-hid-roccat-pyra      |   73 ++
 .../ABI/testing/sysfs-driver-hid-roccat-isku       |    8 +
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   48 +-
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |   69 +--
 .../ABI/testing/sysfs-driver-hid-roccat-lua        |    7 +
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   76 +--
 .../ABI/testing/sysfs-driver-hid-roccat-savu       |    3 +-
 Documentation/input/event-codes.txt                |   11 +
 drivers/hid/Kconfig                                |   11 +
 drivers/hid/Makefile                               |    6 +-
 drivers/hid/hid-apple.c                            |    3 +-
 drivers/hid/hid-core.c                             |   61 +-
 drivers/hid/hid-icade.c                            |  259 ++++++
 drivers/hid/hid-ids.h                              |   19 +-
 drivers/hid/hid-input.c                            |   97 ++-
 drivers/hid/hid-multitouch.c                       |  109 ++-
 drivers/hid/hid-roccat-isku.c                      |   44 +-
 drivers/hid/hid-roccat-isku.h                      |   78 +--
 drivers/hid/hid-roccat-koneplus.c                  |  348 ++-----
 drivers/hid/hid-roccat-koneplus.h                  |  101 +--
 drivers/hid/hid-roccat-kovaplus.c                  |  237 +++---
 drivers/hid/hid-roccat-kovaplus.h                  |   16 +-
 drivers/hid/hid-roccat-lua.c                       |  227 +++++
 drivers/hid/hid-roccat-lua.h                       |   29 +
 drivers/hid/hid-roccat-pyra.c                      |  342 +++----
 drivers/hid/hid-roccat-pyra.h                      |   24 +-
 drivers/hid/hid-roccat-savu.c                      |    4 +-
 drivers/hid/hid-sensor-hub.c                       |   36 +-
 drivers/hid/hidraw.c                               |   16 +-
 drivers/hid/i2c-hid/Kconfig                        |   18 +
 drivers/hid/i2c-hid/Makefile                       |    5 +
 drivers/hid/i2c-hid/i2c-hid.c                      |  979 ++++++++++++++++++++
 drivers/hid/usbhid/hid-quirks.c                    |    3 +
 drivers/hid/usbhid/hiddev.c                        |   10 +-
 drivers/input/input-mt.c                           |    2 +-
 include/linux/hid-sensor-ids.h                     |    1 -
 include/linux/hid.h                                |    6 +
 include/linux/i2c/i2c-hid.h                        |   35 +
 include/linux/input/mt.h                           |    6 +
 include/uapi/linux/input.h                         |    1 +
 net/bluetooth/hidp/core.c                          |    9 +-
 43 files changed, 2491 insertions(+), 1050 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
 create mode 100644 drivers/hid/hid-icade.c
 create mode 100644 drivers/hid/hid-roccat-lua.c
 create mode 100644 drivers/hid/hid-roccat-lua.h
 create mode 100644 drivers/hid/i2c-hid/Kconfig
 create mode 100644 drivers/hid/i2c-hid/Makefile
 create mode 100644 drivers/hid/i2c-hid/i2c-hid.c
 create mode 100644 include/linux/i2c/i2c-hid.h

-- 
Jiri Kosina
SUSE Labs
