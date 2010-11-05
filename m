Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0KEUvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:51:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab0KEUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:51:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [Regression, post-2.6.35] ath9k occasionally drops out of PCI config space
Date: Fri, 5 Nov 2010 21:50:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011052150.02245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For some time I've been experiencing a regression associated with ath9k
that occasionally it drops the connection with the AP and goes into a state
in which reading from its PCI config registers (as done by lspci) return all
ones.

It may be sort of brought back to life by a suspend/resume afterwards, but
then the driver cannot really handle it and realoding the driver doesn't help
(probe fails).  Basically, full machine reboot is needed to revive the adapter.

The device is:

09:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
        Subsystem: Foxconn International, Inc. Device e01f

and the kernel says:

[    9.623217] ath9k 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    9.631518] ath9k 0000:09:00.0: setting latency timer to 64
[   10.071497] ath: EEPROM regdomain: 0x65
[   10.071502] ath: EEPROM indicates we should expect a direct regpair map
[   10.071510] ath: Country alpha2 being used: 00
[   10.071514] ath: Regpair used: 0x65
[   10.096025] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   10.097803] Registered led device: ath9k-phy0::radio
[   10.098035] Registered led device: ath9k-phy0::assoc
[   10.098249] Registered led device: ath9k-phy0::tx
[   10.098483] Registered led device: ath9k-phy0::rx
[   10.098496] phy0: Atheros AR9280 Rev:2 mem=0xffffc900017e0000, irq=19

The issue is not really bisectable, because I'm unable to trigger it on demand
and it occurs approx. 1-2 times a day.  So, if you have any ideas what to test,
please let me know.

It is not reproducible with the 2.6.35 kernel.

Thanks,
Rafael
