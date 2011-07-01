Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1GAJ2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:28:08 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:39335 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab1GAJ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:28:06 -0400
Date: Fri, 1 Jul 2011 13:27:03 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, matt mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] USB: EHCI: Allow users to override 80% max
	periodic bandwidth
Message-ID: <20110701092703.GA17010@tugrik.mns.mnsspb.ru>
References: <cover.1308933456.git.kirr@mns.spb.ru> <20110630180101.GB7979@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630180101.GB7979@xanatos>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 11:01:01AM -0700, Sarah Sharp wrote:
> On Fri, Jun 24, 2011 at 08:48:06PM +0400, Kirill Smelkov wrote:
> > 
> > Changes since v1:
> > 
> > 
> >  - dropped RFC status as "this seems like the sort of feature somebody might
> >    reasonably want to use -- if they know exactly what they're doing";
> > 
> >  - new preparatory patch (1/2) which moves already-in-there sysfs code into
> >    ehci-sysfs.c;
> > 
> >  - moved uframe_periodic_max parameter from module option to sysfs attribute,
> >    so that it can be set per controller and at runtime, added validity checks;
> > 
> >  - clarified a bit bandwith analysis for 96% max periodic setup as noticed by
> >    Alan Stern;
> > 
> >  - clarified patch description saying that set in stone 80% max periodic is
> >    specified by USB 2.0;
> 
> Have you tested this patch by maxing out this bandwidth on various
> types of host controllers?  It's entirely possible that you'll run into
> vendor-specific bugs if you try to pack the schedule with isochronous
> transfers.  I don't think any hardware designer would seriously test or
> validate their hardware with a schedule that is basically a violation of
> the USB bus spec (more than 80% for periodic transfers).

I've only tested it to work on my HP Mini 5103 with N10 chipset:

    kirr@mini:~$ lspci 
    00:00.0 Host bridge: Intel Corporation N10 Family DMI Bridge
    00:02.0 VGA compatible controller: Intel Corporation N10 Family Integrated Graphics Controller
    00:02.1 Display controller: Intel Corporation N10 Family Integrated Graphics Controller
    00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA AHCI Controller (rev 02)
    01:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
    02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8059 PCI-E Gigabit Ethernet Controller (rev 11)

The system works stable with 110us/uframe (~88%) isoc bandwith allocated for
integrated UVC webcam and external EM28XX based capture board.


> But if Alan is fine with giving users a way to shoot themselves in the
> foot, and it's disabled by default, then I don't particularly mind this
> patch.

Yes, it is disabled by default, I mean max periodic bandwidth is set to
100us/uframe by default exactly as it was before the patch. So only
those of us who need the extreme settings are taking the risk - normal
users who do not alter uframe_periodic_max attribute should not see any
change at all.


Thanks for commenting. I'll extend my testing information and notes on
do-not-do-harm bahaviour in updated patch.


Kirill
