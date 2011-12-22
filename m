Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1LVMDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 07:03:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38169 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1LVMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 07:03:43 -0500
Date: Thu, 22 Dec 2011 13:03:26 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111222120326.GA3360@cherladcori01>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at>
 <1323881310.6805.41.camel@work-vm>
 <20111214183025.GB2465@netboy.at.omicron.at>
 <1323889666.6805.71.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323889666.6805.71.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:07:46AM -0800, john stultz wrote:
> On Wed, 2011-12-14 at 19:30 +0100, Richard Cochran wrote:
> > 
> > So, you agree on adding new syscalls as a performance tweek?
> 
> Well, the patch that started this off was introducing a new vdso
> function (which had no syscall equivalent) that provided the same data
> as clock_gettime(CLOCK_THREAD_CPUTIME,...) but in ns format, because
> that was a reasonable performance win.

I don't see anything CLOCK_THREAD_CPUTIME in the patches, but I do see
CLOCK_REALTIME and CLOCK_MONOTONIC.

How is this about thread CPU time? (I assumed it was about fast time
stamps.)

> I don't think what is being proposed is trying to limit its use cases.
> The only limitation api wise was if we should return just nanoseconds or
> something with the potential for sub-ns values.

Yes, I do think new interfaces should anticipate sub-ns uses.

> > I mean to define an interface that always returns TAI values, no matter
> > what the clock device.
> 
> Maybe I'm still not understanding, but that seems more limited then what
> is being proposed, at least in my mind. clock_gettime_ns() would still
> take a clockid, so having a CLOCK_TAI would be a potential change in the
> future.

POSIX got the clock_gettime interface wrong, because you cannot tell
the time with it. The POSIX interface will return the same time value
for two consecutive seconds, due to leap seconds.

IMHO, new interfaces should correct this mistake. So, a new interface
providing UTC should also tell the user about leap seconds.

Just my 2 cents,

Richard
