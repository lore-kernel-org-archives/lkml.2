Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1DGN3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:29:17 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34031 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1DGN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:29:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9DBC90.6080401@cam.ac.uk>
Date: Thu, 07 Apr 2011 14:30:56 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Possible to software trigger an interrupt?
References: <4D989A8A.3050700@cam.ac.uk> <4D98A185.1080704@cam.ac.uk> <20110407132048.GA7257@home.goodmis.org>
In-Reply-To: <20110407132048.GA7257@home.goodmis.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/11 14:20, Steven Rostedt wrote:
> On Sun, Apr 03, 2011 at 05:34:13PM +0100, Jonathan Cameron wrote:
>> On 04/03/11 17:04, Jonathan Cameron wrote:
>>> Hi,
>>>
>>> Having produced a proof of concept for using gpio chips
>>> to handle the triggers in IIO I am looking at converting
>>> over our sysfs trigger.  This trigger is used to initialize
>>> capture on devices in a similar way to dataready interrupts.
>>> The key point is we want to handle this in the same way within
>>> drivers as the hardware event triggers. 
>>>
>>> It is a very useful tool.  So the upshot is, what is the best
>>> way to handle causing an interrupt to occur from userspace?
>>>
>>> Any pointers on how to do this would be most welcome.
>>
>> For what it is worth, the incredibly dumb approach of just
>> calling handle_nested_irq seems to 'work'.   I dread to think
>> what that might be quietly breaking though...
> 
> I think you are fine in calling that. It's made to be called from a
> threaded context. But if you are testing code that will someday be
> called in an interrupt context, it may not catch everything you need.
That's not the primary aim. Some of these triggers really are only called
from userspace and there are devices that some users will only ever
trigger that way.  It's also step one in allowing a bridge to input for
polled devices (via uinput).
> 
> For example, a mutex is allowed to be called from a threaded context,
> but not from a hard irq one. There may be other subtle locking issues as
> well. These could be caught with lockdep, but only when the code is
> really been executed from hard irq context.
Cool.  We have plenty of real irq triggers as well. I'll just pester
people to make sure they have tested with both if at all possible!

Thanks for the reassurance that isn't all that likely to blow up
in my face ;)

Jonathan
