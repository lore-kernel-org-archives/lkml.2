Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1CAQfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:35:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:52904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab1CAQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:35:46 -0500
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
In-Reply-To: <4D6D1A4C.1090009@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	 <1298865151-23656-4-git-send-email-daahern@cisco.com>
	 <1298989751.5226.863.camel@laptop>  <4D6D0438.2090901@cisco.com>
	 <1298993714.5226.871.camel@laptop>  <4D6D13C6.5020807@cisco.com>
	 <1298995250.5226.882.camel@laptop>  <4D6D1A4C.1090009@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 17:37:15 +0100
Message-ID: <1298997435.5226.890.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 09:09 -0700, David Ahern wrote:
> 
> I did not code it create samples of a realtime-clock event; I coded it
> to add an event to the stream on demand -- whatever event the fd is
> tied to.
> 
> 
Well yes, but aside from you and the realtime clock stuff, who'd ever
want to do this particular thing?

I'd much rather expose the whole
local_clock()/perf_clock()/trace_clock() (should all be the same anyway)
as a posix clock using CLOCK_TRACING or whatever would be an appropriate
name.

[ Since the whole thing is NMI safe it should be well possible to make a
VDSO version as well. ]

Anyway, once its visible as a posix clock you can sync up from
userspace. And this clock is indeed wanted for other things too, like
user-space tracing etc.

