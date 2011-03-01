Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1CAOSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:18:42 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39560 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1CAOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:18:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG+ObE2rRN+K/2dsb2JhbACmTHSfJJwphWEEhRKHDYNA
X-IronPort-AV: E=Sophos;i="4.62,246,1297036800"; 
   d="scan'208";a="336978493"
Message-ID: <4D6D004F.5010602@cisco.com>
Date: Tue, 01 Mar 2011 07:18:55 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf script: dump software events too
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>	<1298865151-23656-5-git-send-email-daahern@cisco.com> <AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>
In-Reply-To: <AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/01/2011 07:09 AM, Frederic Weisbecker wrote:
> 
> That's not on the right place. This is going to print the events even
> when we launch scripts. We only want to print them when we launch
> perf script without a script, which falls back to printing events
> (look at default_scripting_ops).
> 
> Like I suggested you, it's better to extend struct
> scripting_ops::process_event()
> to take the whole event and let the handler decide what to do.
> Python and Perl scripting engines can just extract the raw sample and
> do like they did before.
> But print_event(), which is the process_event() handler for the
> default_scripting_ops,
> can handle the new printing features.
> 
> That's also more flexible, this lets Python and Perl scripting engines
> be extendable
> to handle the rest of the event later.

I don't follow what you mean.

This is the same place that tracepoints are dumped. In the
PERF_TYPE_TRACEPOINT case process_event == print_event which dumps the
lines to stdout.

I came in added a switch that invokes a different handler for software
events. Software events will be processed differently than tracepoint.
The print_event function and its pretty_print function are not designed
to dump software events (and eventually hardware events).

David
