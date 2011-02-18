Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1BRRaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:30:21 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:37257 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945Ab1BRRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:30:19 -0500
Date: Fri, 18 Feb 2011 18:30:13 +0100
From: Alexander Wuerstlein <arw@arw.name>
To: hayeswang <hayeswang@realtek.com>
Cc: "'David S. Miller'" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "'franois romieu'" <romieu@fr.zoreil.com>
Subject: Re: r8169 hangs machine on kernel boot (bisected)
Message-ID: <20110218173013.GC15516@cip.informatik.uni-erlangen.de>
References: <20110216223438.GZ15516@cip.informatik.uni-erlangen.de>
 <CDC3F2AD9A574AC4B7DDDB7D64329A79@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CDC3F2AD9A574AC4B7DDDB7D64329A79@realtek.com.tw>
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4 cocaine
 saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
Organization: Department of Computer Science IV
X-URL: http://wwwcip.informatik.uni-erlangen.de/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11-02-18 15:01, hayeswang <hayeswang@realtek.com> wrote:
> Hello,
> > I've just tried to boot a new computer featuring a Realtek r8168 onboard (lspci
> > calls it Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit
> > Ethernet controller [10ec:8168] (rev 04), see [1]) network chip with kernel
> > 2.6.38-rc5 and current git. Both hang on boot just after USB device
> > initialization and just before the kernel usually does DHCP. The previous 2.6.37
> > didn't hang on boot, but showed strange behaviour (only 10MBit half duplex on
> > autonegotiation, tons of errors on the switch interface[2]) which is why I tried
> > the newer kernel in hopes that there would be fixes.
> > 
> > I bisected the hang-before-dhcp bug down to commit 'r8169: magic.'
> > (b646d90053f887c1bc243191e693a9b02d09f2c2, also see [1]). Since the commit
> > really does its description justice and looks like some weird hardware magic,
> > I'd like to ask the wizards on how to proceed with fixing it.
> 
> I have try the 8168DP and it wouldn't hang. I think I need more information.
> Could you give the information about the motherboard and the version of BIOS.
> Besides, please use the realtek driver, and dump the MAC information by using
> "ethtool -d eth0". These are helpful to find out what happens. Thanks.

I'm sorry that it took me so long to answer, I've had some problems
booting the machine today since the PXE-Client didn't get any DHCP
requests through. I'm not sure if its related, the problem cleared up
after I opened up the machine to get the motherboard data and stuff.

Long story short, new files 'bios', 'hardware' and 'ethtool-d' in
http://wwwcip.cs.fau.de/~snalwuer/kernel-r8169
Bios revision is the latest available from Fujitsu for that hardware.
Hardware numbers and serials are accurate, but the inscriptions on the
chips I suspected to be PHYs were very hard to read, so expect errors.
The 'ethtool-d' is especially curious, since it consists of only
'FF'-bytes. The ethtool register dump was taken on a 2.6.37 with r8168
as a module.

fujitsu.com also has some (limited, end-user-focused) hardware
documentation if you enter the serial number 'YL7E003277' on
http://ts.fujitsu.com/support/downloads.html

If you need any further information, don't hesitate to ask.



Ciao,

Alexander Wuerstlein.
