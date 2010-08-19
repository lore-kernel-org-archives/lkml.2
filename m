Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0HSN4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:56:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0HSN4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:56:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
Date: Thu, 19 Aug 2010 15:55:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201008190001.11342.rjw@sisk.pl> <AANLkTi=S3JE=1J9xQtBAN5hHTqGSfohi4vL82iZHMWp+@mail.gmail.com>
In-Reply-To: <AANLkTi=S3JE=1J9xQtBAN5hHTqGSfohi4vL82iZHMWp+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191555.08392.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 19, 2010, Luis R. Rodriguez wrote:
> On Wed, Aug 18, 2010 at 3:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > While testing 2.6.36-rc1 (with a couple of fixes on top)
> 
> Which couple of fixes?

AMD bood fix, HID suspend fix and shmem fix (two of them have already been
merged).

> > I noticed that the ath9k
> > driver didn't work after resume from suspend to RAM.
> 
> To rule out if its an ath9k issue you can try
> compat-wireless-2.6.36-rc1 from here:
> 
> http://wireless.kernel.org/en/users/Download/stable/
> 
> and install it on an older kernel, you can use ./scripts/driver-select
> to only enable ath9k to compile.

Well, that sounds a bit complicated and even if I know it's not ath9k,
that's not going to help me find the real source of the problem.

> I've been using pm-suspend on this release for a few days now without
> any issue but I am using an AR9003 chipset. What chipset are you
> using? Can you provide the dmesg output upon module load?

Sure.

[    9.680128] ath9k 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    9.689487] ath9k 0000:09:00.0: setting latency timer to 64
[    9.706383] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.805043] hda_codec: ALC272X: BIOS auto-probing.
[    9.819389] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input8
[   10.155052] ath: EEPROM regdomain: 0x65
[   10.155058] ath: EEPROM indicates we should expect a direct regpair map
[   10.155066] ath: Country alpha2 being used: 00
[   10.155070] ath: Regpair used: 0x65
[   10.179762] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   10.181657] Registered led device: ath9k-phy0::radio
[   10.181890] Registered led device: ath9k-phy0::assoc
[   10.182139] Registered led device: ath9k-phy0::tx
[   10.182339] Registered led device: ath9k-phy0::rx

lspci says it's:

09:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)

Thanks,
Rafael
