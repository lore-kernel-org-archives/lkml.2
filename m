Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2ISRzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:55:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49813 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab2ISRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:55:13 -0400
Message-ID: <505A06BD.6000406@linaro.org>
Date: Wed, 19 Sep 2012 10:54:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org> <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com> <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at> <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at> <5059F367.5020104@linaro.org> <20120919170347.GA2232@netboy.at.omicron.at>
In-Reply-To: <20120919170347.GA2232@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091917-2876-0000-0000-000000500EF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 10:03 AM, Richard Cochran wrote:
> On Wed, Sep 19, 2012 at 09:31:35AM -0700, John Stultz wrote:
>> With powerpc, there is no arch specific kernel code involved, its
>> just a data structure the kernel exports that is accessible to
>> userland. The execution logic lives in userland libraries, or
>> sometimes application code itself.
> I took a brief look at arch/powerpc/kernel/vdso32/gettimeofday.S and
> arch/powerpc/kernel/vdso64/gettimeofday.S, and I see what looks a lot
> like functions
Sorry, yes. My statement wasn't subtle enough (and I may be confusing my 
history).

You are right, there is arch specific code involved, but the data 
structure that is exported is considered part of the abi since some 
applications access it directly.

See the comments and structure in:
arch/powerpc/include/asm/vdso_datapage.h


> $ find arch/powerpc/kernel/vdso* -name gettimeofday.S|xargs grep FUNCTION_BEGIN
>
> arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_gettimeofday)
> arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_gettime)
> arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_getres)
> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_gettimeofday)
> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_gettime)
> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_getres)
> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__do_get_tspec)
>
> and I wonder whether these could be done in C instead.

Possibly, but I suspect they're in asm for performance reasons.

Paul/Ben: Do you have any thoughts here?

thanks
-john

