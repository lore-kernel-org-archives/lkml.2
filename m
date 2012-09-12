Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab2ILR2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:28:19 -0400
Received: from [216.32.181.181] ([216.32.181.181]:10944 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab2ILR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:28:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MA8Z4L-02-2TS-02
X-M-MSG: 
Date: Wed, 12 Sep 2012 19:26:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: <mingo@kernel.org>, <hpa@zytor.com>, <paulus@samba.org>,
        <linux-kernel@vger.kernel.org>, <acme@redhat.com>,
        <a.p.zijlstra@chello.nl>, <namhyung.kim@lge.com>, <tglx@linutronix.de>,
        <namhyung@kernel.org>, <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf hists: Introduce perf_hpp for hist period
 printing
Message-ID: <20120912172641.GB29278@erda.amd.com>
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
 <tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.12 01:54:39, tip-bot for Namhyung Kim wrote:
> Commit-ID:  ea251d51d2c7d7233790123227f787c477f567f5
> Gitweb:     http://git.kernel.org/tip/ea251d51d2c7d7233790123227f787c477f567f5
> Author:     Namhyung Kim <namhyung.kim@lge.com>
> AuthorDate: Mon, 3 Sep 2012 11:53:06 +0900
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Sat, 8 Sep 2012 13:19:44 -0300
> 
> perf hists: Introduce perf_hpp for hist period printing
> 
> Current hist print functions are messy because it has to consider many
> of command line options and the code doing that is scattered around to
> places. So when someone wants to add an option to manipulate the hist
> output it'd very easy to miss to update all of them in sync. And things
> getting worse as more options/features are added continuously.
> 
> So I'd like to refactor them using hpp formats and move common code to
> ui/hist.c in order to make it easy to maintain and to add new features.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1346640790-17197-2-git-send-email-namhyung@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Makefile        |    2 +
>  tools/perf/builtin-diff.c  |    1 +
>  tools/perf/ui/hist.c       |  340 ++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/ui/setup.c      |    8 +-
>  tools/perf/ui/stdio/hist.c |  238 ++++++-------------------------
>  tools/perf/util/hist.h     |   37 +++++
>  6 files changed, 426 insertions(+), 200 deletions(-)

This patch breaks perf-record/report that the number of samples can't
be shown in pipe mode:

 # perf record -e cycles -aq sleep 1 ; perf report -n --sort comm,dso | sed '/%/q;d' ; \
   perf record -e cycles -aq sleep 1 | perf report -n --sort comm,dso | sed '/%/q;d'
     99.86%        11804       swapper  [kernel.kallsyms]
     91.57%      swapper  [kernel.kallsyms]
           ^^^^^^
           number of samples missing

Moving and changing the code at the same time make the patch
unreviewable. So no clue that's the problem here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

