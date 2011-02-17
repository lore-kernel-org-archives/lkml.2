Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1BQCwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:52:35 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:20310 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756050Ab1BQCwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:52:33 -0500
Message-ID: <4D5C8D62.4060809@bluewatersys.com>
Date: Thu, 17 Feb 2011 15:52:18 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Charles Manning <manningc2@actrix.gen.nz>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171112.07101.manningc2@actrix.gen.nz> <20110217014808.GD5824@sirena.org.uk> <201102171531.03924.manningc2@actrix.gen.nz>
In-Reply-To: <201102171531.03924.manningc2@actrix.gen.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/11 15:31, Charles Manning wrote:
> On Thursday 17 February 2011 14:48:08 Mark Brown wrote:
>> On Thu, Feb 17, 2011 at 11:12:06AM +1300, Charles Manning wrote:
>>> On Wednesday 16 February 2011 21:04:20 Christoph Hellwig wrote:
>>>> The procfs interfaces should be replaced by something saner,
>>>> the insane amount of ad-hoc tracing crap should be replaced by much
>>>> less strategically placed trace events, and all those stupid compile
>>>> time options have absolutely no business at all beeing there for a
>>>> filesystem -
>>>
>>> Why not?
>>>
>>>> remember you can get media from all over the place.
>>>
>>> No you can't. This is a flash file system for soldered down flash. I
>>> think that is a fundamental place where your understanding of what yaffs
>>> is falls down.
> 
> I'm not sure I really understand what Christoph means by "get media from all 
> over the place". I took that to mean he thinks people will pug in random 
> flash cards and would need to fiddle with options to make them work. That 
> would of course suck badly.
> 
> That is obviously not the case for a flash file system used on hard-wired 
> flash where the system integrator is in control. Users don't get to fiddle.
> 
>>
>> Even for embedded systems people do end up wanting to do things like
>> using the same kernel on multiple systems which may have different
>> hardware configurations (distros and reference boards are the obvious
>> examples, but I've worked on systems where multiple generations and
>> builds of the product were in active use and similar enough to be
>> maintained from the same kernel).  Even with single system kernels
>> there's still an issue with things like reference boards where users are
>> doing things like picking up a new upstream kernel rather than the
>> vendor BSP.
> 
> Every one of the "stupid compile time options" is there because someone that 
> actually **uses** yaffs wanted it. None are there just for fun. The 
> compile-time switches are very limited - mostly just there to set up default 
> runtime flags that can be overridden at runtime. Some of them are there to 
> work around bugs and limitations in the mtd.

The Kconfig options which are can be overridden by runtime flags should
simply be removed. Pick a default and stick with it. Existing users will
either have to modify their mount flags to suit, continuing using an old
version, or patch the yaffs code themselves.

It's also possibly worth removing some of the more esoteric options such
as the ECC options at least for the first attempt at getting Yaffs into
mainline. It will make it easier to get the code accepted, and if enough
users complain that the feature is not there a sensible way to patch it
in can be added later.

I think the downside at the moment is that it is getting less and less
likely that you can maintain a single yaffs codebase and get it merged
into mainline. I really think you are going to need to fork the code.

> 
> Even with BSPs, there will often be some board tuning to, do things like set 
> up the mtd partitions.
> 
> Picking up an new kernel is easy, so long as the mtd code has not been broken 
> in the interum. 
> 
> Last week I dropped the yaffs code into an omap3 build of 2.6.37 with no 
> fiddling and with default settings and it "just worked".

Mark is talking about the case where you have a single kernel which can
be run on multiple boards/platforms. This is becoming increasingly
common for development and testing purposes. Because some of the yaffs
config options are compile time only selectable, it may not be possible
to support yaffs correctly on multiple boards in a single kernel. This
is why it is much more ideal for config options to be mount flags.

~Ryan
