Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496Ab0LOEYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:24:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56488 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0LOEYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:24:31 -0500
Message-ID: <4D084331.3030301@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 12:25:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Lai Jiangshan <eag0628@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
References: <4D07330A.7020600@cn.fujitsu.com>	 <1292335269.5015.1798.camel@gandalf.stny.rr.com>	 <AANLkTi=Ui3mUsi0wHxRYasGsS20tuTfEi8xzMT3o9g+F@mail.gmail.com> <1292346055.5015.1815.camel@gandalf.stny.rr.com>
In-Reply-To: <1292346055.5015.1815.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 12:24:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 12:24:29,
	Serialize complete at 2010-12-15 12:24:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 01:00 AM, Steven Rostedt wrote:
> On Wed, 2010-12-15 at 00:44 +0800, Lai Jiangshan wrote:
>> On Tue, Dec 14, 2010 at 10:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>>
>>>>
>>>> This is the motivation of this patch.
>>>>
>>>> An approach(wrong): when C's priority become higher and B, we deprive
>>>> the pending ownership from B and give it to C and wakeup C.
>>>> But this approach may lead to livelock.
>>>
>>> I'm curious to how this can cause a livelock. I'm not doubting you, but
>>> I just woke up, and I'm only half way through my first cup of coffee.
>>>
>>
>> if B is deprived, B has go to sleep again. In rare condition,
>> B,C 's priority are changed frequent, the pending ownership is
>> given to B/ deprived from B and given to C/ deprived from C and given to B
>> ......
>>
>> No task can go forward, it is a kind of livelock.
> 
> Hmm, to have C and B change prios frequently, they will need to either
> have someone in some for loop doing chrt on them (which is just bad), or
> have lots of RT tasks constantly blocking on tasks that they own, which
> is also bad. I find this far from a livelock, and any case that does
> this would have more issues than causing a livelock here.
> 

Hi, Thomas,

Do you think this is a kind of livelock.
If it is not, I will send a much simpler patch.

Thanks,
Lai.
