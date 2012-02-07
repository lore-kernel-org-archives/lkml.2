Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2BGK6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:58:53 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:43327 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab2BGK6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:58:52 -0500
Date: Tue, 7 Feb 2012 11:58:35 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
Message-ID: <20120207105835.GA12864@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F30FABF.4060409@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 11:19, Clemens Ladisch wrote:
> Matthias Schniedermeyer wrote:
> > On 06.02.2012 10:16, Greg KH wrote:
> >> I'm announcing the release of the 3.2.5 kernel.
> >>
> >> It contains one PCI patch, it is up to you to decide to upgrade or not.
> >
> > This one makes my Soundblaster Live (alsa/emu10k1) silent.
> > It is detected, i can e.g. change the mixer, but i can't hear any sound.
> 
> Back in the PCI days, the Emu10k1 chip was known to be quite inefficient
> (many small transfers, and IIRC even latency timer bugs) and to be
> problematic when used with other high-bandwidth PCI chips like TV capture
> cards.
> 
> > There is a difference in syslog output regarding aspm, the emu10k1 line
> > is the same.
> 
> Your PCIe/PCI bridge (5:0.0, iTE IT8892) which handles the PCI bus is
> affected by the change.
> 
> I do not know if this is an actual hardware bug, or if the bridge is
> just too slow to wake up the PCIe link.
> 
> Please show the output of "lspci -v -s 5:0".

With 3.2.4 running:
lspci -v -s 5:0
05:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 
10) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=05, secondary=06, subordinate=06, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fbe00000-fbefffff
        Capabilities: <access denied>


> > pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> 
> Does this mean that the new kernel _dis_ables ASPM, where it left it
> enabled previously?
> 
> Please try that kernel parameter.

I don't want/need ASPM, disabled is fine with me.

As Far as i understand the change in 3.2.5 it is this:
The ASPM change is meant to make Linux behave more like Windows.
Pre 3.2.5 "ASPM disabled" meant: Linux will explicitly disable ASPM, 
even when the ACPI says it is already disabled.
With 3.2.5 "ASPM disabled" means: When the ACPI says ASPM is 
disabled Linux will leave it alone, which is what Windows is doing.
The assumption is that explicitly disabling ASPM is more problematic 
than doing nothing.

As far as i am concerned i don't want/need ASPM, this system isn't a 
Laptop and a watt or more power used is preferrable to the potential 
problem with a device that doesn't play nice with ASPM enabled. In this 
case the problem appears to be the change how disabled is handled.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

