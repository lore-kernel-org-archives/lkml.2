Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab1CCOdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:33:08 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:2054 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175Ab1CCOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:33:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADk1b02rRN+J/2dsb2JhbACmZXSjEpwehWEEhRqHEoNC
X-IronPort-AV: E=Sophos;i="4.62,258,1297036800"; 
   d="scan'208";a="338637773"
Message-ID: <4D6FA6B4.7060407@cisco.com>
Date: Thu, 03 Mar 2011 07:33:24 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, acme@ghostprotocols.net,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, John Stultz <johnstul@us.ibm.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
References: <1298865151-23656-1-git-send-email-daahern@cisco.com> <1298865151-23656-4-git-send-email-daahern@cisco.com> <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6> <4D6E5413.6060500@cisco.com> <20110303085148.GA16832@elte.hu>
In-Reply-To: <20110303085148.GA16832@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/03/2011 01:51 AM, Ingo Molnar wrote:
> 
> * David Ahern <daahern@cisco.com> wrote:
> 
>>> How does all that deal with CLOCK_REALTIME being affected by NTP and
>>> settimeofday? Not really, as far as I can tell. It somehow works, but
>>> that depends on the frequency of your event injection.
>>
>> It is sampled at some periodic rate to get NTP changes. Right now it is
>> hardcoded at once an hour. The frequency option can be added to the
>> --tod parameter.
> 
> As Thomas mentioned, we probably need something more complete than that.

Just responded to Thomas' email with a simpler proposal than munging on
tracepoints and trying to track time-of-day implicitly.

> Still your approach is obviously useful and i'd like to stress that explicitly. Have 

Thanks for stating that.

> you considered another related feature, feeding printk lines as special 'string 
> events' into the perf ringbuffer?
> 
> It would round up your scheme very nicely: that way you'd have a single, global, 
> GTOD-correlated event store/flow for basically every system event you might be 
> interested in. You could switch events (and tracepoints) on/off based on need, 
> controlling the type and rate of information in a very finegrained way.
> 
> If the printk approach works out i'd even suggest that such a facility would need a 
> separate tool within perf: 'perf syslog' or 'perf log'. It would heavily reuse 
> perf-script and other perf internal facilities, obviously - but you would not be 
> tied to any particular sub-tool implementation.
> 
> EDAC type events could feed into this as well, giving the tool a broader 'system 
> health' aspect as well, beyond the 'system performance analysis' aspect.

I can look into it (as time allows) once I get the dumping of software
events done.

David

> 
> Thanks,
> 
> 	Ingo
