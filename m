Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1BRPju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:39:50 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:38390 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1BRPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:39:49 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABYiXk2rR7Ht/2dsb2JhbACEH6IEc6BFinuQP4Eng0F2BIULhwaDOg
X-IronPort-AV: E=Sophos;i="4.62,187,1297036800"; 
   d="scan'208";a="261975031"
Message-ID: <4D5E92C3.70003@cisco.com>
Date: Fri, 18 Feb 2011 08:39:47 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
Subject: Re: [PATCH 2/3] perf events: Introduce realtime clock event
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>	 <1298008433-22911-3-git-send-email-daahern@cisco.com>	 <1298027641.5226.666.camel@laptop>  <4D5E84AC.4040104@cisco.com> <1298041106.5226.775.camel@laptop>
In-Reply-To: <1298041106.5226.775.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 07:58, Peter Zijlstra wrote:
>>> I'm really not sure why you want CLOCK_REALTIME and I think
>>> CLOCK_MONOTONIC is more useful (I'd argue you want your system logs to
>>> contain both, every admin who's ever had to untangle what happened
>>> during DST switches will agree)
>>
>> I believe CLOCK_MONOTONIC is what perf_clock is tied to -- the
>> timestamps for PERF_SAMPLE_TIME -- so we already have that.
> 
> Its not (it mere _can_ be), it could be tied to the TSC which can
> significantly drift wrt CLOCK_MONOTONIC.

Ok, either way I would like correlation between perf_clock and the time
sample data and gettimeofday.

> 
>> Programs that generate time-of-day output are using gettimeofday which
>> is tied to CLOCK_REALTIME. We want to be able to correlate a perf sample
>> to an entry in an applications log file.
> 
> Well, you can argue those programs are broken :-), Imagine the joys of
> trying to figure out wth happens when DST jumps the clock back an hour
> and you have an hour of duplicate data.
> 

Luckily DST only happens twice a year. Of course reboots happen a little
more often and those reset the monotonic clock.

I can't change the known universe of programs that create pretty
HH:MM:SS MM/DD/YY time strings. What I do want is to know why a program
missed a heartbeat as noted by a log entry. Correlating with a perf
event and seeing the backtrace is quite handy.

David
