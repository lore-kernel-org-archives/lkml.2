Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0LGLYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:24:17 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64064 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0LGLYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=gfcGIsLQBm8x4AB9Q3TOPBZ661D/wiiqGx6xGTmQ2JUkWozqbwzRXS2zNx+o1i80qB
         sIe3J7ZYG8wLRg//bDmQHC7jtHjvCQgKWyynSpWp4znb6JuliJdxwfJPIingzanftT0F
         TKN1SJl5X/ccSHSrSHGv02DCoajLrAvskv68U=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 7 Dec 2010 12:24:14 +0100
Message-ID: <AANLkTik1P7vQbgL8qxoTEEyR0D0cTV+9zsBcHT3L_nwm@mail.gmail.com>
Subject: [linux-next] next-20101207: Better now, but modinfo ath5k
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nick Kossifidis <mickflemm@gmail.com>, Bruno Randolf <br1@einfach.org>,
        ath5k-devel <ath5k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just compiled linux-next (next-20101207) which also includes
wireless-next-2.6 (master-2010-12-06) [1].

I have already reported on linux-wireless (short: l-w) ML that after
especially the merge of "AHB Bus support" patchset (see [2]) my ath5k
was not working as expected in daily use (also modinfo).

I am not sure if it is the driver but reverting the 9 commits in my
local linux-next GIT seemed to "stabilize" a bit the Internet
connection.
The patchset from Nick (see below) definitely helped to stabilize ath5k.

What means "daily use"?
Quassel IRC-client (around 20 channels), Iceweasel (Debian's answer to
firefox) with sometimes 20 tabs open and radio live-stream in VLC.

Here and there I have still audio-dropouts or when typing emails in
web-based email-service, it stalls when "stressing" with for example
parallelly creating a tarball (that's normally no huge workload) the
probability for audio-dropouts increases.

As I said I am not sure what is causing these hangs, it's ath5k
driver? Is it sth. else?
How to dig into it?

Unfortunately, modinfo does not list aliases with pci-id matching (I
have already reported to l-w ML, see below).
With reverting "AHB Bus support" patchset modinfo works as expected.

As a workaround I added ath5k to /etc/modules (see below), otherwise I
have to stop networking, unload + reload ath5k and start networking
again.

I also added an iw station dump (see below) and outputs of filtered
lspci and dmesg commands.

Not sure if this is helpful to mention, I use crda and wireless-regdb
(see below).

BTW, I have these two patches in addition to linux-next:
  (+) OK   mac80211-fix/mac80211-fix-a-compiler-warning.patch
  (+) OK   ath5k-fix/ath5k-Use-capabilities-information-for-the-number-of-TX-queues.patch

Any ideas/help appreciated, Thanks in advance.

Kind Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git
[2] http://wireless.kernel.org/en/users/Drivers/ath5k

P.S.: Patchset from Nick Kossifidis

$ ls -l ath5k-fix/*-6-*
-rw-r--r-- 1 sd sd 3439  3. Dez 06:52
ath5k-fix/1-6-ath5k-Always-write-tx-powertable-on-hw.patch
-rw-r--r-- 1 sd sd 1725  3. Dez 06:51
ath5k-fix/2-6-ath5k-Always-free-tx-buffers-before-reset.patch
-rw-r--r-- 1 sd sd 2132  3. Dez 06:52
ath5k-fix/3-6-ath5k-Disable-ANI-during-reset.patch
-rw-r--r-- 1 sd sd 1360  3. Dez 06:52
ath5k-fix/4-6-ath5k-Fix-reporting-of-RX-dma-stop-failure.patch
-rw-r--r-- 1 sd sd 1735  3. Dez 06:52
ath5k-fix/5-6-ath5k-Update-version-string.patch
-rw-r--r-- 1 sd sd 1744  3. Dez 06:53
ath5k-fix/6-6-ath5k-Include-tx-ack-reporting-on-hw-flags.patch

# modinfo ath5k
filename:
/lib/modules/2.6.37-rc4-686/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
version:        0.6.0 (EXPERIMENTAL)
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN cards.
author:         Nick Kossifidis
author:         Jiri Slaby
srcversion:     49DBF0BE975A1F9917151F4
depends:        mac80211,cfg80211,ath
vermagic:       2.6.37-rc4-686 SMP mod_unload modversions 686
parm:           debug:uint
parm:           nohwcrypt:Disable hardware encryption. (bool)
parm:           all_channels:Expose all channels the device can use. (bool)

# grep ath5k /etc/modules
ath5k

# iw wlan0 station dump
Station 00:04:0e:e4:00:3d (on wlan0)
        inactive time:  48 ms
        rx bytes:       60460696
        rx packets:     95331
        tx bytes:       5034456
        tx packets:     50165
        signal:         -50 dBm
        tx bitrate:     36.0 MBit/s

# lspci -nnvv | grep -i ath
02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
802.11abg NIC [168c:1014] (rev 01)
        Kernel driver in use: ath5k

# dmesg | egrep -i 'ath|80211|wlan'
[   14.444118] cfg80211: Calling CRDA to update world regulatory domain
[   14.725757] ath5k 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11
(level, low) -> IRQ 11
[   14.736940] ath5k 0000:02:02.0: registered as 'phy0'
[   15.036636] ath: EEPROM regdomain: 0x61
[   15.036640] ath: EEPROM indicates we should expect a direct regpair map
[   15.036646] ath: Country alpha2 being used: 00
[   15.036648] ath: Regpair used: 0x61
[   15.665415] cfg80211: World regulatory domain updated:
[   15.676274] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   15.687303] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   15.698413] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   15.709461] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   15.720489] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   15.731526] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   15.754490] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   15.755482] Registered led device: ath5k-phy0::rx
[   15.755516] Registered led device: ath5k-phy0::tx
[   15.755529] ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
[   15.766686] ath5k phy0: RF5111 5GHz radio found (0x17)
[   15.777870] ath5k phy0: RF2111 2GHz radio found (0x23)
[   17.374647] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   22.596104] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
[   22.597531] wlan0: authenticated
[   22.597549] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
[   22.602095] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
status=0 aid=1)
[   22.602100] wlan0: associated
[   22.602986] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   33.312034] wlan0: no IPv6 routers present
[  215.317105] cfg80211: Calling CRDA to update world regulatory domain
[  215.346333] cfg80211: World regulatory domain updated:
[  215.346341] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  215.346346] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  215.346350] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  215.346354] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  215.346358] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  215.346362] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  219.627199] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
[  219.629321] wlan0: authenticated
[  219.629365] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
[  219.635825] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
status=0 aid=1)
[  219.635836] wlan0: associated

# dpkg -l | egrep 'crda|wireless-regdb' | cut -c-80
ii  crda                                            1.1.1-0~svnr1515.3
ii  wireless-regdb                                  2010.11.24-1
