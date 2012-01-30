Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2A3Lba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:31:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab2A3Lb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:31:28 -0500
Date: Mon, 30 Jan 2012 12:31:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Steets <asteets@rgmadvisors.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120130113115.GA6565@elte.hu>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
 <1327917156.2446.191.camel@twins>
 <20120130101121.GB8924@elte.hu>
 <1327921293.2446.202.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327921293.2446.202.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2012-01-30 at 11:11 +0100, Ingo Molnar wrote:
> > So, what workflow are you suggesting to Andrew?
> 
> Librarize perf record, then in your code do something like:
> 
> #include "perf_record.h"

Maybe. (and then it shouldnt be limited to perf_record.h but 
should be events.h plus libevents.so or such)

> 
>   handle = perf_record_init(); /* creates perf events and creates
>                                   a record thread that writes samples
>                                   to perf.data, consumes env(PERF_*)
>                                   for configuration, registers with
>                                   at_exit() for cleanup */
>   if (!handle)
>     /* burn */
> 
>   /* do you other code */
> 
>   perf_record_start(handle);
> 
>   /* do the bit you want profiled */
> 
>   perf_record_stop(handle);
> 
> Then build with -lperfrecord or so. Not too hard, right?

Isnt a simple prctl() so much easier and faster?

What's your concern with the prctl()? This would arguably be the 
right kind of usage for prctl(): it's an established API/ABI for 
process/task-wide settings.

Thanks,

	Ingo
