Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2GPPuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:50:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41631 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2GPPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:50:49 -0400
Message-ID: <50043791.2010609@us.ibm.com>
Date: Mon, 16 Jul 2012 08:47:29 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [Regression][Revert request] Excessive delay or hang during resume
 from system suspend due to a hrtimer commit
References: <201207152240.50129.rjw@sisk.pl> <alpine.LFD.2.02.1207161035500.32033@ionos> <201207161316.28875.rjw@sisk.pl> <alpine.LFD.2.02.1207161315050.32033@ionos> <alpine.LFD.2.02.1207161318010.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207161318010.32033@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071615-7408-0000-0000-000006CDAF90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 04:26 AM, Thomas Gleixner wrote:
> On Mon, 16 Jul 2012, Thomas Gleixner wrote:
>
>> On Mon, 16 Jul 2012, Rafael J. Wysocki wrote:
>>
>>> On Monday, July 16, 2012, Thomas Gleixner wrote:
>>>> On Sun, 15 Jul 2012, Rafael J. Wysocki wrote:
>>>>> To everyone involved: the fact that this change, which was likely to introduce
>>>>> regressions from the look of it alone, has been pushed to Linus (an to -stable
>>>>> at the same time!) so late in the cycle, is seriuosly disappointing.
>>>> Well, we spent an massive amount of time in testing, reviewing and
>>>> discussion and it definitely did not break suspend/resume here.
>>> I'm not saying that you didn't consider it thoroughly, but unfortunately you
>>> did overlook this particular issue, didn't you?
>>>
>>>> This was not pushed without a lot of thoughts and in fact what you are
>>>> seing is another long standing bug in the timekeeping resume code,
>>>> which was just papered over by the incorrect handling of the clock was
>>>> set cases in the other parts of the system.
>>>>
>>>> Does the following patch fix the problem for you ?
>>> Yes, it does, thanks!
>>>
>>>> @John: Should that clear ntp as well or is it enough to set ntp_error
>>>>         to 0 ?
>>>>
>>>> /me really goes on vacation now.
>>> So who's going to take care of the patch? :-)
>> I'm still packing gear. So i'll push it into timers/urgent.
> Actually that's a bad idea. John want's to double check vs. the
> ntp_clear question. So John can send it to linus directly.
>
> @John: Should it be: timekeeping_update(true)
I think its better to leave it as false, so we don't reset the NTP state 
machine completely after suspend.

When we come back from suspend our error is usually off by the 
persistent_clock/rtc granularity, so it might make sense, but I'd want a 
lot more testing of using ntp over suspend before changing the existing 
behavior of not doing it.

> Now I'm gone for real.
Ok. Thanks for spinning this up so quickly. I'll go ahead and send it on 
to Linus.

thanks
-john

