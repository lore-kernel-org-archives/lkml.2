Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab2CGUIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:08:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:40706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab2CGUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126289979"
Message-ID: <4F57C007.5050006@linux.intel.com>
Date: Wed, 07 Mar 2012 12:07:35 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: jon@jonshouse.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Random process lockup on ARM board: alsa-lib-1.0.25, FUTEX_WAIT_PRIVATE
References: <1329393691.6830.20.camel@jonspc> <1329512682.29051.1.camel@jonspc> <1329570128.6670.0.camel@jonspc> <4F400BBF.9020707@ladisch.de> <1329603022.1089.57.camel@jonspc> <4F41FC28.1070605@ladisch.de> <1329926198.22918.10.camel@jonspc> <4F45167A.6080706@ladisch.de> <1330043397.4669.44.camel@jonspc> <CAMiH66EdB9KN1gw_hG=34zab56RxcPKB7G2MyJALfD_5z1yeVQ@mail.gmail.com>
In-Reply-To: <CAMiH66EdB9KN1gw_hG=34zab56RxcPKB7G2MyJALfD_5z1yeVQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/29/2012 01:12 AM, Huang Shijie wrote:
> Hi ,
> 
> I meet a similar problem with the latest futex code.
> 
> I play the video and the processes will hang at the futex.

Are either of you able to bisect the kernel? At the very least can you
find two kernels where it works and where it does not?

Hanging on FUTEX_WAIT_PRIVATE can be the symptom for higher level
problems including userspace locking issues and race conditions.

Huang, are you also on ARM?

--
Darren

> 
> BR
> Huang Shijie
> 
> On Fri, Feb 24, 2012 at 8:29 AM, Jonathan Andrews <jon@jonshouse.co.uk> wrote:
>> Using kernel 3.2.5 with alsa-lib 1.0.25, all compiled with generic
>> Debian arm-linux-gnueabi toolchain.
>>
>> arm-linux-gnueabi-gcc (Debian 4.3.2-1.1) 4.3.2
>> Was used to build kernel, alsa-lib and application.
>>
>> Changing gcc version, kernel version or alsa-lib version makes the
>> problem worse or better, but ALL versions seem to suffer this problem. I
>> have also seen it once on Intel (but only once so far).
>>
>> Something seeks broken at a lower layer than im using.  I simply don't
>> have the skill to debug it.
>>
>> The hardware is a USB cm109 audio adapter, but the problem seems to show
>> on more than this one driver.
>>
>> The audio application writing to alsa will freezes at random intervals,
>> infrequent at the moment, last one was after runtime 20H 37M 29S.  Two
>> processes are running, one reading from the sound device and one writing
>> to the sound device. I am not using threading or anything very clever
>> just generic alsa functions.
>>
>> This is the only diagnostic I can generate so far as running the
>> application under strace slows it to the point it no longer functions
>> enough to generate the problem.
>>
>> ARM / # strace -p 417
>> Process 417 attached - interrupt to quit
>> futex(0x175734, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
>> Process 417 detached
>>
>> ARM / # uname -a
>> Linux (none) 3.2.5 #2 Wed Feb 22 17:11:52 GMT 2012 armv4tl GNU/Linux
>> ARM / # uptime
>>  22:36:19 up 22:36,  0 users,  load average: 0.15, 0.16, 0.18
>> ARM / # cat /proc/cpuinfo
>> Processor       : ARM920T rev 0 (v4l)
>> BogoMIPS        : 199.06
>> Features        : swp half thumb crunch
>> CPU implementer : 0x41
>> CPU architecture: 4T
>> CPU variant     : 0x1
>> CPU part        : 0x920
>> CPU revision    : 0
>>
>>
>> Any help welcome.
>>
>> Thanks,
>> Jon
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
