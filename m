Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2E2HGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:06:22 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:37166 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2E2HGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:06:21 -0400
Date: Tue, 29 May 2012 09:05:57 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
Message-ID: <20120529070557.GA23373@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4FC47003.1080906@zytor.com>
References: <4FC47003.1080906@zytor.com>  <4FC40C74.8050003@zytor.com>
  <20120527205020.GA3050@mail.gnudd.com>
 <20120529063738.GA22711@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have two mechanisms for parameterizing this kind of information: ACPI
> 5 (which can be considered the "native" method on x86) or flattened
> device tree (as already used by the CE4100 platform.)  Keep in mind that
> an explicit goal for Linux/x86 is that the same kernel should boot on
> all platforms, and backsliding on that is not acceptable.

Yes, it indeed does (the original code I received did not, but mine
doesn't break stuff for other systems). What I posted uses a kernel
command-line argument to tell what board it is: the sta2x11 is the
computer's chipset in most cases, so it should know the wiring soon.

> The best is for the firmware on your platforms to provide the ACPI or
> DTB information, as it should.  If it doesn't, it gets nastier, but
> there is absolutely no way we are going into the ARM swamp of having
> different kernels for different boards.

It doesn't. I'm currently developing using an add-on pci card running
on a more conventional computer (and there you may object it is not
even x86-specific, actually I'd love to see it sold as a separate card
for industrial use).

In short, the whole thing is about passing different platform data
according to which card it is (which includes the DMA configuration
for uart ports, the card-detect pin for mmci etc). Most such drivers
are already in the kernel and we are reusing them -- whereas original
code I got rewrote them all from scratch. But for this we need to pass
the platform data. 

I'm pretty sure we don't have ACPI, and I'd avoid device tree if
possible (especially thinking of add-on cards).  If you think it makes
more sense, I can offer the code to drivers/pci or other more generic
places.

thanks
/alessandro
