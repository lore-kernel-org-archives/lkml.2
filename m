Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1BJTkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:40:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1BJTky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:40:54 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/1] perf tools: Fix thread_map event synthesizing in top and record
References: <1297363899-21466-1-git-send-email-acme@infradead.org>
	<1297363899-21466-2-git-send-email-acme@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 10 Feb 2011 14:40:29 -0500
In-Reply-To: <1297363899-21466-2-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Thu, 10 Feb 2011 16:51:39 -0200")
Message-ID: <x49aai38yqa.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@infradead.org> writes:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Jeff Moyer reported these messages:
>
>   Warning:  ... trying to fall back to cpu-clock-ticks
>
> couldn't open /proc/-1/status
> couldn't open /proc/-1/maps
> [ls output]
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.008 MB perf.data (~363 samples) ]
>
> That lead me and David Ahern to see that something was fishy on the thread
> synthesizing routines, at least for the case where the workload is started
> from 'perf record', as -1 is the default for target_tid in 'perf record --tid'
> parameter, so somehow we were trying to synthesize the PERF_RECORD_MMAP and
> PERF_RECORD_COMM events for the thread -1, a bug.
>
> So I investigated this and noticed that when we introduced support for
> recording a process and its threads using --pid some bugs were introduced and
> that the way to fix it was to instead of passing the target_tid to the event
> synthesizing routines we should better pass the thread_map that has the list of
> threads for a --pid or just the single thread for a --tid.

Thanks for looking into this, acme.  Honestly, I can't for the life of
me figure out from your description how this problem would have affected
systems.  The fix makes the warnings go away, but I am still left with
the hung system I originally reported.

So, what does this patch actually fix?  And do you or others have any
interest in trying to work out why perf is hanging my system?

Thanks!
Jeff
