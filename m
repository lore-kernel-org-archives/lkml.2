Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1BJUAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:00:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:40368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1BJUAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:00:14 -0500
Date: Thu, 10 Feb 2011 18:00:00 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/1] perf tools: Fix thread_map event synthesizing in
	top and record
Message-ID: <20110210200000.GF20676@ghostprotocols.net>
References: <1297363899-21466-1-git-send-email-acme@infradead.org> <1297363899-21466-2-git-send-email-acme@infradead.org> <x49aai38yqa.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49aai38yqa.fsf@segfault.boston.devel.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 10, 2011 at 02:40:29PM -0500, Jeff Moyer escreveu:
> Arnaldo Carvalho de Melo <acme@infradead.org> writes:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Jeff Moyer reported these messages:
> >
> >   Warning:  ... trying to fall back to cpu-clock-ticks
> >
> > couldn't open /proc/-1/status
> > couldn't open /proc/-1/maps
> > [ls output]
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.008 MB perf.data (~363 samples) ]
> >
> > That lead me and David Ahern to see that something was fishy on the thread
> > synthesizing routines, at least for the case where the workload is started
> > from 'perf record', as -1 is the default for target_tid in 'perf record --tid'
> > parameter, so somehow we were trying to synthesize the PERF_RECORD_MMAP and
> > PERF_RECORD_COMM events for the thread -1, a bug.
> >
> > So I investigated this and noticed that when we introduced support for
> > recording a process and its threads using --pid some bugs were introduced and
> > that the way to fix it was to instead of passing the target_tid to the event
> > synthesizing routines we should better pass the thread_map that has the list of
> > threads for a --pid or just the single thread for a --tid.
> 
> Thanks for looking into this, acme.  Honestly, I can't for the life of
> me figure out from your description how this problem would have affected
> systems.  The fix makes the warnings go away, but I am still left with
> the hung system I originally reported.

I wasn't looking at that part, as described, I looked just at the
/proc/-1/status part, that -1. I.e. the part I hack on, the tools.
 
> So, what does this patch actually fix?  And do you or others have any
> interest in trying to work out why perf is hanging my system?

Peter?

- Arnaldo
