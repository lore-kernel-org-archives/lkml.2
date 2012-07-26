Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab2GZFAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:00:51 -0400
Received: from mail-hostigation.familyross.net ([69.85.93.112]:41119 "EHLO
	mail.familyross.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2GZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:00:50 -0400
Message-ID: <5010CEFF.5030606@familyross.net>
Date: Wed, 25 Jul 2012 22:00:47 -0700
From: Kevin Ross <kevin@familyross.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Phil Turmel <philip@turmel.org>
CC: linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
Subject: Re: RAID extremely slow
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org> <5010A386.4080209@familyross.net>
In-Reply-To: <5010A386.4080209@familyross.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>>> unused devices:<none>
>>>
>>> # cat /proc/sys/dev/raid/speed_limit_min
>>> 10000
>> MD is unable to reach its minimum rebuild rate while other system
>> activity is ongoing.  You might want to lower this number to see if that
>> gets you out of the stalls.
>>
>> Or temporarily shut down mythtv.
>
> I will try lowering those numbers next time this happens, which will 
> probably be within the next day or two.  That's about how often this 
> happens.

Unfortunately, it has happened again, with speeds at near zero.

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[0] sdd1[9] sde1[10] sdb1[6] sdi1[7] sdc1[4] 
sdf1[3] sdg1[8] sdj1[1]
       6837311488 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[9/9] [UUUUUUUUU]
       [=>...................]  resync =  8.3% (81251712/976758784) 
finish=1057826.4min speed=14K/sec

unused devices: <none>

atop doesn't show ANY activity on the raid device or the individual drives.
http://img687.imageshack.us/img687/2913/screenshotfrom201207252.png

Also, I tried writing to a test file with the following command, and it 
hangs.  I let it go for about 30 minutes, with no change.

# dd if=/dev/zero of=test bs=1M count=1

dmesg only reports hung tasks.  It doesn't report any other problems.  
Here's my dmesg output:
http://pastebin.ca/2174778

I'm going to try rebooting into single user mode, and see if the rebuild 
succeeds without stalling.

-- Kevin

