Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1BRSpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:45:04 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:48371 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1BRSpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:45:02 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADdNXk2rR7H+/2dsb2JhbACEH6IGc59uinuQPIEng0F2BIULhwaDOg
X-IronPort-AV: E=Sophos;i="4.62,188,1297036800"; 
   d="scan'208";a="265956039"
Message-ID: <4D5EBE2C.7000701@cisco.com>
Date: Fri, 18 Feb 2011 11:45:00 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>	 <1298008433-22911-4-git-send-email-daahern@cisco.com>	 <20110218070657.GA11404@elte.hu> <4D5E8204.2090501@cisco.com>	 <20110218175926.GA3445@nowhere>  <4D5EB564.6030504@cisco.com> <1298054399.5226.779.camel@laptop>
In-Reply-To: <1298054399.5226.779.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 11:39, Peter Zijlstra wrote:
> On Fri, 2011-02-18 at 11:07 -0700, David Ahern wrote:
>> We want not only context-switch events, but the stack trace at the
>> switch. 
> 
> Both ftrace and perf can do that:
> 
>  perf record -ge sched:sched_switch -c 1

Yes, exactly. And that is what I am using -- well, -e cs -c 1.

> 
> or
> 
> echo 1 > /debug/tracing/options/stacktrace

> 
>> That data along with the gettimeofday timestamp has allowed us to
>> resolve performance issues such as a system call taking longer than
>> expected during a specific sequence of events or a process getting
>> preempted and not scheduled for N seconds. etc., etc.
> 
> Non of that seems to require GTOD stamps.

On 01/23/11 at 03:45:67 a syslog event noted an application restart.
Checking the applications logs it went silent. Why? What does perf say?

Oh, 2 days have gone by before said event is reported to engineering,
and the server was been rebooted to 'clear' the problem - hence
resetting monotonic clock.

Multiply that by 100's of processes.

David

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
