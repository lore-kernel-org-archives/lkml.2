Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2KLX1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:27:50 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53615 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab2KLX1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:27:47 -0500
Message-ID: <50A185D7.9080902@us.ibm.com>
Date: Mon, 12 Nov 2012 15:27:19 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: RCU NOHZ, tsc, and clock_gettime
References: <5077157A.7060401@redhat.com> <50772350.1070903@us.ibm.com> <20121011202103.GB2476@linux.vnet.ibm.com> <507839FC.3060204@redhat.com>
In-Reply-To: <507839FC.3060204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111223-5112-0000-0000-00000E7E359F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 08:40 AM, Prarit Bhargava wrote:
>
>>> One possibility is that if the cpu we're doing our timekeeping
>>> accumulation on is different then the one running the test, we might
>>> go into deeper idle for longer periods of time. Then when we
>>> accumulate time, we have more then a single tick to accumulate and
>>> that might require holding the timekeeper/xtime lock for longer
>>> times.
>>>
>>> And the max 2.9ns variance seems particularly low, given that we do
>>> call update_vsyscall every so often, and that should block
>>> clock_gettime() callers while we update the vsyscall data.  Could it
>>> be that the test is too short to see the locking effect, so you're
>>> just getting lucky, and that adding nohz is jostling the regularity
>>> of the execution so you then see the lock wait times?  If you
>>> increase the samples and sample loops by 1000 does that change the
>>> behavior?
> That's a possiblity, although I suspect that this has more to do with not
> executing the RCU NOHZ code given that we don't see a problem with the
> clock_gettime() vs clock_gettime() test.  I wonder if not executing the RCU NOHZ
> code somehow introduces a "regularity" with execution that results in the CPU
> always being in C0/polling when the test is run?
Hey Prarit,
     Just back from being on leave, and wanted to check in on this. Did 
you ever get to run with an increase sample size to see how that 
affected things?  Its exactly your point that the non-NOHZ case could 
align the execution of a short run in a way that you always see good 
results, where as with NOHZ the alignment might not be the same, so you 
see periodic delays from timer interrupts, etc.

Anyway, let me know if this got resolved or not.

thanks
-john

