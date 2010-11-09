Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0KIT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:27:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0KIT1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:27:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [Regression, post-2.6.35] ath9k occasionally drops out of PCI config space
Date: Tue, 9 Nov 2010 20:26:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <201011052150.02245.rjw@sisk.pl> <201011082147.14170.rjw@sisk.pl> <AANLkTikhQrk3aMJLLeeTmy9KJHd-H3xxFPNdUT9uJoD8@mail.gmail.com>
In-Reply-To: <AANLkTikhQrk3aMJLLeeTmy9KJHd-H3xxFPNdUT9uJoD8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011092026.48434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 08, 2010, Luis R. Rodriguez wrote:
> On Mon, Nov 8, 2010 at 12:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, November 05, 2010, Luis R. Rodriguez wrote:
> >> On Fri, Nov 05, 2010 at 01:50:02PM -0700, Rafael J. Wysocki wrote:
> >> > Hi,
> >> >
> >> > For some time I've been experiencing a regression associated with ath9k
> >> > that occasionally it drops the connection with the AP and goes into a state
> >> > in which reading from its PCI config registers (as done by lspci) return all
> >> > ones.
> >> >
> >> > It may be sort of brought back to life by a suspend/resume afterwards, but
> >> > then the driver cannot really handle it and realoding the driver doesn't help
> >> > (probe fails).  Basically, full machine reboot is needed to revive the adapter.
> >> >
> >> > The device is:
> >> >
> >> > 09:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
> >> >         Subsystem: Foxconn International, Inc. Device e01f
> >> >
> >> > and the kernel says:
> >> >
> >> > [    9.623217] ath9k 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> >> > [    9.631518] ath9k 0000:09:00.0: setting latency timer to 64
> >> > [   10.071497] ath: EEPROM regdomain: 0x65
> >> > [   10.071502] ath: EEPROM indicates we should expect a direct regpair map
> >> > [   10.071510] ath: Country alpha2 being used: 00
> >> > [   10.071514] ath: Regpair used: 0x65
> >> > [   10.096025] phy0: Selected rate control algorithm 'ath9k_rate_control'
> >> > [   10.097803] Registered led device: ath9k-phy0::radio
> >> > [   10.098035] Registered led device: ath9k-phy0::assoc
> >> > [   10.098249] Registered led device: ath9k-phy0::tx
> >> > [   10.098483] Registered led device: ath9k-phy0::rx
> >> > [   10.098496] phy0: Atheros AR9280 Rev:2 mem=0xffffc900017e0000, irq=19
> >> >
> >> > The issue is not really bisectable, because I'm unable to trigger it on demand
> >> > and it occurs approx. 1-2 times a day.  So, if you have any ideas what to test,
> >> > please let me know.
> >> >
> >> > It is not reproducible with the 2.6.35 kernel.
> >>
> >> Please try this patch.
> >
> > It _appears_ to help.  At least I haven't been able to reproduce the problem
> > since I applied it, which was on Saturday early in the morning.
> >
> > Still, I also haven't used wireless a lot since that time, because I've been
> > traveling mostly.
> 
> Thanks, please let us know when you are satisfied with this as a fix.

OK, I'm now quite confident that it really helps.

> Its going upstream so either way if you find you hit the issue just
> let us know.

Great, thanks, I will.

Rafael
