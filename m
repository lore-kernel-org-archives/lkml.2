Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2ISQdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:33:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52619 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab2ISQdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:33:05 -0400
Message-ID: <5059F367.5020104@linaro.org>
Date: Wed, 19 Sep 2012 09:31:35 -0700
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
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org> <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com> <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at> <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at>
In-Reply-To: <20120919045038.GA2248@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12091916-9360-0000-0000-00000AD5A1EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 09:50 PM, Richard Cochran wrote:
> On Tue, Sep 18, 2012 at 11:29:50AM -0700, John Stultz wrote:
>> I believe its mostly historical, but on some architectures that
>> history has become an established ABI, making it technical.
> Fine, but what do you mean by "ABI?" Are you talking about magic
> addresses for functions?
On powerpc, I mean magic addresses where userland can find structures 
that it can use to calculate time.

On ia64 I mean the fsyscall method (which is arch specific).

> Without knowing the dirty details, what I imagine is a jump/branch
> from the arch-specific code into the common implementation.
>
> Can that be done?
In the two cases above, what you suggest unfortunately isn't possible 
(at least to my understanding - arch maintainers jump in to correct me).

With powerpc, there is no arch specific kernel code involved, its just a 
data structure the kernel exports that is accessible to userland. The 
execution logic lives in userland libraries, or sometimes application 
code itself.

With ia64's fsyscall, its a special mode that limits what you can do and 
which registers you access. So you couldn't just jump to other code 
while in that mode.

But maybe someone has a neat idea on how to get around this?

thanks
-john

