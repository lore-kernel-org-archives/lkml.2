Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1BUVl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:41:57 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:7434 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1BUVl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:41:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAENqYk2rRN+K/2dsb2JhbACmP3OfPZtYhV4EhQ2HBoM7
X-IronPort-AV: E=Sophos;i="4.62,202,1297036800"; 
   d="scan'208";a="333073316"
Message-ID: <4D62DC21.4070407@cisco.com>
Date: Mon, 21 Feb 2011 14:41:53 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] perf events: Add realtime clock event and timehist
 option -v2
References: <1298322150-15505-1-git-send-email-daahern@cisco.com> <20110221213740.GC3583@nowhere>
In-Reply-To: <20110221213740.GC3583@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/21/11 14:37, Frederic Weisbecker wrote:

> The goal is actually to extend perf script to handle more than just raw data.
> So that it can handle the rest of what we can find in an event: time, ip, stacktraces...
> 
> You've added 200 lines in perf report to add the dump support. It wouldn't
> require more to extend perf script to do that. And the result is going to be
> much more powerful.
> 
> Look at struct scripting_ops::process_event().

I actually have a draft of perf-script - essentially duplicating sample
processing done in perf-report. When it got to the point of having to
add a lot of code -- other features essentially -- just to get it to the
point of being ready for this feature I stopped.

David


> 
> What you need is too pass in the whole event instead of only the raw data,
> cpu and so on...
> 
> You don't even need to add the support in the scripts themselves, they can
> just cope with the new parameter layout. You only need to handle the rest of
> the event in the print_event() function (the default scripting_ops::process_event())
> to print ip, time and stacktraces.
> 
> This probably needs some option in perf script to avoid showing ip and other
> new things. Although we probably want to print stacktraces by default
> if there are present.
