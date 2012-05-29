Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2E2Heh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:34:37 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:59494 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab2E2Hef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:34:35 -0400
Date: Tue, 29 May 2012 09:34:17 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
Message-ID: <20120529073417.GA25041@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4FC477A1.4010709@zytor.com>
References: <4FC477A1.4010709@zytor.com>  <4FC47003.1080906@zytor.com>
  <4FC40C74.8050003@zytor.com>  <20120527205020.GA3050@mail.gnudd.com>
 <20120529063738.GA22711@mail.gnudd.com>
 <20120529070557.GA23373@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am not going to accept into the kernel a bunch of board-specific
> files.

Ok.

> PCI cards are different: they have PCI IDs, and they can be
> loaded, as modules, at runtime.  Furthermore, they tend to be very
> limited in the amount of variation:

Well, please check drivers/media/video/bt8xx: the "bttv-cards" file is
the biggest one. But I see your point.

> a single chip (represented PCI ID) may be slightly differently wired
> on different boards (represented by subsystem ID), but the variation
> tends to be limited; in the rare case it is not, there is usually
> some form of discovery mechanism.

Here the thing is 4 uart, 4 mmc, 3 spi, 128 gpio, 2 dma engines, usb,
sata, audio, ....  So some differences in wiring are there between
boards.  And no, no autodiscovery unfortunately (but we can use the
command line, so the driver knows who the installation is when it runs
its probe methods).

> Those are the *only* kinds conditions under which that kind of things,
> in drivers, is acceptable.  A list of mainboards and their wirings in C
> code?  No way in hell.

Ok. Although you can think of them as plug in boards.

>> I'm pretty sure we don't have ACPI, and I'd avoid device tree if
>> possible (especially thinking of add-on cards).  If you think it makes
>> more sense, I can offer the code to drivers/pci or other more generic
>> places.
> 
> What does "offer the code" mean here?  Just put the same sh*t in a
> different place?  No, no, no, no.

Yes, that was the suggestion :)
 
> We have the device tree mechanism as an escape valve for the systems
> built without any sane consideration for the platform, and that is the
> last resort.  I am generally not happy with that in the x86 space, even,
> because it means yet another failed platform, but it is still better
> than ad hoc hacks.

Unfortunately most vendors don't deal with autodetection, so the
number of "failed platforms" will increase, I fear. Especially
with increasing use of x86 in embedded contexts.

So, it seems I must go device-tree for the chipset-like mounting. And
what about plug in boards? I may arrange a firmware-loader mechanism
as an alternative, so the vendor of each board can provide the the
platform data for all the sub devices. Actually, if firmware loader is
acceptable, I'd try it first, to avoid changing the boot procedure;
maybe I can save myself from the device tree.

thanks
/alessandro
