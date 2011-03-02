Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1CBR2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:28:41 -0500
Received: from www.tglx.de ([62.245.132.106]:32910 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1CBR2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:28:40 -0500
Date: Wed, 2 Mar 2011 18:28:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Ahern <daahern@cisco.com>
cc: linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        acme@ghostprotocols.net, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
In-Reply-To: <4D6E5413.6060500@cisco.com>
Message-ID: <alpine.LFD.2.00.1103021821080.2701@localhost6.localdomain6>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com> <1298865151-23656-4-git-send-email-daahern@cisco.com> <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6> <4D6E5413.6060500@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, David Ahern wrote:
> On 03/02/2011 07:16 AM, Thomas Gleixner wrote:
> > How does all that deal with CLOCK_REALTIME being affected by NTP and
> > settimeofday? Not really, as far as I can tell. It somehow works, but
> > that depends on the frequency of your event injection.
> 
> It is sampled at some periodic rate to get NTP changes. Right now it is
> hardcoded at once an hour. The frequency option can be added to the
> --tod parameter.

Once an hour. Brilliant. And how do you correlated that when
settimeofday was called 5 times in between the samples. Not at all.

> > 
> > To be honest, that's just too much churn for a feature which is single
> > purpose and questionable functionality.
> > 
> > It would be far more interesting to have trace points in the
> > timekeeping code, which are useful for other things as well
> > (e.g. precise monitoring of NTP) and provide always a correct
> > association with the trace clock. That would cover everything from
> > frequency adjustments, clock setting including the information about
> > the relation to clock monotonic.
> 
> I'm not looking to track ntp changes. I want time-of-day strings on
> sample dumps. That is not a questionable feature request; it is a
> usability enhancement.

Sigh, did you even read what I wrote? 

I did not say, that YOU have to track NTP changes.

And I fully understood that you want to correlate perf time
stamps with CLOCK_REALTIME.

Neither did I say, that this is a questionable feature request.

I merily objected to add functionality which is half baken and only
particular useful.

Further I made a suggestion to add trace points to the time keeping
code instead, which

      - solve your problem
      - are useful for other purposes
      - do not require ioctls, timer driven sw events

Thanks,

	tglx
