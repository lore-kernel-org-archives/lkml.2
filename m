Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2ISREE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:04:04 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61805 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2ISREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:04:01 -0400
Date: Wed, 19 Sep 2012 19:03:47 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
Message-ID: <20120919170347.GA2232@netboy.at.omicron.at>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org>
 <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org>
 <20120919045038.GA2248@netboy.at.omicron.at>
 <5059F367.5020104@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5059F367.5020104@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 09:31:35AM -0700, John Stultz wrote:

> On powerpc, I mean magic addresses where userland can find
> structures that it can use to calculate time.

...
 
> With powerpc, there is no arch specific kernel code involved, its
> just a data structure the kernel exports that is accessible to
> userland. The execution logic lives in userland libraries, or
> sometimes application code itself.

I took a brief look at arch/powerpc/kernel/vdso32/gettimeofday.S and
arch/powerpc/kernel/vdso64/gettimeofday.S, and I see what looks a lot
like functions

$ find arch/powerpc/kernel/vdso* -name gettimeofday.S|xargs grep FUNCTION_BEGIN

arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_gettimeofday)
arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_gettime)
arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_getres)
arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_gettimeofday)
arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_gettime)
arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_getres)
arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__do_get_tspec)

and I wonder whether these could be done in C instead.

Thanks,
Richard
