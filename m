Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab0ERSh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:37:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37233 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836Ab0ERSh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:37:26 -0400
Date: Tue, 18 May 2010 19:37:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Greg KH <greg@kroah.com>, CaT <cat@zip.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518183713.GS16821@decadent.org.uk>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org> <20100518114426.GY2657@zip.com.au> <20100518125539.GA23181@kroah.com> <20100518131706.GZ2657@zip.com.au> <20100518133336.GA23591@kroah.com> <4BF2C78A.7090903@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF2C78A.7090903@tmr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 12:59:54PM -0400, Bill Davidsen wrote:
> Greg KH wrote:
>> On Tue, May 18, 2010 at 11:17:06PM +1000, CaT wrote:
>>> On Tue, May 18, 2010 at 05:55:39AM -0700, Greg KH wrote:
>>>> I do not understand.  The firmware is now part of the linux-firmware
>>>> tree, and if you install that, it is working just fine, right?  We moved
>>>> the firmware out of the kernel tree on purpose.
>>>>
>>>> So what is the problem here?
>>> Well, the driver used to work and appears to be useless without it. I guess
>>> I'm wondering why it was kept out of the firmware directory where all the
>>> other firmware lives (and so allow the driver to simply continue to work
>>> and allow it to be compiled in).
>>
>> Because we are not adding new firmware to the kernel tree wherever
>> possible, but instead, putting it in the separate linux-firmware tree.
>>
> I don't think that's the case here, he's not asking that new firmware be 
> put in the kernel, just that existing firmware not be taken out.

New firmware should not be added to the kernel.  This rule has been
documented since v2.6.30.  Now this rule (like many others) is relaxed for
staging, but you can expect that firmware will be removed as part of the
cleanup process to make staging drivers follow the rules.

>>> At the moment all the change appears to have done is break things that have
>>> been working without issue since before the driver was even in staging.
>>
>> Just update the linux-firmware package and all will be working again.
>> We've been moving the firmware out of the staging drivers for a while
>> now, as they don't belong in the kernel tree.
>>
> I'm not sure that I see the logic of having a kernel with a driver which 
> doesn't work without the firmware, and a firmware tree which is equally 
> useless on it's own.
[...]

The firmware and driver are separate works, often written by different
people and usually released on a separate schedule under different licences.

> At the least I would expect the kernel build system 
> to refuse to build the driver unless the firmware was present, and then 
> build the firmware from wherever it's been hidden and put the whole thing 
> into a bootable kernel.
>
> Obviously firmware needs to be in the kernel image, or the building of 
> initram becomes really nasty for NFS root systems.

Modules that load firmware should have modinfo giving the filenames they
may requested.  Initramfs builders use that to find the files to include.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
