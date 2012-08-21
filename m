Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2HUSPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:15:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57696 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab2HUSPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:15:19 -0400
Message-ID: <5033D00B.4060701@linaro.org>
Date: Tue, 21 Aug 2012 11:14:35 -0700
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
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org> <1342156917-25092-5-git-send-email-john.stultz@linaro.org> <m2fw7ilhnm.fsf@igel.home> <503288ED.10306@linaro.org> <m2fw7h4ab5.fsf@igel.home> <503296C1.4070906@linaro.org> <m2boi549ed.fsf@igel.home> <5033029A.2030201@linaro.org> <m2d32kemyp.fsf@igel.home>
In-Reply-To: <m2d32kemyp.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082118-8974-0000-0000-00000C6B74B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 12:14 AM, Andreas Schwab wrote:
> John Stultz <john.stultz@linaro.org> writes:
>
>> @@ -115,6 +115,7 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
>>   {
>>   	tk->xtime_sec += ts->tv_sec;
>>   	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
>> +	tk_normalize_xtime(tk);
>>   }
> Yes, that does it.  Failure to normalize is always bad.

Great. Thanks for the testing and the bug report! I'll be sending out 
the patch to -tip later today.

thanks
-john

