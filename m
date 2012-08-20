Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2HTT6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:58:20 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54609 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2HTT6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:58:15 -0400
Message-ID: <503296C1.4070906@linaro.org>
Date: Mon, 20 Aug 2012 12:57:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] time: Condense timekeeper.xtime into xtime_sec
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org> <1342156917-25092-5-git-send-email-john.stultz@linaro.org> <m2fw7ilhnm.fsf@igel.home> <503288ED.10306@linaro.org> <m2fw7h4ab5.fsf@igel.home>
In-Reply-To: <m2fw7h4ab5.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082019-5518-0000-0000-000006FACFDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 12:45 PM, Andreas Schwab wrote:
> John Stultz <john.stultz@linaro.org> writes:
>
>> I'm not very familiar w/ the iBook hardware, but does it use a
>> clocksource, or does it use arch_gettimeoffset()?
> clocksource: timebase mult[3640e38e] shift[24] registered
>
>> I suspect that the casting has avoided clipping some strange values from
>> the persistent clock.
> That's my guess as well.
>
>> Could you try with the following patch against Linus' HEAD? I suspect it
>> will let the box resume (although it will seem as though no time was
>> spent in resume) and then let me know what the JDB lines print out?
> JDB: suspend_time: 1345491706:0  resume_time: 1345491737:0
> JDB: Trying to add: 31:0
>
> (Looks reasonable.)
Huh.  Yea, that looks fine.  And without the 
__timekeeping_inject_sleeptime() call, the system resumed ok?

Thanks for the testing!  I'll keep looking here.
-john





