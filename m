Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1CaAk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:40:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:52898 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab1CaAk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:40:26 -0400
Date: Wed, 30 Mar 2011 17:39:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nicolas Pitre <nico@fluxnic.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
Message-ID: <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <alpine.DEB.2.00.1103301728002.15330@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Nicolas Pitre wrote:

> On Wed, 30 Mar 2011, Linus Torvalds wrote:
>
>> On Wed, Mar 30, 2011 at 1:41 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>>>
>>> Trying to rely on bootloaders doing things right is like saying that x86
>>> should always rely on the BIOS doing things right.
>>
>> No. Not at all.
>>
>> The problem with firmware/BIOS is that it's set in stone and closed-source.
>>
>> I'm suggesting splitting out the crazy part into a separate project
>> that does this. Open-source. Like a mini-kernel. Because the thing is,
>> the main kernel doesn't care, and _shouldn't_ care. Those board files
>> are just noise.
>
> Sure, but important noise nevertheless.  As long as the noise is
> confined to a limited set of .c files I'm happy.  OTOH I have very
> little hope for a separate project that would only deal with that noise.
> That will simply never fly, even less so as an Open Source project.
> The insentive for people to work on such thing simply aren't there as
> that is totally uninteresting and without any rewards.
>
> Furthermore, this does create pain.  you have to make things in sync
> between the kernel and the mini-kernel (let's call it bootloader).  In
> practice the bootloader is always maintained separately from the kernel,
> on its own pace and with its own release schedule.  Trying to
> synchronize independent projects is really painful as you know already,
> otherwise the user space for perf would still be maintained separately
> from the kernel, right?

Being separate from the kernel with it's own release schedule could be a 
good thing.

using the example of clocks. if the clock definitions were in the 
bootloader project, then when a new board is produced with a slightly 
different clock arrangement, all you have to do is to update the 
bootloader to pass the new definition to the kernel, and then you can use 
a well tested kernel that has been put through it's paces on other 
hardware already.

Today you have to get the change upstream into the kernel, and then use 
the new kernel (which always includes new features and bugs that you have 
to test for)

you aren't saying that you are allowing arbatrary binary blobs to be 
passed to the kernel from the bootloader, you are only saying that you 
allow well defined board definition descriptions to be passed to the 
kernel from the bootloader.

yes the bootloader can try to pass binary garbage to the kernel, but the 
kernel doesn't have to be written to accept it. The kernel side remains 
under your control even if the bootloader piece is owned by someone else.

the two pieces do not need to be released and updated in lockstep. yes, 
there will be (many) cases where a new kernel adds support for a new type 
of device, but the communications format between the bootloader and the 
kernel can be designed to be tolorant of such skew. Even before the kernel 
knows how to drive the hardware you can have the format of the information 
about that hardware defined (allowing the bootloader to pass information 
to the kernel that it just ignores because it doesn't have a driver in it 
for that particulare piece of hardware), and if the bootloader doesn't 
tell the kernel about some device, the kernel will just ignore that 
device.

this means that you need to have some group doing the equivalent of 
assigning device numbers for the different devices (and in this case going 
just a little further to define what setup parameters will be needed), 
initially this may be a little rough, but after a very short time I would 
expect the people doing this work to start recognising that even though 
vendor A who first proposes this device has some things hard-wired, the 
definition format should support these things as variables instead of 
being assumed.

David Lang
