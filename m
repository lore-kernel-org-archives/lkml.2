Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab1LNQ0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:26:04 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40859 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1LNQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:26:01 -0500
Message-ID: <1323879832.6805.24.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Dec 2011 08:23:52 -0800
In-Reply-To: <20111214072058.GA2180@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
	 <1323747782.4078.144.camel@work-vm>
	 <20111214072058.GA2180@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121416-4242-0000-0000-000000547842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 08:20 +0100, Richard Cochran wrote:
> On Mon, Dec 12, 2011 at 07:43:02PM -0800, john stultz wrote:
> > 
> > Having a CLOCK_TAI would be interesting across the board. We already
> > keep a TAI offset in the ntp code. However, I'm not sure if ntp actually
> > sets it these days.
> 
> A bit OT, but what do think of the idea of keeping TAI in the kernel,
> and providing UTC via a tabular conversion routine?

Agreed its OT for this thread. 

> Michel Hack wrote an article last year detailing how Linux botches the
> leap second and suggested a more robust way to handle it.

Hmm. Do you have a link to the article? 

I like the idea of having TAI as a kernel clockid. The hard part is
getting systems to initialize it properly at boot. 

Also part of the issue with leapseconds is that time functions are such
a hot path, we can't really add extra conditionals checking for leap
seconds. Instead the leapsecond occurs on the first tick of the
leapsecond.

More interestingly to me is Google's recent use of slewed leapseconds.
However, how that would work on a public network is a bit more fuzzy.
And being able to support both TAI and slewed leapseconds would require
quite a bit more logic.

thanks
-john


