Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab1LNSV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:21:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40000 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1LNSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:21:25 -0500
Date: Wed, 14 Dec 2011 19:21:21 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111214182121.GA2465@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <20111214072058.GA2180@netboy.at.omicron.at>
 <1323879832.6805.24.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323879832.6805.24.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 08:23:52AM -0800, john stultz wrote:
> On Wed, 2011-12-14 at 08:20 +0100, Richard Cochran wrote:
> > Michel Hack wrote an article last year detailing how Linux botches the
> > leap second and suggested a more robust way to handle it.
> 
> Hmm. Do you have a link to the article? 

I don't think it is online. Do you have the magic IEEE access?

http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=5609776

> I like the idea of having TAI as a kernel clockid. The hard part is
> getting systems to initialize it properly at boot. 
> 
> Also part of the issue with leapseconds is that time functions are such
> a hot path, we can't really add extra conditionals checking for leap
> seconds. Instead the leapsecond occurs on the first tick of the
> leapsecond.

The idea would only involve one conditional and one addition:

- System clock represents TAI
- Table of {threshold; offset} values, read mostly, rarely updated
- Table has index pointing to next event

Get time becomes:

1. read system time
2. test threshold
3. apply correction

> More interestingly to me is Google's recent use of slewed leapseconds.
> However, how that would work on a public network is a bit more fuzzy.
> And being able to support both TAI and slewed leapseconds would require
> quite a bit more logic.

Do you mean smoothing the jump over the entire day (or other
interval)? This is also discussed in Hack's paper.

Thanks,
Richard
