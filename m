Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2CIJs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:48:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2CIJsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:48:24 -0500
Date: Fri, 9 Mar 2012 10:48:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, acme@redhat.com,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: Re: [PATCH 0/4] perf tools: improve branch stack sampling
Message-ID: <20120309094804.GA1781@elte.hu>
References: <1331246868-19905-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331246868-19905-1-git-send-email-eranian@google.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> This patch set improves upon my LBR v6 patch series posted on
> LKML several weeks ago. It needs to be applied on top of it.
> 
> This series improves perf report and perf record when used
> with taken branch stack sampling.
> 
> For perf record, and based on users' feedback, it is possible
> to omit the branch type with the -b option. In that case,
> the filter is set to the default value of any branch type.
> The branch-filter option is now used to specify more precise
> branch types and privilege levels:
> 
>    $ perf record -b foo
>    equivalent to:
>    $ perf record --branch-filter any foo
> 
>    To filter on specific branch types:
>    $ perf record --branch-filter any_call foo
> 
> For perf report, it is now possible to omit the -b option
> and yet get branch view mode. Perf report is able to auto-detect
> if the perf.data file contains samples with branch stack and
> to switch to the branch mode. It is possible to override this
> by passing --no-branch-stack.
> 
> Furthermore, perf report now supports TUI in branch mode.
> It is possible to naviguate to both the source and destination
> functions of branches.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> Stephane Eranian (4):
>   perf record: provide default branch stack sampling mode option
>   perf record: add HEADER_BRANCH_STACK tag
>   perf report: auto-detect branch stack sampling mode
>   perf report: enable TUI in branch view mode
> 
>  tools/perf/Documentation/perf-record.txt |   23 ++++--
>  tools/perf/Documentation/perf-report.txt |    7 +-
>  tools/perf/builtin-record.c              |   71 +++++++++++------
>  tools/perf/builtin-report.c              |  121 ++++++++++++++++++++---------
>  tools/perf/util/header.c                 |   13 +++
>  tools/perf/util/header.h                 |    2 +-
>  tools/perf/util/session.c                |    1 +
>  tools/perf/util/sort.c                   |    2 +-
>  tools/perf/util/sort.h                   |    8 +-
>  tools/perf/util/symbol.h                 |    7 ++-
>  tools/perf/util/ui/browsers/hists.c      |   62 ++++++++++++---
>  11 files changed, 225 insertions(+), 92 deletions(-)

Ok, I tried it out and this is now very usable. I particularly 
liked the detail how the TUI now allows annotation of both the 
source and the target symbols.

I've noticed two small usability glitches:

1) when annotating a symbol and typing 'q' to go back one level, 
   it goes back *two* levels. This is intuitive when just one 
   symbol is annotated, but confusing when there are two 
   symbols: I frequently want to go back to annotate the other 
   symbol as well.

2) two symbols are offered for annotation even when the source
   RIP and target RIP is within the same symbol.

Anyway, I've applied all your patches to 
tip:perf/hw-branch-sampling branch, and if the remaining issues 
are resolved will merge them into tip:perf/core for upstream 
merging. Depending on when the fixes arrive this could be v3.4 
or v3.5.

Thanks,

	Ingo
