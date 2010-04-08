Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab0DHWBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:01:51 -0400
Received: from mail.tmr.com ([64.65.253.246]:56771 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab0DHWBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:01:49 -0400
Message-ID: <4BBE5240.3050606@tmr.com>
Date: Thu, 08 Apr 2010 18:01:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Jens Axboe <axboe@kernel.dk>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
References: <20100404221349.GA18036@rhlx01.hs-esslingen.de> <4BBE38B9.6020507@tmr.com> <20100408203526.GA15426@rhlx01.hs-esslingen.de>
In-Reply-To: <20100408203526.GA15426@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> On Thu, Apr 08, 2010 at 04:12:41PM -0400, Bill Davidsen wrote:
>   
>> Andreas Mohr wrote:
>>     
>>> Clearly there's a very, very important limiter somewhere in bio layer
>>> missing or broken, a 300M dd /dev/zero should never manage to put
>>> such an onerous penalty on a system, IMHO.
>>>
>>>       
>> You are using a USB 1.1 connection, about the same speed as a floppy. If 
>>     
>
> Ahahahaaa. A rather distant approximation given a speed of 20kB/s vs. 987kB/s ;)
> (but I get the point you're making here)
>
> I'm not at all convinced that USB2.0 would fare any better here, though:
> after all we are buffering the file that is written to the device
> - after the fact!
> (plus there are many existing complaints of people that copying of large files
> manages to break entire machines, and I doubt many of those were using
> USB1.1)
> https://bugzilla.kernel.org/show_bug.cgi?id=13347
> https://bugzilla.kernel.org/show_bug.cgi?id=7372
> And many other reports.
>
>   
>> you have not tuned your system to prevent all of the memory from being 
>> used to cache writes, it will be used that way. I don't have my notes 
>> handy, but I believe you need to tune the "dirty" parameters of 
>> /proc/sys/vm so that it makes better use of memory.
>>     
>
> Hmmmm. I don't believe that there should be much in need of being
> tuned, especially in light of default settings being so problematic.
> Of course things here are similar to the shell ulimit philosophy,
> but IMHO default behaviour should be reasonable.
>
>   
>> Of course putting a fast device like SSD on a super slow connection makes 
>> no sense other than as a test of system behavior on misconfigured 
>> machines.
>>     
>
> "because I can" (tm) :)
>
> And because I like to break systems that happen to work moderately wonderfully
> for the mainstream(?)(?!?) case of quad cores with 16GB of RAM ;)
> [well in fact I don't, but of course that just happens to happen...]
>   

I will tell you one more thing you can do to test my thought that you 
are totally filling memory, copy data to the device using DIRECT to keep 
from dirtying cache. It will slow the copy (to a slight degree) and keep 
the system responsive. I used to have a USB 2.0 disk, and you are right, 
it will show the same problems. That's why I have some ideas of tuning.

And during the 2.5 development phase I played with "per fd" limits on 
memory per file, which solved the problem for me. I had some educational 
discussions with several developers, but this is one of those things 
which has limited usefulness and development was very busy at that time 
with things deemed more important, so I never tried to get it ready for 
inclusion in the kernel.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

