Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab1CYH0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:26:30 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:60851 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1CYH02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:28 -0400
X-ASG-Debug-ID: 1301037986-01de284cf8ba280001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8C43A0.3070908@fusionio.com>
Date: Fri, 25 Mar 2011 08:26:24 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de> <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <20110325044128.GJ26611@dastard>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325044128.GJ26611@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301037986
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58904
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 05:41, Dave Chinner wrote:
> On Thu, Mar 24, 2011 at 08:34:41PM +0100, Markus Trippelsdorf wrote:
>> On 2011.03.24 at 19:58 +0100, Jens Axboe wrote:
>>> On 2011-03-24 19:54, Markus Trippelsdorf wrote:
>>>> On 2011.03.24 at 19:51 +0100, Jens Axboe wrote:
>>>>> On 2011-03-24 19:36, Jens Axboe wrote:
>>>>>> On 2011-03-24 19:30, Markus Trippelsdorf wrote:
>>>>>>> On 2011.03.24 at 14:43 +0100, Jens Axboe wrote:
>>>>>>>>
>>>>>>>> This is the main pull request for the block IO layer and friends for
>>>>>>>> 2.6.39.
>>>>>>>
>>>>>>> This merge results in an early oops on my system (amd64, xfs).
>>>>>>> See the attached photo.
>>>>>>>
>>>>>>
>>>>>> Auch. Can you ensure that you have CONFIG_DEBUGINFO=y in your .config
>>>>>> and then do:
>>>>>>
>>>>>> $ gdb vmlinux
>>>>>> ...
>>>>>> l *cfq_insert_request+0x32
>>>>>>
>>>>>> and send that output?
>>>>>
>>>>> I took a closer look at the oops, and it most likely looks like q ==
>>>>> NULL (offset 0x18 == q->elevator). You left out the Code part, so I
>>>>> can't verify that for certain. Which makes very little sense. I take it
>>>>> this is 100% reproducible? When you send the gdb output, please also
>>>>> attach your .config.
>>>>
>>>> Yes, it's 100% reproducible here. My .config follows:
>>>
>>> Can you try this patch and see if it makes a difference?
>>
>> There's no patch ;-)
>>
>>> If you boot without the patch and add elevator=noop, does it then work?
>>
>> It works insofar as the Oops is gone. But my xfs partitions apparently
>> still get corrupted (I had to run xfs_repair on several of them, because
>> they would not mount otherwise).
> 
> So the patchset is causing repeatable filesystem corruption? Sounds
> to me like this series is not yet ready for mainline merging. Last
> thing I want to spend the .39 cycle helping people recover busted
> filesystems as a result of undercooked block layer changes...

Well, the last thing I want to do is be responsible for screwing peoples
file systems. I have been running these changes on my laptop, desktop,
and test machines for the last month at least. It's been in linux-next
for about that long, too. I'm extremely puzzled at this issue that
Markus reports.

So believe me, if we can't resolve this very quickly then we'll pull it
back out.

-- 
Jens Axboe

