Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0ERRAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:00:31 -0400
Received: from lo.gmane.org ([80.91.229.12]:48220 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab0ERRAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:00:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Date: Tue, 18 May 2010 12:59:54 -0400
Message-ID: <4BF2C78A.7090903@tmr.com>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org> <20100518114426.GY2657@zip.com.au> <20100518125539.GA23181@kroah.com> <20100518131706.GZ2657@zip.com.au> <20100518133336.GA23591@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: CaT <cat@zip.com.au>, Linus Torvalds <torvalds@linux-foundation.org>,
       bzolnier@gmail.com, stable@kernel.org, ben@decadent.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: pool-68-236-145-113.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
In-Reply-To: <20100518133336.GA23591@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, May 18, 2010 at 11:17:06PM +1000, CaT wrote:
>> On Tue, May 18, 2010 at 05:55:39AM -0700, Greg KH wrote:
>>> I do not understand.  The firmware is now part of the linux-firmware
>>> tree, and if you install that, it is working just fine, right?  We moved
>>> the firmware out of the kernel tree on purpose.
>>>
>>> So what is the problem here?
>> Well, the driver used to work and appears to be useless without it. I guess
>> I'm wondering why it was kept out of the firmware directory where all the
>> other firmware lives (and so allow the driver to simply continue to work
>> and allow it to be compiled in).
> 
> Because we are not adding new firmware to the kernel tree wherever
> possible, but instead, putting it in the separate linux-firmware tree.
> 
I don't think that's the case here, he's not asking that new firmware be put in 
the kernel, just that existing firmware not be taken out.

>> At the moment all the change appears to have done is break things that have
>> been working without issue since before the driver was even in staging.
> 
> Just update the linux-firmware package and all will be working again.
> We've been moving the firmware out of the staging drivers for a while
> now, as they don't belong in the kernel tree.
> 
I'm not sure that I see the logic of having a kernel with a driver which doesn't 
work without the firmware, and a firmware tree which is equally useless on it's 
own. At the least I would expect the kernel build system to refuse to build the 
driver unless the firmware was present, and then build the firmware from 
wherever it's been hidden and put the whole thing into a bootable kernel.

Obviously firmware needs to be in the kernel image, or the building of initram 
becomes really nasty for NFS root systems.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

