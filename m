Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2GPRzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:55:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42178 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2GPRza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:55:30 -0400
Message-ID: <5004553A.2060104@us.ibm.com>
Date: Mon, 16 Jul 2012 10:54:02 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression][Revert request] Excessive delay or hang during resume
 from system suspend due to a hrti
References: <CA+icZUXURRAs-rK1EnRidYUQ9NXXYw4DaHbn=4mcEe3Q0sU+2A@mail.gmail.com> <CA+icZUWUhZpRKU5rO+m4Xe1DNLYAq8NPBCS_B2c3Kmgq+gBQ3w@mail.gmail.com>
In-Reply-To: <CA+icZUWUhZpRKU5rO+m4Xe1DNLYAq8NPBCS_B2c3Kmgq+gBQ3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071617-1976-0000-0000-00000F3C4B16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 10:51 AM, Sedat Dilek wrote:
> On Mon, Jul 16, 2012 at 7:16 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> [ QUOTE ]
>>
>> Hi Linus,
>>
>> Please revert:
>>
>> commit 5baefd6d84163443215f4a99f6a20f054ef11236
>> Author: John Stultz <johnstul@us.ibm.com>
>> Date:   Tue Jul 10 18:43:25 2012 -0400
>>
>>      hrtimer: Update hrtimer base offsets each hrtimer_interrupt
>>
>> This breaks resume on the iBook G4 and Toshiba Portege R500 (at least), by
>> adding an excessive delay to it (the Toshiba box sometimes hangs hard during
>> resume from system suspend).  According to Andreas
>> (https://lkml.org/lkml/2012/7/15/66):
>>
>> "Apparently during or before noirq resume the system is hanging by the same
>> amount of time as the system was sleeping."
>>
>> which seems to agree with my observations.
>>
>> Given that the two known-affected boxes are so different, it is quite probable
>> that the total number of affected systems is actually quite high.
>>
>> Thanks!
>>
>>
>> To everyone involved: the fact that this change, which was likely to introduce
>> regressions from the look of it alone, has been pushed to Linus (an to -stable
>> at the same time!) so late in the cycle, is seriuosly disappointing.
>>
>> Thanks,
>> Rafael
>>
>> [ /QUOTE ]
>>
>> Hi,
>>
>> when I booted 1st into Linux-3.5-rc7 (a few hours after release) I had
>> a call-trace in get_next_timer_interrupt() (NULL pointer dereference)
>> on early-boot.
>> The machine got frozen.
>>
>> I can't say if this is related to the same issue here, but I can
>> confirm after suspend + resume the machine (sandy-bridge ultrabook) I
>> am working on is in an unusable state.
>> I had to cold reboot/restart.
>>
>> Regards,
>> - Sedat -
>>
>> P.S.: Unfortunately, I could not reproduce the NULL-deref again.
>> Thomas gave me some instruction to enable some debugobjects
>> kernel-options (see attached backlog from IRC).
> Hi,
>
> John asked me on IRC to send my kernel-config and to clarify about my
> experiences with the NULL-deref I saw in get_next_timer_interrupt():
> I only saw it once - even after several bootups/bootins - as said at
> the very beginning - the machine was unusable - hard reset.
> Unfortunately, I had no digicam around to take a screenshot.

Thanks for sending your config and test results.

Looking at the call trace you provided, I'm not seeing anything yet, but 
I'll be looking over the code while running my test boxes in a reboot 
loop w/ your config to see if I can't figure out the 
get_next_timer_interrupt issue you saw at bootup.

thanks
-john

