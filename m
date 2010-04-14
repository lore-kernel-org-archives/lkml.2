Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0DNXi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:38:57 -0400
Received: from sous-sol.org ([216.99.217.87]:42117 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597Ab0DNXiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:38:55 -0400
Date: Wed, 14 Apr 2010 16:37:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, David Woodhouse <dwmw2@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Daniel Mack <daniel@caiaq.de>,
       USB list <linux-usb@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       iommu@lists.linux-foundation.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100414233713.GC25962@sequoia.sous-sol.org>
References: <Pine.LNX.4.44L0.1004141300180.1716-100000@iolanthe.rowland.org>
 <1271270197.31006.2133.camel@macbook.infradead.org>
 <u2l74fd948d1004141412we3597f40q9ad5a29253c69164@mail.gmail.com>
 <20100414222550.GB25962@sequoia.sous-sol.org>
 <p2z74fd948d1004141556r9d2cc7a9sfe40a3d68661669@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <p2z74fd948d1004141556r9d2cc7a9sfe40a3d68661669@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pedro Ribeiro (pedrib@gmail.com) wrote:
> On 14 April 2010 23:25, Chris Wright <chrisw@sous-sol.org> wrote:
> > * Pedro Ribeiro (pedrib@gmail.com) wrote:
> >> Turns out CONFIG_DMAR was disabled because of PREEMPT_RT. I disabled
> >> the later and enabled _DMAR. It took a long time to boot, something
> >> wrong with the usb ports. You can see it in the appended dmesg from
> >> time 11s to 100s.
> >>
> >> Then after it booted, I could barely move my USB mouse and lots of
> >> errors appeared on dmesg. I tried to connect the DVB card but it
> >> wouldn't even initialize.
> >
> > [  316.360045] DMAR:[DMA Write] Request device [00:02.0] fault addr 23c00000
> > [  316.360046] DMAR:[fault reason 05] PTE Write access is not set
> >
> > That's your video device.  Do you have CONFIG_DMAR_BROKEN_GFX_WA=y?
> 
> Where do I find this option in make menuconfig? Doesn't seem to be available...

It's hidden behind CONFIG_BROKEN.  The iommu=pt test puts all devices in
a 1:1 mapping (the broken graphics workaround does that just for all
graphics devices).

> >> Enabling it with iommu=pt seemed to make no difference.
> >
> > It should (it should at least eliminate the video device problem).
> 
> You are right, it does eliminate that problem. However I can't get any
> of the USB devices to work, and the mouse is terribly slow. One more
> dmesg attached.

Thanks.  It works for me here.  I just booted 2.6.33-rt4 on my T400 w/
iommu on, and an external USB mouse is working fine (I don't have the
same number of devices plugged in as you do).  You are not seeing DMA
faults which suggest that the IOMMU mappings are correct w.r.t. the DMA
transactions that the controller is initiating.

thanks,
-chris
