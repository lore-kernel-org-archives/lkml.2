Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2BETpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 14:45:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41149 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2BETpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 14:45:31 -0500
MIME-Version: 1.0
Date: Sun, 5 Feb 2012 20:45:30 +0100
Message-ID: <CANtv1eXSbOSp90BEfuWdL+6_7CFPJ5Hpn=Va3Jopbr7s011JLg@mail.gmail.com>
Subject: regression, 3.2.2 stable: ath9k won't associate anymore
From: Jurica Vukadin <u.ra604@googlemail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit "b4a82a0 ath9k_hw: fix interpretation of the rx KeyMiss flag"
caused my card to stop associating with the router.
Reverting it fixes the issue. Encryption is WEP, if that matters; I
haven't tried others.

The device is "10:00.0 Network controller: Atheros Communications Inc.
AR9287 Wireless Network Adapter (PCI-Express) (rev 01)"

excerpt from dmesg before the revert:
Feb  5 20:00:56 smaug kernel: [    7.468770] ath9k 0000:10:00.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Feb  5 20:00:56 smaug kernel: [    7.468787] ath9k 0000:10:00.0:
setting latency timer to 64
Feb  5 20:00:56 smaug kernel: [    7.558116] ath: EEPROM regdomain: 0x6a
Feb  5 20:00:56 smaug kernel: [    7.558118] ath: EEPROM indicates we
should expect a direct regpair map
Feb  5 20:00:56 smaug kernel: [    7.558121] ath: Country alpha2 being used: 00
Feb  5 20:00:56 smaug kernel: [    7.558122] ath: Regpair used: 0x6a
Feb  5 20:00:56 smaug kernel: [    8.044750] ieee80211 phy0: Selected
rate control algorithm 'ath9k_rate_control'
Feb  5 20:00:56 smaug kernel: [    8.045371] Registered led device: ath9k-phy0
Feb  5 20:01:01 smaug kernel: [   16.161078] wlan0: authenticate with
00:01:e3:4a:9e:be (try 1)
Feb  5 20:01:01 smaug kernel: [   16.163159] wlan0: authenticated
Feb  5 20:01:01 smaug kernel: [   16.197844] wlan0: associate with
00:01:e3:4a:9e:be (try 1)
Feb  5 20:01:01 smaug kernel: [   16.200307] wlan0: RX AssocResp from
00:01:e3:4a:9e:be (capab=0x431 status=0 aid=4)
Feb  5 20:01:01 smaug kernel: [   16.200312] wlan0: associated
Feb  5 20:01:31 smaug kernel: [   46.185930] wlan0: deauthenticating
from 00:01:e3:4a:9e:be by local choice (reason=3)


--
Kind regards,
Jurica
