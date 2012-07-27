Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2G0T2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:28:44 -0400
Received: from mail.tmr.com ([64.65.253.246]:48369 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab2G0T2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:28:42 -0400
X-Greylist: delayed 1223 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2012 15:28:36 EDT
Message-ID: <5012E717.9070808@tmr.com>
Date: Fri, 27 Jul 2012 15:08:07 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Firefox/13.0.1 SeaMonkey/2.10.1
MIME-Version: 1.0
To: Kevin Ross <kevin@familyross.net>, Linux RAID <linux-raid@vger.kernel.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RAID extremely slow
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org> <5010A386.4080209@familyross.net> <5010CEFF.5030606@familyross.net>
In-Reply-To: <5010CEFF.5030606@familyross.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Ross wrote:
>
>>>
>>>> unused devices:<none>
>>>>
>>>> # cat /proc/sys/dev/raid/speed_limit_min
>>>> 10000
>>> MD is unable to reach its minimum rebuild rate while other system
>>> activity is ongoing.  You might want to lower this number to see if that
>>> gets you out of the stalls.
>>>
>>> Or temporarily shut down mythtv.
>>
>> I will try lowering those numbers next time this happens, which will probably
>> be within the next day or two.  That's about how often this happens.
>
> Unfortunately, it has happened again, with speeds at near zero.
>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdh1[0] sdd1[9] sde1[10] sdb1[6] sdi1[7] sdc1[4] sdf1[3]
> sdg1[8] sdj1[1]
>        6837311488 blocks super 1.2 level 6, 512k chunk, algorithm 2 [9/9]
> [UUUUUUUUU]
>        [=>...................]  resync =  8.3% (81251712/976758784)
> finish=1057826.4min speed=14K/sec
>
> unused devices: <none>
>
> atop doesn't show ANY activity on the raid device or the individual drives.
> http://img687.imageshack.us/img687/2913/screenshotfrom201207252.png
>
> Also, I tried writing to a test file with the following command, and it hangs.
> I let it go for about 30 minutes, with no change.
>
> # dd if=/dev/zero of=test bs=1M count=1
>
> dmesg only reports hung tasks.  It doesn't report any other problems. Here's my
> dmesg output:
> http://pastebin.ca/2174778
>
> I'm going to try rebooting into single user mode, and see if the rebuild
> succeeds without stalling.
>
Have you set the io scheduler to deadline on all members of the array? That's 
kind of "job one" on older kernels.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


