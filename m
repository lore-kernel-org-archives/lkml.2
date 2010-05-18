Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0ERB2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:28:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52047 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab0ERB2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=KtJYd1x6m5n+cY/8cc1rhKXa77e85A3EmnpCfO7uXPqWqluNV5UCdQNeHpws+/O4Xl
         xePXP6jUoFQW/JOvGHitPamJynYnP5TyW35RaqHaDhWdRr+Uwo/6U+sf90+ha9h74RR4
         SQRw8zVL2ZsLp7gWlPhcCJbAmkvpqCceX734M=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 17 May 2010 18:27:57 -0700
Message-ID: <AANLkTilqhQ0wsZZ_ZRaZJQQqMxsQ5e5yocNWFj_6yoM4@mail.gmail.com>
Subject: Compat-wireless for 2.6.34 final - 802.11 and bluetooth backported
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
       Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34 was released today and now we get a respective compat-wireless
stable [1] tarball based on it [2]. This gives us the 2.6.34 802.11
subsystem, bluetooth subsystem and new 802.11/bluetooth drivers
compilable and installable on older kernels. Please report any issues
ASAP. For details on changes you can refer to the
ChangeLog-2.6.34-wireless [3].

Worth mentioning for this release is I've updated the version tagging
for compat-wireless to allow distributions/users/developers to keep
better track of what exact revision is being used. This was based on
Pavel Roskin's suggestion to use read-only module parameters which are
kept even if you build this tarball into your kernel somehow. Here is
an example of the new files and example output based on this specific
new tarball release:

$ sudo grep '' /sys/module/compat/parameters/compat_*
/sys/module/compat/parameters/compat_base_tree:linux-2.6-allstable.git
/sys/module/compat/parameters/compat_base_tree_version:v2.6.34
/sys/module/compat/parameters/compat_version:compat-wireless-v2.6.34-6-g0ad438e

Upon loading the compat module you would also see this output:

Compat-wireless backport release: compat-wireless-v2.6.34-6-g0ad438e
Backport based on linux-2.6-allstable.git v2.6.34

Since git describe is being used to describe both the base tree and
the compat-wireless release you will be able to tell how many patches
on top of the base tree have been applied. This should account for any
deltas you have created and reflect that (hope is the delta is always
0 with respect to upstream). In the above example output there are 6
patches on top of the "compat-wireless-v2.6.34" tag I created for the
first release, I then found some bugs due to the new version scheme
changes and fixed some of them, so I have applied 6 patches on top of
the original release.

I should note there are a few modules which *do not* make use of the
compat module but do make use of a lot of the defines at build time,
an example of such a module is rndis_wlan so you'd have to load the
compat module manually to get the above info or run strings on the
module.

With bleeding edge releases you will now get:

$ sudo grep '' /sys/module/compat/parameters/compat_*
/sys/module/compat/parameters/compat_base_tree:linux-next.git
/sys/module/compat/parameters/compat_base_tree_version:next-20100517
/sys/module/compat/parameters/compat_version:compat-wireless-20100517-7-ged07f6b

The respective output upon load is:

Compat-wireless backport release: compat-wireless-20100517-7-ged07f6b
Backport based on linux-next.git next-20100517

If there are any questions please let me know.

On a final note thanks to all those who have contributed to this
2.6.34 release of both the generic kernel compatibility module and
compat-wireless, specially to Haukes and Pavel.

Below is the shortlog linux-2.6.33.y.. of compat-wireless:

Bala Shanmugam (1):
      compat-2.6: New targets to compile bluetooth alone

Hauke Mehrtens (17):
      compat-wireless: Add more functions into netdev oops backport
      compat-wireless: backport kfifo for libertas
      compat-wireless: Backport net_device_ops set_mac_address
      compat-wireless: activate usbnet for kernel > 2.6.28
      compat-wireless: Activate ssb and libertas
      compat-wireless: Add missing file
      This adds a refresh option to admin-update.sh using quilt.
      compat-wireless: Refresh patches
      compat-wireless: small fixes to admin-update.sh
      compat-wireless: Backport netdev_ops select_queue
      compat-wireless: remove device_type in usbnet.c
      compat-wireless: missing ksize export
      compat-wireless: fix constant name
      compat-wireless: fix bluetooth capi build
      compat-wireless: update .gitignore
      compat-wireless: update config options
      compat-wireless: Fix refresh script if no patches are available

Luis R. Rodriguez (55):
      Update patch hunk offsets for next-20091228
      Intel removed uts header, update patch for that
      Update patch hunks for next-20100106
      Remove pointless bt-install-scripts extra target
      Fix iwlagn patch offset breakage
      Update patch 01-netdev.patch offsets
      Update 17-netdev-queue.patch offsets
      Update hunk offsets for 15-symbol-export-conflicts.patch
      Update error message on old unsupported kernels
      Add support for driver-select to enable older kernels
      Stop carrying around bitops.h header
      Stop carrying around pm_qos_params.h
      Stop carrying around the include/linux/unaligned stuff
      Actually copy over the new headers from compat
      Move down bluetooth config.mk options
      Prevent CONFIG_COMPAT_BLUETOOTH_* options from going to compat_autoconf.h
      Disable bluetooth compat for kernels older than 2.6.27
      Enable CONFIG_BT_CMTP only if CONFIG_BT_CMTP is enabled
      Ran ./scripts/admin-update.sh refresh
      Fix driver-select for ath9k and ath5k
      Fix a few typos on config.mk and the new enable olde kernel patches
      Enable 2.6.23 for ath9k and ath5k
      Backport access to pcidev->is_pcie member for kernels < 2.6.24
      Add backport for netns for kernels <= 2.6.24 for 802.11
      Disable 2.6.24 for ath9k and ath5k
      ./scripts/admin-update.sh refresh
      Fix typo on 06-header-changes.patch
      Enable CONFIG_COMPAT_FIRMWARE_CLASS for kernels < 2.6.33
      Fix driver_select for ar9170
      Only build compat_firmware_class if CONFIG_FW_LOADER was enabled
      Copy over the new udev scripts/rules from compat.git
      ./scripts/admin-update.sh refresh
      Run admin-update-.sh refresh for 2010-02-01
      compat-wireless: fix patches/16-bluetooth.patch
      Run ./scripts/admin-update.sh refresh
      Fix patches/16-bluetooth.patch
      Enable CONFIG_BT_ATH3K
      ./scripts/admin-update.sh refresh for next-20100216
      Backport multiqueue support for kernels < 2.6.27
      Add linux-next cherry picked patches directory
      Skip empty patch directories if one is found.
      Some updates to make the patches apply to 2.6.34
      admin-update refresh
      compat-wireless: add test cherry pick patch
      Fix drivers usb Makefile for 2.6.34
      ./scripts/admin-update.sh refresh
      Change admin-update.sh to use system version files
      Split up the NOSTDINC_FLAGS into a few lines
      Use the defines to tag the compat module
      Document /sys/module/compat/parameters/compat_* on README
      Fix dependency on on WEXT
      Fix the CREL compat-wireless release name on top level Makefile
      Fix gen-compat-autoconf.sh for new version name changes
      Fix scripts/driver-select due to new version changes
      Add the compat to the unload of the modules

And the generic kernel compatibility module keeps moving along as
well, here's that shortlog:

Felix Fietkau (2):
      compat: fix firmware class compile on linux 2.6.32
      compat: add rcu_dereference_check

Grazvydas Ignotas (1):
      compat: fix uevent_suppress on 2.6.29 or older kernels

Hauke Mehrtens (19):
      compat: fix two return types
      compat: autoconf.h moved from linux/ to generated/ with kernel 2.6.33
      compat: build pccard and pcmcia condituinaly
      compat: fix build with CONFIG_USB=m
      compat: fix build on arm
      compat: backport genlmsg_unicast
      compat: backport some netdevice.h defs
      compat: backport some more of the netdev debug printk
      compat: fix some build problems with kernel 2.6.24
      compat: backport device_{lock,trylock,unlock}
      compat: update bitops.h
      compat: backport PCMCIA_DEVICE_PROD_ID3
      compat: Backport clamp
      compat: Add definitions needed for libertas sdio driver.
      compat: Add linux/version.h include before using it.
      compat: backport convert multicast list to list_head.
      compat: update compat_firmware_class.c to new version
      compat: backport sk_sleep
      compat: backport usb_alloc_coherent() and usb_free_coherent()

Luis R. Rodriguez (17):
      Add notes about why debugfs_remove_recursive() cannot be backported
      Update for next-20100113
      Backport the new firmware_class from > 2.6.33 down to 2.6.23
      Enable the compat_firmware_class to be built only on < 2.6.32
      Enable 2.6.33 compatibility
      Export CONFIG_COMPAT_FIRMWARE_CLASS
      Fix loading of compat_firmware_class due to class name conflict
      Only build compat_firmware_class if CONFIG_FW_LOADER was enabled
      Fix build with CONFIG_PCMCIA disabled
      Fix build with CONFIG_USB disabled
      Install udev rules and scripts needed for compat_firmware_class
      Add a print for v2.6.34-rc4
      compat: add compat_version read-only module parameter
      Modify compat main print
      Add the COMPAT_BASE_TREE and COMPAT_BASE_TREE_VERSION
      Add a COMPAT_PROJECT tag
      Fix the syntax for the defines passed for compat

Pavel Roskin (9):
      compat: backport for ARM dma_sync_single_range_*() helpers
      compat: backport debugfs_remove_recursive()
      compat: move debugfs_remove_recursive() to compat-2.6.27
      compat: define KEY_RFKILL, which appeared in Linux 2.6.33
      compat: add compat-2.6.35.h and IW_HANDLER
      compat: add qdisc_all_tx_empty for Linux 2.6.26 and older
      compat: add device_create() implementation for Linux 2.6.26 and older
      compat: add stub headers linux/tracepoint.h and trace/define_trace.h
      compat: add net/net_namespace.h stub for Linux 2.6.23 and older

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.34/compat-wireless-2.6.34.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.34/ChangeLog-2.6.34-wireless

  Luis
