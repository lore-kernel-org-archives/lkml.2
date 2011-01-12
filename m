Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1ALMLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:11:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:43334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1ALMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:11:33 -0500
Date: Wed, 12 Jan 2011 10:11:13 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Mike Galbraith <efault@gmx.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: [BUG] perf sched broken
Message-ID: <20110112121113.GD11968@ghostprotocols.net>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 12, 2011 at 10:29:05AM +0100, Stephane Eranian escreveu:
> Hi,
> 
> I am trying to use perf sched from tip-x86 but it fails for all my attempts.
> 
> First of, I think the event list is stale. This is not so much the
> events themselves
> but rather the flags.
> 
> Looks to me like the :r modifier is not supported anymore, so a patch like the
> one below is needed. That helps collect a trace. But then, you can dump
> the trace.

I got to this point as well, and reverting 4c635a4 did the trick for me,
Corey, this is another report for that problem, can you take a look at
it? Stephane, can you try doing a:

git show 4c635a4 | patch -p1 -R

To see if the problem is fixed?

- Arnaldo
 
> $ perf sched rec dd if=/dev/zero of=/dev/null count=1000000
> 1000000+0 records in
> 1000000+0 records out
> 512000000 bytes (512 MB) copied, 0.589981 s, 868 MB/s
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.481 MB perf.data (~20997 samples) ]
> 
> $ perf sched rep
> run measurement overhead: 2934 nsecs
> sleep measurement overhead: 90502 nsecs
> the run test took 999149 nsecs
> the sleep test took 1092248 nsecs
>   Fatal: no trace data in the file
> 
> $ perf sched trace -D
>  usage: perf sched [<options>] {record|latency|map|replay|trace}
> 
>     -i, --input <file>    input file name
>     -v, --verbose         be more verbose (show symbol address, etc)
>     -D, --dump-raw-trace  dump raw trace in ASCII
> 
> Note that this is not specific to pref sched. If I use perf record directly,
> I run into the same issue:
> $ perf record -R -a -c 1 -e sched:sched_switch -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.365 MB perf.data (~15962 samples) ]
> $./perf report -D
>   Fatal: no trace data in the file
> 
> Now that perf trace is gone, how to I dump the trace?

Good question, checking this s/trace/script/g fallout.

- Arnaldo
