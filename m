Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0FBBwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 21:52:41 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:58201 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab0FBBwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 21:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=abLHBAUFw4DOZIID0+oTuAJfMXI1J918wv49Pe7L90+15CA7eHopZr9zAHKf3GkBrB
         N/3Gz6shZO4RZSdQXNaud02WWUq74AP8tdOSPvgchDGSq4ons0Bz4Hhf7GI1OgwTlyZ8
         yg5QzkioWxoK3nm5ebMKD2KL8+O6sLjLvJFWE=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Jun 2010 18:52:18 -0700
Message-ID: <AANLkTilzHq0UR5pBSxy41NvW3MhL7srW-1z0A0hbeDjd@mail.gmail.com>
Subject: Sheep on Meth is out with wings (?) - compat-wireless for 
	linux-2.6.35-rc1
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sheep (Linus?) got on meth (Red Bull?) this weekend with a 2.6.35
release (huge guess on the meaning :)) so we get to give it wings with
a respective compat-wireless stable release [1] tarball based on it
[2]. This gives us the 2.6.35 802.11 subsystem, bluetooth subsystem
and new 802.11/bluetooth drivers (and a few Ethernet drivers [atlc1,
atl1e, atl1, atl2, b44]) compilable and installable on older kernels.
Please report any issues ASAP. For details on changes you can refer to
the ChangeLog-2.6.35-wireless [3].

While at it I went ahead and updated the older compat-wireless releases from:

compat-wireless-2.6.32.11.tar.bz2 --> compat-wireless-2.6.32.15.tar.bz2
compat-wireless-2.6.33.5.tar.bz2   --> compat-wireless-2.6.33.5.tar.bz2

The 2.6.34 kernel has not received a new extra version update yet so
that remains the same.

The $(git shortlog linux-2.6.34.y..linux-2.6.35.y) for the generic
kernel compatibility module [4] is:

Hauke Mehrtens (3):
      compat: backport eth_change_mtu and eth_validate_addr
      compat: move kparam_{block,unblock}_sysfs_write
      compat: move usb_{alloc,free}_coherent

Luis R. Rodriguez (11):
      compat: add new way to backport the usage of net_device_ops
      compat: add the rest of the missing netdev_attach_ops()
      compat: add the ndo_select_queue for netdev_attach_ops()
      compat: add compat_version read-only module parameter
      Modify the compat print
      Add the COMPAT_BASE_TREE and COMPAT_BASE_TREE_VERSION
      Add a COMPAT_PROJECT tag
      Fix the syntax for the defines passed for compat
      Remove the stupid SET_NETDEVOP
      compat: create the udev directories for compat_firmware file
      compat: backport USHRT_MAX, SHRT_MAX and SHRT_MIN


The $(git shortlog linux-2.6.34.y..linux-2.6.35.y) for compat-wireless
for this release so far is:

Bruno Randolf (1):
      compat-wireless: fix 07-change-default-rate-alg.patch

Hauke Mehrtens (22):
      compat-wireless: rename {free,alloc}_ieee80211 to {free,alloc}_libipw
      compat-wireless: fix building of iwmc3200wifi
      compat-wireless: remove some uneeded header files
      compat-wireless: update config symbols
      compat-wireless: add orinoco to compat-wireless
      compat-wireless: remove rename {free,alloc}_ieee80211 patch
      compat-wireless: refresh patch to apply again
      compat-wireless: Backport changes in pcmcia system
      compat-wireless: fix use of device_create
      compat-wireless: use wireless_handlers for wext functions.
      compat-wireless: backport convert multicast list to list_head.
      compat-wireless: Remove use of sdio quirks attribute
      compat-wireless: include net and trace includes form compat.
      compat-wireless: refresh patches
      compat-wireless: updates for orinoco
      compat-wireless: backport pm_qos_{add,remove,update}_request
      compat-wireless: make patches apply again
      Revert "compat-wireless: fix 07-change-default-rate-alg.patch"
      compat-wireless: Update Readme to reflect changes
      compat-wireless: update clean scripts
      compat-wireless: use /etc/init.d/ and not sudo service
      compat-wireless: run refresh only on last applied directory

Luis R. Rodriguez (71):
      ./scripts/admin-update.sh  refresh
      ./scripts/admin-update.sh refres
      admin-update refresh the patches
      driver-select: enable listing of ath9k_htc
      driver-select: fix selecting ath9k_htc
      admin-update refresh
      Fix patches/06-header-changes.patch
      Fix patches/13-trace.patch
      admin-update refresh
      admin-update refresh
      admin-update refresh
      Update USB makefile for new driver ipheth.o
      ./scripts/admin-update.sh refresh
      compat-wireless: make use of new netdev_attach_ops() for orinoco
      scripts/admin-update.sh refresh
      Make rndis_host use netdev_attach_ops()
      usbnet: use netdev_attach_ops()
      rndis_wlan: fix backport of netdev_attach_ops() usage
      rndis_wlan: use netdev_attach_ops()
      mac80211: use netdev_attach_ops()
      admin-update refresh
      b44: use netdev_attach_ops()
      ipw2100: use netdev_attach_ops()
      ipw2200: use netdev_attach_ops()
      libertas: use netdev_attach_ops()
      mac80211_hwsim: use netdevice_attach_ops()
      bnep, atl1e, atl1c: use netdev_attach_ops()
      atl1: use netdev_attach_ops()
      atl2: use netdev_attach_ops()
      ./scripts/admin-update.sh refresh
      ./scripts/admin-update.sh refresh
      Change admin-update.sh to use system version files
      Remove double line on admin-update.sh
      Split up the NOSTDINC_FLAGS into a few lines
      Use the defines to tag the compat module
      Fix dependency on on WEXT
      Fix the CREL compat-wireless release name on top level Makefile
      Fix gen-compat-autoconf.sh for new version name changes
      Fix scripts/driver-select due to new version changes
      Add the compat to the unload of the modules
      compat-wireless: add linux-next-pending, crap patch dirs and nagometer
      rm -rf drivers when running scripts/admin-update.sh
      compat-wireless: add a set of pending patches for linux-wireless
      compat-wireless: add the Kconfig for drivers
      compat-wireless: add some Atheros crap patches
      compat-wireless: run ./scripts/compat_firmware_install
      compat-wireless: remove some new files upon make clean
      compat-wireless: add the new versioning files to .gitignore
      Revert "compat-wireless: run ./scripts/compat_firmware_install"
      compat-wireless: remove pending patches as of next-20100525
      compat-wireless: ./scripts/admin-update.sh refresh
      compat-wireless: fix backport code calculation
      compat-wireless: only copy existing Kconfig files
      compat-wireless: ./scripts/admin-update.sh -p refresh
      compat-wireless: fix typo for used color for nagometer
      compat-wireless: add new set of pending patches for 2010-05-25
      compat-wireless: update the atheros crap patches
      compat-wireless: clarify usage of linux-next-cherry-pick for bleeding edge
      compat-wireless: remove two pending patches now upstream
      compat-wireless: add pending fix patch for ath9k
      compat-wireless: fixes offsets for
07-change-default-rate-alg.patch for 2.6.35-rc1
      ./scripts/admin-update.sh  refresh
      compat-wireless: fix hunks for crap/0002-ath9k-Add-pktlog-support.patch
      compat-wireless: accept extra arguments for scripts/gen-stable-release.sh
      Remove sucked in patch post 2.6.35-rc1
      compat-wireless: add -n -p -c support for gen-stable-release.sh
      compat-wireless: optimize branch selection on gen-stable-release.sh
      compat-wireless: update the usage() print for gen-stable-release.sh
      compat-wireless: fix target kernel expecations on gen-stable-release.sh
      compat-wireless: Drop all the linux-next-pending patches
      compat-wireless: remove the crap patches

Paul Fertser (1):
      compat-wireless: driver-select: add b43 to the list

Pavel Roskin (9):
      compat-wireless: disable rt2800 if crc_ccitt is not available
      compat-wireless: disable wl1251 SPI and wl1271 if crc7 is not available
      compat-wireless: add support for ath9k_htc
      compat-wireless: update 22-multiqueue.patch for the current linux-next
      compat-wireless: remove patch part dealing with net/net_namespace.h
      compat-wireless: remove 13-trace.patch, it's handled in compat now
      compat-wireless: remove 25-device_create.patch, it's handled by compat
      compat-wireless: find the actual remote URL
      compat-wireless: fix fallbacks for unknown branch, remote or remote URL

Walter Goldens (2):
      compat-wireless, unload rt2800usb
      compat-wireless: rt2x00 added to driver-select

If there are any questions please let me know, I'll push new updates
out as we move along with the rcs for 2.6.35.

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.35/compat-wireless-2.6.35-rc1.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.35/ChangeLog-2.6.35-rc1-wireless
[4] http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat.git;a=summary

  Luis
