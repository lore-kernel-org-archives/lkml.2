Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0KICNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:13:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0KICNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:13:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=h6YJ+NRI+egwVdj4vcr7KzEiEQ+5oYsILNcPk9j7RCFUH0f153ajviAho1RYriQRTw
         VQyOg6plFdN0gTqvv+A1gbiyOtc5IgUdqN86mQUHaKgSlvpecASFF5tM1kiap0DvthDC
         wIyaG2MHEXED1Q4Rw/e2P/YtGq3Jk5wxq0ZNE=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Nov 2010 18:13:19 -0800
Message-ID: <AANLkTi=sVM9LzDMxNaNC_vRU5=b0DgxavbwH8453ADXb@mail.gmail.com>
Subject: Compat-wireless for 2.6.36 final - 802.11 and Bluetooth and Ethernet
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus released 2.6.36 a couple of weeks ago, I was unable to make a
stable release until today since there were some large number of fixes
I want to ensure users get and it has taken me a while to adjust
compat-wireless a little more for this. This time around I am making
two releases though, a vanilla release which does not having anything
cherry picked, pending or stable fixes merged, and a release that does
have these patches applied. The new stable  [1] vanilla
compat-wireless-2.6.36-4 [2] release is a simple backport of what went
in for 802.11, Bluetooth and Ethernet drivers as it is upstream on the
official 2.6.36 release. Next time around I'll simply make the vanilla
release as early as is possible and then later release the -spn
release. The other release has all the other patches for the
compat-wireless-2.6.36-5-spn release [3]. For details on the changes
involved on the vanilla kernel please refer to the
ChangeLog-2.6.36-wireless [4]. I'll update this release as the extra
versions of the kernel move along.

The extra set of patches I collected together are:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ ls -1
pending-stable/
0001-p54usb-fix-off-by-one-on-CONFIG_PM.patch
0002-mac80211-Fix-signal-strength-average-initialization-.patch
0003-ath9k-fix-spurious-MIC-failure-reports.patch
0004-ath9k_hw-handle-rx-key-miss.patch
0005-mac80211-use-correct-station-flags-lock.patch
0006-ath9k-fix-power-save-race-conditions.patch
0007-ath9k-fix-regression-on-beacon-loss-after-bgscan.patch
0008-ath9k-fix-enabling-ANI-tx-monitor-after-bg-scan.patch
0009-mac80211-add-helper-for-reseting-the-connection-moni.patch
0010-mac80211-reset-probe-send-counter-upon-connection-ti.patch
0011-mac80211-reset-connection-idle-when-going-offchannel.patch
0012-mac80211-make-the-beacon-monitor-available-externall.patch
0013-mac80211-disable-beacon-monitor-while-going-offchann.patch
0014-mac80211-send-last-3-5-probe-requests-as-unicast.patch
0015-ath9k-fix-regression-which-prevents-chip-sleep-after.patch
0016-ath9k-fix-regression-which-disabled-ps-on-ath9k.patch
0017-ath9k-fix-an-aggregation-start-related-race-conditio.patch
0018-ath9k-clean-up-fix-aggregation-session-flush.patch
0019-mac80211-clear-txflags-for-ps-filtered-frames.patch
0020-ath9k-Fix-tx-struck-state-with-paprd.patch
0021-mac80211-fix-offchannel-assumption-upon-association.patch
0022-cfg80211-fix-locking.patch
0023-ath9k-fix-channel-flag-regd-issues-with-multiple-car.patch
0024-p54usb-add-five-more-USBIDs.patch
0025-mac80211-fix-channel-assumption-for-association-done.patch
0026-cfg80211-fix-BSS-double-unlinking.patch
0027-mac80211-fix-possible-null-pointer-de-reference.patch
0028-mac80211-minstrel_ht-A-MPDU-fix.patch
0029-ath9k-A-MPDU-rate-control-info-fix.patch
0030-ath9k-built-in-rate-control-A-MPDU-fix.patch
0031-drivers-net-wireless-p54-eeprom.c-Return-ENOMEM-on-m.patch
0032-bluetooth-Fix-missing-NULL-check.patch
0033-mac80211-don-t-sanitize-invalid-rates.patch
0034-cfg80211-fix-regression-on-processing-country-IEs.patch
0035-ath9k_hw-Fix-TX-carrier-leakage-for-IEEE-compliance-.patch
0036-ath9k_hw-Fix-divide-by-zero-cases-in-paprd.patch
0037-mac80211-Fix-ibss-station-got-expired-immediately.patch
0038-ath9k-resume-aggregation-immediately-after-a-hardwar.patch
0039-ath9k-add-locking-for-stopping-RX.patch
0040-ath9k-add-locking-for-starting-the-PCU-on-RX.patch
0041-ath9k-rename-rxflushlock-to-pcu_lock.patch
0043-ath9k-fix-tx-aggregation-flush-on-AR9003.patch
0044-ath9k_htc-Set-proper-firmware-offset-for-Netgear-WND.patch

These get automatically generated from linux-next.git

Only one patch from linux-next.git required a manual backport was:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ ls -1
pending-stable/backports/
0001-ath9k-lock-reset-and-PCU-start-stopping.patch

Then there is a slew of other stable fixes pending integration into
linux-next.git as well:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ ls -1
linux-next-pending/
0001-cfg80211-pass-the-reg-hint-initiator-to-helpers.patch
0002-cfg80211-fix-allowing-country-IEs-for-WIPHY_FLAG_STR.patch
0003-cfg80211-fix-disabling-channels-based-on-hints.patch
0008-ath9k-simplify-hw-reset-locking.patch
0009-ath9k-move-the-PCU-lock-to-the-sc-structure.patch
0010-ath9k-content-DMA-start-stop-through-the-PCU-lock.patch
0011-btusb-Add-fw-load-support.patch
0012-ath9k_hw-fix-potential-spurious-tx-error-bit-interpr.patch
0013-ath9k_hw-Fix-AR9280-surprise-removal-during.patch

And I cherry picked and manually backported Felix's TX queue selection
patch which we will support for this release:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ ls -1
linux-next-cherry-picks/
0001-ath9k-rework-tx-queue-selection-and-fix-queue-stoppi.patch

Apart from this we also then have the compat.git updates (30) and the
compat-wireless.git updates (124 patches) for this release.

mcgrof@tux ~/compat (git::linux-2.6.35.y)$ git shortlog
linux-2.6.35.y..linux-2.6.36.y
Blaise Gassend (1):
      compat: Fixes missing sem member in struct device for RT PREEMPT
prior to 2.6.34

Hauke Mehrtens (19):
      compat: update bitops.h and wireless.h
      compat: move kparam_{block,unblock}_sysfs_write
      compat: backport small functions and defines
      compat: use kernel pm_qos_params.h
      compat: backport dma_set_coherent_mask
      compat: backport sdio_writeb_readb
      compat: backport lockdep_assert_held
      compat: backport skb_queue_splice_init
      compat: fix tracpoint building
      compat: fix build if CONFIG_PCCARD=y and CONFIG_PCMCIA=n
      compat: backport n_tty_ioctl_helper
      compat: move va_format to compat-2.6.36.h
      compat: fix compiler warning
      compat: update compat_firmware_class.c
      compat: backport SDIO_CLASS_BT_AMP
      compat: backport linux/pci-aspm.h
      compat: lock correct mutex in device_lock
      compat: fix device_lock functions on non rt kernel
      compat: lock correct mutex in device_lock

Kshitij Kulshreshtha (4):
      compat: backport hex_to_bin first introduced in v2.6.35
      compat: header <pcmcia/cs_types.h> was removed in v2.6.36
      compat: define struct va_format introduced in v2.6.36
      compat: backport pcmcia_{read,write}_config byte from v2.6.36

Luis R. Rodriguez (5):
      compat: move struct va_format to 2.6.35 header
      compat: add br_port_exists() and ask for inclusion upstream
      compat: define PM_EVENT_SLEEP only if not defined
      Revert "compat: lock correct mutex in device_lock"
      compat: backport upstream firmware_class bug through f45f3c1f

Rajkumar Manoharan (1):
      compat: Fix panic caused by NULL pointer derefence in rtnl_fill_ifinfo

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ git
shortlog linux-2.6.35.y..linux-2.6.36.y
Bala Shanmugam (1):
      compat-wireless: Added ath3k sflash workaround to crap directory

Hauke Mehrtens (23):
      compat-wireless: deactivate libertas sdio suspend for < 2.6.34
      compat-wireless: deactivate atl1c for kernel < 2.6.27
      compat-wireless: activate CONFIG_MAC80211_RC_MINSTREL_HT
      compat-wireless: refresh patches
      compat-wireless: backport netdev->br_port
      compat-wireless: refresh patches
      compat-wireless: activate iwmc3200wifi and WL1271_SDIO
      compat-wireless: refresh patch
      compat-wireless: fix build problems
      compat-wireless: fix build of ath5k for CONFIG_PM_SLEEP=n
      compat-wireless: backport threaded-irq for rt2x00
      compat-wireless: refresh patch
      compat-wireless: refresh patch
      compat-wireless: backport pcmcia api changes
      compat-wireless: activate more bluetooth drivers
      compat-wireless: fix hidp_output_raw_report
      compat-wireless: do not use needed_headroom
      compat-wireless: fix patch stile.
      compat-wireless: remove linux/gpio.h include
      compat-wireless: multiple changes to config file
      compat-wireless: rename CONFIG_IWLWIFI config symbol
      compat-wireless: add ifdefs into compat_autoconf.h
      compat-wireless: add support for kernel 2.6.24

Kshitij Kulshreshtha (3):
      compat-wireless: allow compilation of compat-2.6.35.c from compat
      compat-wireless: copy headers in include/pcmcia from compat
      compat-wireless: more PCMCIA backporting

Luis R. Rodriguez (90):
      compat-wireless: accept extra arguments for scripts/gen-stable-release.sh
      compat-wireless: add -n -p -c support for gen-stable-release.sh
      compat-wireless: optimize branch selection on gen-stable-release.sh
      compat-wireless: update the usage() print for gen-stable-release.sh
      compat-wireless: fix target kernel expecations on gen-stable-release.sh
      compat-wireless: remove all the pending patches
      compat-wireless: run ./scripts/admin-update.sh refresh for 2010-06-03
      compat-wireless: ./scripts/admin-update.sh -c refresh
      compat-wireless: add defconfigs directory
      compat-wireless: fix config.mk
      compat-wireless: refresh for 2010-06-04
      compat-wireless: refresh of crap for 2010-06-04
      compat-wireless: add Ethernet support for driver-select
      compat-wireless: refresh of patches for June 10 2010
      compat-wireless: refresh of crap patches
      compat-wireless: add script to grep out colors
      compat-wireless: remove AR9003 PCI ID patch from crap/
      compat-wireless: add new AR9003 series for pending patches
      compt-wireless: fix crap/0002-ath9k-Add-pktlog-support.patch
      compat-wireless: remove all pending patches
      compat-wireless: add one pending patch for ath9k_hw for adhoc for AR9003
      compat-wireless: refresh crap patches
      compat-wireless: change admin-update to clarify lines of code
      compat-wireless: fix code-metrics for 1 patch
      compat-wireless: increase the code-metric percent resolution two fold
      compat-wireless: remove pending AR9003 IBSS fix
      compat-wireless: refresh patches for next-20100617
      compat-wireles: fix compilation when you have disabled
CONFIG_CFG80211_WEXT
      compat-wireless: refresh patches
      compat-wireless: update 07-change-default-rate-alg.patch
      compat-wireless: update 28-pm-qos-params.patch
      compat-wireless: scripts/admin-update.sh refresh
      compat-wireless: refresh crap patches
      compat-wireless: scripts/admin-update.sh refresh
      compat-wireless: refresh crap patches
      compat-wireless: patch refresh
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: backport sk_add_backlog() calls through a patch
      compta-wireless: update unload script
      compat-wireless: backport and fix new PCMCIA changes
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: use new br_port_exists() from compat.git
      compat-wireless: refresh patches for the linux-2.6.36.y branch
      compat-wireless: refresh crap patches for linux-2.6.36.y branch
      compat-wireless: make gen-stable-release.sh use new release
number for dirs
      compat-wireless: remove the v from the release name
      compat-wireless: fix applying of pm-qos patches
      compat-wireless: refresh patches
      compat-wireless: enable compilation of ath9k on >= 2.6.24
      compat-wireless: fix driver select for ath9k
      compat-wireless: fix unintended merge of changes
      compat-wireless: fix enabling of 2.6.24
      compat-wireless: refresh patches
      compat-wireless: update the atheros defconfigs/atheros-debug.mk
      compat-wireless: add support for generating pending-stable/ fixes
      compat-wireless: refresh patches for 2.6.36-rc5
      compat-wireless: get pending stable patches
      compat-wireless: refresh the pending-stable patches
      compat-wireless: add support for -s for gen-stable-release.sh
      compat-wireless: fix -s usage on generation stable tarballs
      compat-wireless: add support for printing stats for pending-stable
      compat-wireless: update code-metrics to reflect extra patches applied
      compat-wireless: fix to include net/mac80211.h for pending-stable
      compat-wireless: fix uninstall for compat
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: refresh cherry picked pending-stable patches
      compat-wireless: refresh stable patches to apply cleanly
      compat-wireless: make 01-netdev.patch apply for 2.6.36
      compat-wireless: Fix wl12xx.h copy
      Revert "compat-wireless: Fix wl12xx.h copy"
      Revert "compat-wireless: make 01-netdev.patch apply for 2.6.36"
      compat-wireless: suck in posted stable fixes for cfg80211
      compat-wireless: suck in ath9k PCU / DMA fixes
      compat-wireless: move ath3k fwload pending from crap/ patch to
linux-next-pending
      compat-wireless: add a few of Felix's pending stable patches
      compat-wireless: update pending stable patches from linux-next.git
      compat-wireless: update pending-stable patches
      compat-wireless: support ignoring some stable linux-next patches
      compat-wireless: backport ath9k-lock-reset-and-PCU-start-stopping.patch
      compat-wireless: ./scripts/admin-update.sh -s -p refresh
      compat-wireless: allow skipping updating the local tree
      Revert "compat-wireless: fix update-initramfs script"
      compat-wireless: fix initramfs update
      compat-wireless: cherry pick
0001-ath9k-rework-tx-queue-selection-and-fix-queue-stoppi.patch
      compat-wireless: fix placement of cherry picked extra patch
      compat-wireless: mark new release
      compat-wireless: add pending stable fix only posted so far for AR9280

Paul Fertser (1):
      compat-wireless: fix compilation for 2.6.32

Pavel Roskin (2):
      compat-wireless: "crap" code is "not yet posted", not "not yet merged"
      compat-wireless: update 07-change-default-rate-alg.patch

Richard Farina (1):
      compat-wireless: Enable rt2800usb in compat-wireless stable branch

Senthil Balasubramanian (1):
      compat-wireless: fix scripts/driver-select for ath9k

Walter Goldens (2):
      compat-wireless: disable update-initramfs except for b4xx/ssb
      compat-wireless: fix update-initramfs script

Many thanks to all the contributors!

compat-wireless code metrics

    494846 - Total upstream lines of code being pulled
      1708 - backport code changes
      1470 - backport code additions
       238 - backport code deletions
      6282 - backport from compat module
      7990 - total backport code
    1.6146 - % of code consists of backport work
       852 - Code changes brought in from pending-stable
       501 - Code additions brought in from pending-stable
       351 - Code deletions brought in from pending-stable
    0.1722 - % of code being cherry picked from pending-stable
       567 - Code changes posted but not yet merged
       441 - Code additions posted but not yet merged
       126 - Code deletions posted but not yet merged
    0.1146 - % of code not yet merged
       326 - Code changes brought in from linux-next
       119 - Code additions brought in from linux-next
       207 - Code deletions brought in from linux-next
    0.0659 - % of code being cherry picked from linux-next

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.36
compat-wireless release: compat-wireless-v2.6.36-5-spn

This release goes tests compiled and load tested against ath9k with a
Half Mini-PCI AR9280 on 2.6.31. Please report any issues.

 Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-4.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-5-spn.tar.bz2
[4] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/ChangeLog-2.6.36-wireless
