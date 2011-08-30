Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1H3Pim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:38:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43770 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1H3Pil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:38:41 -0400
Message-ID: <4E5D03EA.1010309@gmail.com>
Date: Tue, 30 Aug 2011 08:38:18 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: using mce_inject I get: RIP 10:<ffffffffa012c909> {ttm_bo_unref+0xf/0x45
 [ttm]}
References: <4E506DEA.1070601@gmail.com> <20110821221602.GK25996@one.firstfloor.org> <4E53EB01.7080905@gmail.com> <987664A83D2D224EAE907B061CE93D5301EA5B717B@orsmsx505.amr.corp.intel.com> <4E59072A.5040108@gmail.com> <CAC=cRTNJgRfYk9qpeX4=8FtPSr-c0_MGr48VnOBrp01-d3yhWQ@mail.gmail.com>
In-Reply-To: <CAC=cRTNJgRfYk9qpeX4=8FtPSr-c0_MGr48VnOBrp01-d3yhWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 06:07 PM, huang ying wrote:
> On Sat, Aug 27, 2011 at 11:03 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 08/23/2011 01:15 PM, Luck, Tony wrote:
>>>>
>>>> its easily fixable, but not sure its a good idea due to bisect going
>>>> through commits(afraid I might go astray with the bisect if I add any
>>>> patches).
>>>
>>> Rather than fixing a bad build - you can try moving to a nearby commit
>>> (use "gitk" to get a view of the structure around the commit that git
>>> bisect suggested).  In the early stages of a bisection, it doesn't really
>>> matter much if you build the mid-point that bisect provided, or some
>>> nearby on - just be sure to mark good/bad the commit you actually built.
>>>
>>> -Tony
>>>
>>>
>>
>> well.. after bisecting(with no results), I found that something in my
>> .config was causing this, so after looking through, I found that having
>> X86_MCE_INJECT = y causes the pauses when the timeouts occur
>>
>> let me know if I need to supply any info.
>
> Which test case cause the pause?  Some test case with "timeout" in
> name may cause timeout between CPUs.  Or you can try boot system with
> kernel parameter "mce=3,0", which will disable timeout.
>
> Best Regards,
> Huang Ying
>


cool thanks for the info.
I went and used mce=3,0 on the command line, and then ran the mce-test 
suite. unfortunantly the pause still occurs.
as for which timeouts bassically when any of the timeouts

here is what the verbosity looks like:

`/home/kernel/mce-inject/mce-test'
./drivers/simple/driver.sh simple.conf

soft-inj/non-panic/corrected:
   Failed: can not get gcov graph
   Passed: MCE log is ok
   Passed: No kernel warning or bug

soft-inj/non-panic/corrected_hold:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug

soft-inj/non-panic/corrected_no_en:
   Failed: can not get gcov graph
   Passed: MCE log is ok
   Passed: No kernel warning or bug

soft-inj/non-panic/corrected_over:
   Failed: can not get gcov graph
   Passed: MCE log is ok
   Passed: No kernel warning or bug

soft-inj/panic/fatal:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Fatal Machine check
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_eipv:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Fatal Machine check
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_irq:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Fatal Machine check
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_no_en:
   Failed: can not get gcov graph
   Passed: MCE log is ok
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Machine check from unknown source

soft-inj/panic/fatal_over:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Fatal Machine check
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_ripv:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Fatal Machine check
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_timeout:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: : Fatal machine check on current CPU
   Failed: no timeout detected
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_timeout_ripv:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: : Fatal machine check on current CPU
   Failed: no timeout detected
   Failed:  uncorrected MCE exp, expected: Processor context corrupt

soft-inj/panic/fatal_userspace:
   Failed: can not get gcov graph
   Failed: MCE log is different from input
   Passed: No kernel warning or bug
   Failed: uncorrect panic, expected: Fatal Machine check
   Failed:  uncorrected MCE exp, expected: Processor context corrupt



in dmesg I see:

[  102.491609] Starting machine check poll CPU 1
[  102.492077] [Hardware Error]: Machine check events logged
[  102.492086] Machine check poll done on CPU 1
[  123.537575] Triggering MCE exception on CPU 0
[  123.537584] Disabling lock debugging due to kernel taint
[  123.537594] [Hardware Error]: Machine check events logged
[  123.537597] MCE exception done on CPU 0
[  129.779850] Triggering MCE exception on CPU 1
[  129.779879] MCE exception done on CPU 1
[  137.030085] Triggering MCE exception on CPU 0
[  137.030108] MCE exception done on CPU 0
[  143.286096] Triggering MCE exception on CPU 0
[  143.286110] MCE exception done on CPU 0
[  149.541391] Triggering MCE exception on CPU 0
[  149.541409] MCE exception done on CPU 0
[  156.785580] Triggering MCE exception on CPU 1
[  156.785602] MCE exception done on CPU 1
[  164.011576] Triggering MCE exception on CPU 0
[  164.012558] mce_notify_irq: 4 callbacks suppressed
[  164.012558] [Hardware Error]: Machine check events logged
[  166.795340] MCE exception done on CPU 0
[  173.088624] Triggering MCE exception on CPU 0
[  173.089600] [Hardware Error]: Machine check events logged
[  177.119421] MCE exception done on CPU 0
[  184.373355] Triggering MCE exception on CPU 1
[  184.373372] MCE exception done on CPU 1
[  190.741030] Triggering MCE exception on CPU 1
[  190.741047] MCE exception done on CPU 1


let me know if you need more info.

Justin P. Mattock
