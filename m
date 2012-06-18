Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2FRJFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:05:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60986 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2FRJFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:05:07 -0400
Date: Mon, 18 Jun 2012 11:05:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix an error on perf-bench document
Message-ID: <20120618090501.GB28824@gmail.com>
References: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> The pipe should be messaging.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Documentation/perf-bench.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
> index a3dbadb26ef5..d53d22f0c6ee 100644
> --- a/tools/perf/Documentation/perf-bench.txt
> +++ b/tools/perf/Documentation/perf-bench.txt
> @@ -51,8 +51,8 @@ SUITES FOR 'sched'
>  Suite for evaluating performance of scheduler and IPC mechanisms.
>  Based on hackbench by Rusty Russell.
>  
> -Options of *pipe*
> -^^^^^^^^^^^^^^^^^
> +Options of *messaging*
> +^^^^^^^^^^^^^^^^^^^^^^
>  -p::
>  --pipe::
>  Use pipe() instead of socketpair()
> -- 

There's several typos all across the perf bench documentation:

1)

       This perf bench command is general framework for benchmark suites.

s/is general/is a general

2)

The output of 'perf bench --help' outputs weird looking 
formatting characters like:

           .ft C
           % perf bench sched pipe                      # with no style specified
           (executing 1000000 pipe operations between two tasks)
                   Total time:5.855 sec
                           5.855061 usecs/op
                           170792 ops/sec
           .ft

3)

This:

           all: test all suite (pseudo suite)

s/all suite (psudo suite)/all benchmark suites

(this should be fixed for perf bench mem as well.)

4)

perf bench mem memcpy -h outputs:

    -l, --length <1MB>    Specify length of memory to copy. available unit: B, MB, GB (upper and lower)

bad capitalization: s/. a/. A

s/unit/units

5)

This:

    -c, --clock           Use CPU clock for measuring

should probably clarify why the CPU clock matters and what 
measurement is done otherwise.

Thanks,

	Ingo
