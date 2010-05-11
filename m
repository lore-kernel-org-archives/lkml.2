Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0EKPBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:01:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:60105 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab0EKPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:01:16 -0400
Date: Tue, 11 May 2010 12:00:52 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Subject: Re: [RFC] perf: perf record sets inherit by default
Message-ID: <20100511150052.GE19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 11, 2010 at 04:04:17PM +0200, Stephane Eranian escreveu:
> I am confused by the inheritance cmd line option of perf record:

>  usage: perf record [<options>] [<command>]
>     or: perf record [<options>] -- <command> [<options>]
>     -p, --pid <n>         record events on existing process id
>     -t, --tid <n>         record events on existing thread id
>     -a, --all-cpus        system-wide collection from all CPUs
>     -C, --profile_cpu <n> CPU to profile on
>     -i, --inherit         child tasks inherit counters
 
> This leads to believe that by default inheritance in children is off.
 
> However, builtin-record.c says:
> static bool                     inherit    =   true;
 
> If that's the case, what's the point of the -i option?

Humm, since for -C and -a using -i doesn't make sense, I guess it should
be off by default and only be auto-activated if we don't specify any
option, i.e. when using it like:

perf record ./hackbench

What do you think?
 
> Another side effect of inheritance is that in per-thread mode, perf
> creates as many "sessions" as you have CPUs. So on a 16-way processor,
> sampling on cycles, perf creates 16 events and 16 x 2-page sampling
> buffers. That's a lot of resources consumed if I am just interested in
> monitoring a single-threaded workload.
 
> Am I missing something here?

I don't think so, but maybe I'm missing too :-)

- Arnaldo
