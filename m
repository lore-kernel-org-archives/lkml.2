Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2IRSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:02:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61029 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2IRSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:02:15 -0400
Date: Tue, 18 Sep 2012 20:02:00 +0200
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
Message-ID: <20120918180200.GA2281@netboy.at.omicron.at>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5057BE59.3050903@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 05:20:41PM -0700, John Stultz wrote:
> On 09/17/2012 04:49 PM, Andy Lutomirski wrote:
> >2. There's nothing vsyscall-specific about the code in
> >vclock_gettime.c.  In fact, the VVAR macro should work just fine in
> >kernel code.  If you moved all this code into a header, then in-kernel
> >uses could use it, and maybe even other arches could use it.  Last
> >time I checked, it seemed like vclock_gettime was considerably faster
> >than whatever the in-kernel equivalent did.
> I like the idea of unifying the implementations, but I'd want to
> know more about why vclock_gettime was faster then the in-kernel
> getnstimeofday(), since it might be due to the more limited locking
> (we only update vsyscall data under the vsyscall lock, where as the
> timekeeper lock is held for the entire execution of
> update_wall_time()), or some of the optimizations in the vsyscall
> code is focused on providing timespecs to userland, where as
> in-kernel we also have to provide ktime_ts.

This there a valid technical reason why each arch has its own vdso
implementation?

If not, I would suggest that the first step would be to refactor these
into one C-language header. If this can be shared with kernel code,
then all the better.

It would make it a lot easier to fix the leap second thing, too.

Thanks,
Richard

