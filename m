Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1C3BQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:16:35 -0400
Received: from mail.atheros.com ([12.19.149.2]:49058 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1C3BQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:16:33 -0400
Date: Tue, 29 Mar 2011 18:16:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin Mehta <Vipin.Mehta@atheros.com>,
        Naveen Singh <Naveen.Singh@atheros.com>,
        "kvalo@adurom.com" <kvalo@adurom.com>, "j@w1.fi" <j@w1.fi>
Subject: Re: [RFC 0/4] sdhci: few patches for ENE 712 support
Message-ID: <20110330011629.GA15578@tux>
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
 <20110319091544.GA16635@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110319091544.GA16635@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 02:15:44AM -0700, Wolfram Sang wrote:
> 
> > I prefer code upstream though so here is my split and cleanup
> > of these patches. I've tested it with my ENE card. Since I am
> > new to SDHCI I would prefer someone with more experience review
> > these chagnes and the respective commit log messages. I've
> > tried to make sense of them as best as I can. Unfortunately
> > I was not given any explanation to these changes except the
> > patch I got so I tried to make the best of it.
> 
> You did make the best out of it; still, you probably won't be surprised to hear
> that all the patches are, well, not acceptable ;) I agree with Chris about 1/4,
> I think 2-4 are for a broken card detection and there is already a quirk for
> that. So you could also try dropping 2-4 and use
> 
> 	sdhci.debug_quirks = 0x8028
> 
> That should enable the standard quirks for this card and BROKEN_CARD.

I just tried this, it does not work, in fact my own my patches don't work too,
only the original crap does though for some odd magical reason.

Then again, what I tried was:

insmod ./sdhci.ko debug_quirks=0x8028

Was that what you wanted me to try?

> Can you also please post the PCI-ID of this card?

nsingh@nsingh-desktop ~/wireless-testing (git::master)$ lspci -k -n | grep -3 sdhci
        Kernel modules: sky2
03:0a.0 0501: 1524:0730
03:0a.1 0805: 1524:0750
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci
03:0a.2 0501: 1524:0720
nsingh@nsingh-desktop ~/wireless-testing (git::master)$ lspci -k | grep -3 sdhci
        Kernel modules: sky2
03:0a.0 FLASH memory: ENE Technology Inc ENE PCI Memory Stick Card Reader Controller
03:0a.1 SD Host controller: ENE Technology Inc ENE PCI SmartMedia / xD Card Reader Controller
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci
03:0a.2 FLASH memory: ENE Technology Inc Memory Stick Card Reader Controller

> And does it make a difference if you use the SDIO-WLAN card or a standard SD
> memory card?

Um, I don't have physical access to the box, Naveen or Vipin would have to
test this.

  Luis
