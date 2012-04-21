Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2DUNZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 09:25:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:50674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2DUNZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 09:25:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133671419"
Date: Sat, 21 Apr 2012 06:25:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
Message-ID: <20120421132516.GC7069@xanatos>
References: <4F909CEB.3060407@fold.natur.cuni.cz>
 <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
 <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
 <4F91473A.1080007@fold.natur.cuni.cz>
 <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
 <4F919C22.1070608@fold.natur.cuni.cz>
 <4F919CD5.7070004@fold.natur.cuni.cz>
 <CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com>
 <20120420231748.GB7069@xanatos>
 <CAE9FiQX7JCZvL9S8ZOQQaHQ4nfU0XDj=8FmOfCtcz7WFjP8=Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQX7JCZvL9S8ZOQQaHQ4nfU0XDj=8FmOfCtcz7WFjP8=Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 05:09:48PM -0700, Yinghai Lu wrote:
> On Fri, Apr 20, 2012 at 4:17 PM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > On Fri, Apr 20, 2012 at 11:47:14AM -0700, Yinghai Lu wrote:
> >> On Fri, Apr 20, 2012 at 10:28 AM, Martin Mokrejs
> >> <mmokrejs@fold.natur.cuni.cz> wrote:
> >> > [30720.175637] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 108
> >> > [30720.175639] pciehp 0000:00:1c.7:pcie04: LinkState change
> >> > [30720.175643] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
> >> > [30720.175644] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> >> > [30720.175648] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> >> > [30720.175687] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> >> > [30720.175718] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> >> > [30720.175721] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> >> >
> >>
> >> So the USB host control driver xhci put that 11:00.0 in strange power state.
> >
> > What do you mean "strange power state"?  The only PCI power states the
> > xHCI driver will use is D0 or D3hot.  D3hot is entered automatically by
> > the USB core runtime PM system when all USB devices are disconnected or
> > suspended.  So what strange power state are we talking about?
> 
> that's helpful. Can that feature to be disabled?

Yes.  There are several ways to disable automatic entry into D3hot.
The easiest way is to turn off CONFIG_USB_SUSPEND, which will disable
USB autosuspend (and subsequent runtime PM entry into D3hot) for all USB
hosts and devices.

If you want a dynamic test, you can go into the USB host sysfs files in
/sys/bus/usb/devices/usbN/power/ (where N is the bus number) and echo
"on" to the control file.  Echo "auto" to turn runtime PM back on.  The
xHCI driver will register two USB buses, so it's better to turn all the
usbN hosts on for this test.

Alternately, you can also use powertop, go to the Tunables tab, and
change line like this:

>> Good          Autosuspend for USB device EHCI Host Controller [usb7]

>From "Good" to "Bad" for the xHCI host.

Sarah Sharp
