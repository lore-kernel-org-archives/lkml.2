Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1BUWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:09:56 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:49959 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1BUWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:09:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEtxYk2rR7H+/2dsb2JhbACmP3OfN5tahV4EhQ2HBoM7
X-IronPort-AV: E=Sophos;i="4.62,202,1297036800"; 
   d="scan'208";a="267947224"
Message-ID: <4D62E2B0.1070607@cisco.com>
Date: Mon, 21 Feb 2011 15:09:52 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] perf events: Add realtime clock event and timehist
 option -v2
References: <1298322150-15505-1-git-send-email-daahern@cisco.com> <20110221213740.GC3583@nowhere> <4D62DC21.4070407@cisco.com> <20110221215533.GD3583@nowhere>
In-Reply-To: <20110221215533.GD3583@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/21/11 14:55, Frederic Weisbecker wrote:
> On Mon, Feb 21, 2011 at 02:41:53PM -0700, David Ahern wrote:
>>
>>
>> On 02/21/11 14:37, Frederic Weisbecker wrote:
>>
>>> The goal is actually to extend perf script to handle more than just raw data.
>>> So that it can handle the rest of what we can find in an event: time, ip, stacktraces...
>>>
>>> You've added 200 lines in perf report to add the dump support. It wouldn't
>>> require more to extend perf script to do that. And the result is going to be
>>> much more powerful.
>>>
>>> Look at struct scripting_ops::process_event().
>>
>> I actually have a draft of perf-script - essentially duplicating sample
>> processing done in perf-report. When it got to the point of having to
>> add a lot of code -- other features essentially -- just to get it to the
>> point of being ready for this feature I stopped.
> 
> 
> I don't understand why it's harder to extend print_event() rather than
> perf report.

All of the changes to perf-report are related strictly to this feature -
generating the timestamp and printing the sample including walking the
callchain.

perf-script needs to have features added to it:
  1. working with all samples,
  2. support for callchains,
  3. more?
Then it is ready for adding a timestring to the output.

Sure it can be done, but a series of patches unrelated to timehist are
needed first.

As part of looking at perf-script (the draft I mentioned) I actually
moved most of the perf-report changes into a util/timehist.c as it is
directly usable by both commands.

David
