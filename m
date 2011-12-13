Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1LMDnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:43:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36449 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LMDnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:43:49 -0500
Message-ID: <1323747782.4078.144.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 12 Dec 2011 19:43:02 -0800
In-Reply-To: <20111213032406.GA9604@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121303-7282-0000-0000-000004DD2569
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 04:24 +0100, Richard Cochran wrote:
> On Mon, Dec 12, 2011 at 05:26:36PM -0800, Andy Lutomirski wrote:
> > On x86-64, clock_gettime is so fast that the overhead converting to and
> > from nanoseconds is non-negligible.  clock_gettime_ns is a different
> > interface that is potentially faster.  If people like the ABI, I'll
> > implement an optimized version.
> 
> I am not so interested in performance optimizations, but do I think
> offering time in nanoseconds is attractive from an application point
> of view. The timespec is impractical for everyone.
> 
> While you are at it with new syscalls, why not make a clean break from
> POSIX and fix the uglies?
> 
> - New name, to distance ourselves from POSIX (clock_ns_get?)
> - Family of calls, with set/get
> - Sub nanosecond field
> - TAI time base (or according to parameter?)

Having a CLOCK_TAI would be interesting across the board. We already
keep a TAI offset in the ntp code. However, I'm not sure if ntp actually
sets it these days.

thanks
-john

