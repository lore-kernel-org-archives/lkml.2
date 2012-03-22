Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2CVP2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:28:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47155 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab2CVP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:28:38 -0400
Date: Thu, 22 Mar 2012 12:28:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: Fix ordering with unstable tsc
Message-ID: <20120322152832.GE25820@infradead.org>
References: <20120206132546.GA30854@quad>
 <1329583837-7469-1-git-send-email-fweisbec@gmail.com>
 <20120314195535.GB13246@infradead.org>
 <20120322001028.GA7024@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322001028.GA7024@somewhere.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 22, 2012 at 01:10:31AM +0100, Frederic Weisbecker escreveu:
> On Wed, Mar 14, 2012 at 04:55:35PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Sat, Feb 18, 2012 at 05:50:37PM +0100, Frederic Weisbecker escreveu:
> > > +static int alloc_cpus_timestamp_array(struct perf_session *s,
> > > +	if (sample->cpu < s->nr_cpus)

> > Shouldn't we try to robustify this checking against HEADER_NRCPUS (if
> > present)?

> Yeah I thought about that too. I can try to make that working.
> I just thought this was an optimization that I could later add (ie: first
> try to see if the core idea of the patch is accepted).

Right, I deferred that to tglx, but he must be busy as always :-P
 
> Of course the real long term optimization is going to have one file per
> CPU. There, the ordering will be much easier and deterministically
> correct.

Yeah.
 
> > > +		os->last_cpu_timestamp = realloc(os->last_cpu_timestamp,
> > > +						 sizeof(u64) * nr_cpus);
> > If realloc fails we return -ENOMEM, but leak the old buffer.

> Doh! the common trap with realloc...

:-)

> > At some point we can have in the TUI/GUI a way for the user to ask for
> > an specific perf.data file to be processed, if it fails to process due
> > to the above realloc, we'll continue, allowing other perf.data files to
> > be processed, but will have this leak.

> Ok. Will fix.

Thanks!

- Arnaldo
