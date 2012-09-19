Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2ISVMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:12:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44887 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2ISVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:12:13 -0400
Message-ID: <505A34E6.6040107@linaro.org>
Date: Wed, 19 Sep 2012 14:11:02 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org> <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com> <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at> <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at> <5059F367.5020104@linaro.org> <20120919170347.GA2232@netboy.at.omicron.at> <505A06BD.6000406@linaro.org> <CALCETrUAiLXvxYMnNDvdUSFkno+v+P_XGirOYch-k8dUG05jpw@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F19D43167@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D43167@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091921-4242-0000-0000-000002F5320F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 01:50 PM, Luck, Tony wrote:
>> Does anything except the vDSO actually use the vDSO data page?  It's
>> mapped as part of the vDSO image (i.e. at a non-constant address), and
>> it's not immediate obvious how userspace would locate that page.
> Just for reference - on ia64 the address of the entry point for the magic
> fast system call page is passed to each applications via the "auxv" structure
> that exec(2) drops at the top of stack after args/env in the AT_SYSINFO
> entry. Apps look for it to find out where to jump for fast system call entry
> (if it isn't there, they fall back to regular slow syscall path).

Nice. So we could "disable" fsyscalls on a kernel and not break 
userland. That makes it easier to replace with the vdso method at some 
point. So that's good to hear!

> Same method could be used to provide the address of a magic read-only
> for users page that kernel fills with stuff for simple system calls.

Now, I suspect the difficult part will be finding someone with the time 
and interest to try get the vdso gettime working on ia64 (or s390 or 
powerpc), and then try to unify the kernel side implementation. Reducing 
the maintenance burden might not be inspirational enough, especially if 
there is a small performance cost along with it.

I sort of suspect that its more likely that such unification work could 
be done as part of enabling vdso on an otherwise non vsyscall enabled 
arch (like ARM), since at least there they have the carrot of the 
performance gain to drive them.

And also, all this discussion is a bit far afield of the patchset I'm 
proposing here. :)  I'd still like to hear any thoughts on it from the 
various arch maintainers, otherwise I'll submit it to Thomas.

thanks
-john

