Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0KRMrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:47:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:51818 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab0KRMrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:47:52 -0500
Message-ID: <4CE52048.5080802@windriver.com>
Date: Thu, 18 Nov 2010 06:47:04 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com> <4CDD579F.80009@windriver.com> <20101112154231.GN4823@redhat.com> <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu>
In-Reply-To: <20101118080516.GJ32621@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 12:47:07.0172 (UTC) FILETIME=[B55CD640:01CB871E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 02:05 AM, Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> On 11/16/2010 12:43 PM, Don Zickus wrote:
>>     
>>> On Fri, Nov 12, 2010 at 12:27:55PM -0500, Don Zickus wrote:
>>>
>>> Hi Jason,
>>>
>>>   
>>>       
>>>>> I tested 2.6.35 and it does not hard hang, but suffered from a different
>>>>> problem with a perf API change.   The kgdb tests appear to loop and loop
>>>>> emitting endless streams of output in 2.6.35 and I already have that
>>>>> problem patched.
>>>>>       
>>>>>           
>>> I keep getting the following stack trace which is different than your
>>> hang.  Is this looping I am seeing something with the NMI or kgdb?
>>>
>>>   
>>>       
>> That was also a regression due to changes in the perf API for which I
>> have a patch pending.
>>
>> I can send you the patch which Frederic has already tested OR you can
>> turn off CONFIG_DEBUG_RODATA in the kernel config, which is the source
>> of that particular problem.  
>>     
>
> Would be nice to know that Don's series does not introduce a regression for kgdb 
> before i can apply the patches.
>   

The behavior was still broken in the exact same way before and after
Don's series.

The real problem here is that the perf NMI handlers are consuming events
that are not intended for a perf call back handler.   More specifically
when another subsystem injects an NMI event the perf NMI code returns
NOTIFY_STOP.

That being said, Don's series looks sane to me.

Tested-by: Jason Wessel <jason.wessel@windriver.com>

Thanks,
Jason.
