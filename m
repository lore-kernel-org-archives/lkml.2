Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2A3N7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:59:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab2A3N7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:59:00 -0500
Date: Mon, 30 Jan 2012 14:58:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Steets <asteets@rgmadvisors.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120130135836.GA5703@elte.hu>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
 <1327917156.2446.191.camel@twins>
 <20120130101121.GB8924@elte.hu>
 <1327921293.2446.202.camel@twins>
 <20120130113115.GA6565@elte.hu>
 <1327931107.2446.205.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327931107.2446.205.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > What's your concern with the prctl()? This would arguably be 
> > the right kind of usage for prctl(): it's an established 
> > API/ABI for process/task-wide settings.
> 
> Its doing things backwards, [...]

What does that mean?

> [...] also the whole concept of allowing people to hide things 
> from a profiler is so rotten I'm not willing to even consider 
> the notion.

But what we want here is not to hide things from the profiler, 
what we want to be able to is to *ask* the profiler to hide 
things for us, and we do that for a good reason.

This distinction (which I agree is important) could be 
implemented by adding a "allow self-profiling" bit (default 
disabled) in the perf_attr. That way such code would not be able 
to 'hide' from a simple:

  perf top
  perf record -a

session, but would be able to self-profile from such a session:

  perf record --allow-self-profile ...

where there could be some easy shortcut for 
--allow-self-profile, such as:

  perf record -S

that way no code could ever hide from a profiler, only if the 
profiler is specifically allowing self-profiling. (opt in)

The librarization you suggested might make sense too - but i 
think people will gravitate towards the easier to use variant, 
and prctl() is as easy and straightforward as it gets.

We can Cc: it to Linus with an explicit [RFC] and he can shoot 
it down if the API is ugly - but I don't think it's ugly.

Hm?

Thanks,

	Ingo
