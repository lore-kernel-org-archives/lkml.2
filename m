Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2HEKlC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 06:41:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36153 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2HEKlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 06:41:00 -0400
Date: Sun, 5 Aug 2012 12:40:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Palmer Cox <p@lmercox.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/18] perf/core fixes and improvements
Message-ID: <20120805104054.GA10136@gmail.com>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 194f8dcbe9629d8e9346cf96345a9c0bbf0e67ae:
> 
>   uprobes: __replace_page() needs munlock_vma_page() (2012-07-30 11:27:25 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 7f309ed6453926a81e2a97d274f67f1e48f0d74c:
> 
>   perf tools: Remove brace expansion from clean target (2012-08-03 10:46:32 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Prep work for the DWARF CFI post unwinder, so that it doesn't
>   uses perf_session in lots of places, just evlist/evsel is enough.
> 
> . Make clean brace expansion fix for some shells, from Palmer Cox
> 
> . Warn user just once per guest kernel when not finding kernel info,
>   from David Ahern
> 
> . perf test fix from Jiri Olsa
> 
> . Fix error handling on event creation in perf top, from David Ahern
> 
> . Fix check on perf_target__strnerror, from Namhyung Kim
> 
> . Save the whole cmdline, from David Ahern
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (7):
>       perf evsel: Precalculate the sample size
>       perf session: Use perf_evlist__sample_type more extensively
>       perf session: Use perf_evlist__sample_id_all more extensively
>       perf session: Use perf_evlist__id_hdr_size more extensively
>       perf evlist: Introduce perf_evlist__parse_sample
>       perf evsel: Adopt parse_sample method from perf_event
>       perf session: Remove no longer used synthesize_sample method
> 
> David Ahern (7):
>       perf top: Error handling for counter creation should parallel perf-record
>       perf tool: Save cmdline from user in file header vs what is passed to record
>       perf kvm: Use strtol for walking guestmount directory
>       perf tools: Introducing rblist
>       perf tools: Change strlist to use the new rblist
>       perf tools: Introduce intlist
>       perf kvm top: Limit guest kernel info message to once
> 
> Jiri Olsa (2):
>       perf test: Fix parse events automated tests
>       perf symbols: Fix array sizes for binary types arrays
> 
> Namhyung Kim (1):
>       perf target: Fix check on buffer size
> 
> Palmer Cox (1):
>       perf tools: Remove brace expansion from clean target
> 
>  tools/perf/Makefile                 |    7 +-
>  tools/perf/builtin-record.c         |    4 +-
>  tools/perf/builtin-report.c         |    5 +-
>  tools/perf/builtin-test.c           |   19 ++---
>  tools/perf/builtin-top.c            |   23 +++++--
>  tools/perf/util/event.h             |    3 -
>  tools/perf/util/evlist.c            |    7 ++
>  tools/perf/util/evlist.h            |    3 +
>  tools/perf/util/evsel.c             |   15 ++--
>  tools/perf/util/evsel.h             |   10 +--
>  tools/perf/util/header.c            |    9 +++
>  tools/perf/util/intlist.c           |  101 +++++++++++++++++++++++++++
>  tools/perf/util/intlist.h           |   75 ++++++++++++++++++++
>  tools/perf/util/parse-events-test.c |   12 ++--
>  tools/perf/util/parse-options.c     |    3 +
>  tools/perf/util/python.c            |    6 +-
>  tools/perf/util/rblist.c            |  107 ++++++++++++++++++++++++++++
>  tools/perf/util/rblist.h            |   47 +++++++++++++
>  tools/perf/util/session.c           |   48 +++++++------
>  tools/perf/util/session.h           |   24 +------
>  tools/perf/util/strlist.c           |  130 ++++++++++++++---------------------
>  tools/perf/util/strlist.h           |   11 +--
>  tools/perf/util/symbol.c            |   14 +++-
>  tools/perf/util/target.c            |    2 +-
>  24 files changed, 498 insertions(+), 187 deletions(-)
>  create mode 100644 tools/perf/util/intlist.c
>  create mode 100644 tools/perf/util/intlist.h
>  create mode 100644 tools/perf/util/rblist.c
>  create mode 100644 tools/perf/util/rblist.h

Pulled, thanks Arnaldo!

	Ingo
