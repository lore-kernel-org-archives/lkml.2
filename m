Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2CaHbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:31:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49515 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2CaHbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:31:35 -0400
Date: Sat, 31 Mar 2012 09:31:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Sorin Dumitru <dumitru.sorin87@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/9] perf/urgent fixes
Message-ID: <20120331073129.GA15958@gmail.com>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling.
> 
> 	But please test the bison/flex thing, it was a bit tricky to make it
> work with/without O=, and also to make it work on at least RHEL6.2, Fedora 14
> and Ubuntu 10.04 LTS.
> 
> 	I know that bison barfs on Fedora 8, but left the fix for later.
> 
> - Arnaldo
> 
> The following changes since commit b01c3a0010aabadf745f3e7fdb9cab682e0a28a2:
> 
>   perf: Move mmap page data_head offset assertion out of header (2012-03-24 08:46:59 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent
> 
> for you to fetch changes up to 65f3e56e0c81d1f581c4bdef7646ae5a8d51f494:
> 
>   perf tools: Remove auto-generated bison/flex files (2012-03-30 12:43:17 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent Fixes
> 
> . Assorted fixes from David Miller
> 
> . Fix display of first level of callchains, from Frederic Weisbecker
> 
> . Remove auto-generated bison/flex files, from Ingo Molnar and me
> 
> . Add missing ref-cycles event back to event parser, from Namhyung Kim
> 
> . Ignore DWARF decl tags to properly resolve function name do address,
>   from Prashanth Nageshappa
> 
> . Fix bug in raw sample parsing bug introduced in the branch stack patches,
>   from Stephane Eranian
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf annotate: Fix off by one symbol hist size allocation and hit accounting
> 
> David Miller (3):
>       perf symbols: Do not include libgen.h
>       perf symbols: Handle NULL dso in dso__name_len
>       perf annotate: addr2line wants addresses in same format as objdump
> 
> Frederic Weisbecker (1):
>       perf tools: Fix display of first level of callchains
> 
> Ingo Molnar (1):
>       perf tools: Remove auto-generated bison/flex files
> 
> Namhyung Kim (1):
>       perf tools: Add missing ref-cycles event back to event parser
> 
> Prashanth Nageshappa (1):
>       perf probe: Finder fails to resolve function name to address
> 
> Stephane Eranian (1):
>       perf tools: Fix bug in raw sample parsing
> 
>  tools/perf/Makefile                  |   47 +-
>  tools/perf/util/annotate.c           |    8 +-
>  tools/perf/util/evsel.c              |    2 +
>  tools/perf/util/hist.c               |  157 ++-
>  tools/perf/util/parse-events-bison.c | 1917 ----------------------------
>  tools/perf/util/parse-events-bison.h |   81 --
>  tools/perf/util/parse-events-flex.c  | 2272 ----------------------------------
>  tools/perf/util/parse-events-flex.h  |  316 -----
>  tools/perf/util/parse-events.l       |    1 +
>  tools/perf/util/pmu-bison.c          | 1663 -------------------------
>  tools/perf/util/pmu-bison.h          |   73 --
>  tools/perf/util/pmu-flex.c           | 1821 ---------------------------
>  tools/perf/util/pmu-flex.h           |  316 -----
>  tools/perf/util/probe-finder.c       |    4 +-
>  tools/perf/util/symbol.c             |    3 +-
>  15 files changed, 135 insertions(+), 8546 deletions(-)
>  delete mode 100644 tools/perf/util/parse-events-bison.c
>  delete mode 100644 tools/perf/util/parse-events-bison.h
>  delete mode 100644 tools/perf/util/parse-events-flex.c
>  delete mode 100644 tools/perf/util/parse-events-flex.h
>  delete mode 100644 tools/perf/util/pmu-bison.c
>  delete mode 100644 tools/perf/util/pmu-bison.h
>  delete mode 100644 tools/perf/util/pmu-flex.c
>  delete mode 100644 tools/perf/util/pmu-flex.h

Pulled, thanks a lot Arnaldo!

It's working fine on all my test-boxes.

Thanks,

	Ingo
