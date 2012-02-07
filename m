Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2BGLYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:24:01 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:52003 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab2BGLYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:24:00 -0500
Date: Tue, 7 Feb 2012 12:23:45 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
Message-ID: <20120207112345.GA14427@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207105835.GA12864@citd.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 11:58, Matthias Schniedermeyer wrote:
> On 07.02.2012 11:19, Clemens Ladisch wrote:
> > Matthias Schniedermeyer wrote:
> > > On 06.02.2012 10:16, Greg KH wrote:
> > >> I'm announcing the release of the 3.2.5 kernel.
> > >>
> > >> It contains one PCI patch, it is up to you to decide to upgrade or not.
> > >
> > > This one makes my Soundblaster Live (alsa/emu10k1) silent.
> > > It is detected, i can e.g. change the mixer, but i can't hear any sound.
> > 
> > Back in the PCI days, the Emu10k1 chip was known to be quite inefficient
> > (many small transfers, and IIRC even latency timer bugs) and to be
> > problematic when used with other high-bandwidth PCI chips like TV capture
> > cards.
> > 
> > > There is a difference in syslog output regarding aspm, the emu10k1 line
> > > is the same.
> > 
> > Your PCIe/PCI bridge (5:0.0, iTE IT8892) which handles the PCI bus is
> > affected by the change.
> > 
> > I do not know if this is an actual hardware bug, or if the bridge is
> > just too slow to wake up the PCIe link.
> > 
> > Please show the output of "lspci -v -s 5:0".
> 
> With 3.2.4 running:
> lspci -v -s 5:0
> 05:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 
> 10) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=05, secondary=06, subordinate=06, sec-latency=32
>         I/O behind bridge: 0000c000-0000cfff
>         Memory behind bridge: fbe00000-fbefffff
>         Capabilities: <access denied>

Ups. I did that with my user-account. Now with root:
lspci -v -s 5:0
05:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 10) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=05, secondary=06, subordinate=06, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fbe00000-fbefffff
        Capabilities: [70] Express PCI/PCI-X Bridge, MSI 00
        Capabilities: [90] Power Management version 2
        Capabilities: [a0] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
        Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

