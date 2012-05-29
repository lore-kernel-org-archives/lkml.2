Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2E2HQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:16:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49507 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab2E2HQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:16:01 -0400
Message-ID: <4FC477A1.4010709@zytor.com>
Date: Tue, 29 May 2012 00:15:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
References: <4FC47003.1080906@zytor.com>  <4FC40C74.8050003@zytor.com>  <20120527205020.GA3050@mail.gnudd.com> <20120529063738.GA22711@mail.gnudd.com> <20120529070557.GA23373@mail.gnudd.com>
In-Reply-To: <20120529070557.GA23373@mail.gnudd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 12:05 AM, Alessandro Rubini wrote:
> 
> Yes, it indeed does (the original code I received did not, but mine
> doesn't break stuff for other systems). What I posted uses a kernel
> command-line argument to tell what board it is: the sta2x11 is the
> computer's chipset in most cases, so it should know the wiring soon.
> 

I am not going to accept into the kernel a bunch of board-specific
files.  PCI cards are different: they have PCI IDs, and they can be
loaded, as modules, at runtime.  Furthermore, they tend to be very
limited in the amount of variation: a single chip (represented PCI ID)
may be slightly differently wired on different boards (represented by
subsystem ID), but the variation tends to be limited; in the rare case
it is not, there is usually some form of discovery mechanism.

Those are the *only* kinds conditions under which that kind of things,
in drivers, is acceptable.  A list of mainboards and their wirings in C
code?  No way in hell.

>> The best is for the firmware on your platforms to provide the ACPI or
>> DTB information, as it should.  If it doesn't, it gets nastier, but
>> there is absolutely no way we are going into the ARM swamp of having
>> different kernels for different boards.
> 
> It doesn't. I'm currently developing using an add-on pci card running
> on a more conventional computer (and there you may object it is not
> even x86-specific, actually I'd love to see it sold as a separate card
> for industrial use).
> 
> In short, the whole thing is about passing different platform data
> according to which card it is (which includes the DMA configuration
> for uart ports, the card-detect pin for mmci etc). Most such drivers
> are already in the kernel and we are reusing them -- whereas original
> code I got rewrote them all from scratch. But for this we need to pass
> the platform data. 
> 
> I'm pretty sure we don't have ACPI, and I'd avoid device tree if
> possible (especially thinking of add-on cards).  If you think it makes
> more sense, I can offer the code to drivers/pci or other more generic
> places.

What does "offer the code" mean here?  Just put the same sh*t in a
different place?  No, no, no, no.

We have the device tree mechanism as an escape valve for the systems
built without any sane consideration for the platform, and that is the
last resort.  I am generally not happy with that in the x86 space, even,
because it means yet another failed platform, but it is still better
than ad hoc hacks.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

