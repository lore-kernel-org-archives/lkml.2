Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2AGTvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 14:51:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64557 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2AGTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 14:51:51 -0500
Date: Sat, 7 Jan 2012 20:51:39 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20120107195139.GA19677@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <20111214072058.GA2180@netboy.at.omicron.at>
 <1323879832.6805.24.camel@work-vm>
 <20111214182121.GA2465@netboy.at.omicron.at>
 <1323889023.6805.61.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323889023.6805.61.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:57:03AM -0800, john stultz wrote:
> On Wed, 2011-12-14 at 19:21 +0100, Richard Cochran wrote:
> > - System clock represents TAI
> > - Table of {threshold; offset} values, read mostly, rarely updated
> > - Table has index pointing to next event
> > 
> > Get time becomes:
> > 
> > 1. read system time
> > 2. test threshold
> > 3. apply correction
> 
> Again, this seems relatively reasonable. But the difficulty in changing
> system clock to be TAI is getting the table initialized and updated on
> legacy systems that don't have the userland support added. 
> 
> I'd suggest starting with adding the threshold check and leap-second
> correction in the getnstimeofday() path, and then see how performance is
> impacted. 
> 
> That would let us improve leapsecond handling and get a sense of the
> performance impact prior to reworking the kernel internals to be TAI.

BTW, another leap second is coming this summer, and another chance to
test the kernel leap second handling.

It will also be a good day to simply avoid any time measurements, turn
off your computer, and boot up again the next day.

Richard
