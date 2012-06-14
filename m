Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2FNKHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:07:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51185 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2FNKHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:07:16 -0400
Date: Thu, 14 Jun 2012 12:07:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120614100710.GB19531@gmail.com>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339601367-17834-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 9ee6ddc9dada9cc4b2201631bc74fbf203183a10:
> 
>   Merge branch 'tip/perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent (2012-06-08 12:23:22 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to cb9dd49e11f83d548c822d7022ac180b0518b25c:
> 
>   perf tools: Fix synthesizing tracepoint names from the perf.data headers (2012-06-12 11:28:09 -0300)
> 
> ----------------------------------------------------------------
> Fixes for perf/urgent
> 
> . Set name of tracepoints when reading the perf.data headers, so that
>   we don't end up using the local ones, from /sys.
> 
> . Fix default output file for perf stat, from Stephane Eranian.
> 
> . Fix endian handling of features bitmask in perf.data header, from David Ahern
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf tools: Fix synthesizing tracepoint names from the perf.data headers
> 
> David Ahern (1):
>       perf tools: Fix endianity swapping for adds_features bitmask
> 
> Stephane Eranian (1):
>       perf stat: Fix default output file
> 
>  tools/perf/builtin-stat.c              |    8 +++++-
>  tools/perf/util/header.c               |   48 +++++++++++++++++++++++++++-----
>  tools/perf/util/include/linux/bitops.h |    2 ++
>  tools/perf/util/session.c              |   10 +++++++
>  tools/perf/util/session.h              |    1 +
>  5 files changed, 61 insertions(+), 8 deletions(-)

Hm, fails to build here:

    CC util/parse-events-bison.o
util/parse-events.l: In function ‘__value’:
util/parse-events.l:18:10: error: ‘PE_ERROR’ undeclared (first 
use in this function)
util/parse-events.l:18:10: note: each undeclared identifier is 
reported only once for each function it appears in
util/parse-events.l:20:2: error: ‘parse_events_lval’ undeclared 
(first use in this function)
util/parse-events.l: In function ‘value’:
util/parse-events.l:26:42: error: ‘PE_VALUE’ undeclared (first 
use in this function)
util/parse-events.l: In function ‘raw’:
util/parse-events.l:31:44: error: ‘PE_RAW’ undeclared (first use 
in this function)
util/parse-events.l: In function ‘str’:

stock Fedora 17 install. 25f42985825d builds fine.

Thanks,

	Ingo
