Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab0DHUfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:35:31 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54154 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab0DHUf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:35:28 -0400
Date: Thu, 8 Apr 2010 22:35:26 +0200
From: Andreas Mohr <andi@lisas.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andreas Mohr <andi@lisas.de>, Jens Axboe <axboe@kernel.dk>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Message-ID: <20100408203526.GA15426@rhlx01.hs-esslingen.de>
References: <20100404221349.GA18036@rhlx01.hs-esslingen.de> <4BBE38B9.6020507@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE38B9.6020507@tmr.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 04:12:41PM -0400, Bill Davidsen wrote:
> Andreas Mohr wrote:
>> Clearly there's a very, very important limiter somewhere in bio layer
>> missing or broken, a 300M dd /dev/zero should never manage to put
>> such an onerous penalty on a system, IMHO.
>>
> You are using a USB 1.1 connection, about the same speed as a floppy. If 

Ahahahaaa. A rather distant approximation given a speed of 20kB/s vs. 987kB/s ;)
(but I get the point you're making here)

I'm not at all convinced that USB2.0 would fare any better here, though:
after all we are buffering the file that is written to the device
- after the fact!
(plus there are many existing complaints of people that copying of large files
manages to break entire machines, and I doubt many of those were using
USB1.1)
https://bugzilla.kernel.org/show_bug.cgi?id=13347
https://bugzilla.kernel.org/show_bug.cgi?id=7372
And many other reports.

> you have not tuned your system to prevent all of the memory from being 
> used to cache writes, it will be used that way. I don't have my notes 
> handy, but I believe you need to tune the "dirty" parameters of 
> /proc/sys/vm so that it makes better use of memory.

Hmmmm. I don't believe that there should be much in need of being
tuned, especially in light of default settings being so problematic.
Of course things here are similar to the shell ulimit philosophy,
but IMHO default behaviour should be reasonable.

> Of course putting a fast device like SSD on a super slow connection makes 
> no sense other than as a test of system behavior on misconfigured 
> machines.

"because I can" (tm) :)

And because I like to break systems that happen to work moderately wonderfully
for the mainstream(?)(?!?) case of quad cores with 16GB of RAM ;)
[well in fact I don't, but of course that just happens to happen...]

Thanks for your input,

Andreas Mohr
