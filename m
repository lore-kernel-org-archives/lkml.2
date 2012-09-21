Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2IUAd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:33:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42809 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2IUAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:33:25 -0400
X-AuditID: 9c930197-b7b6dae000000e70-3d-505bb5d2079a
From: Namhyung Kim <namhyung@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: Fix parallel build
References: <505BAC5D.9020909@redhat.com>
Date: Fri, 21 Sep 2012 09:24:42 +0900
In-Reply-To: <505BAC5D.9020909@redhat.com> (Eric Sandeen's message of "Thu, 20
	Sep 2012 18:53:01 -0500")
Message-ID: <877groz0hh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, 20 Sep 2012 18:53:01 -0500, Eric Sandeen wrote:
> Parallel builds of perf were failing for me on a 32p box, with:
>
>     * new build flags or prefix
> util/pmu.l:7:23: error: pmu-bison.h: No such file or directory
>
> ...
>
> make: *** [util/pmu-flex.o] Error 1
> make: *** Waiting for unfinished jobs....
>
> This can pretty quickly be seen by adding a sleep in front of
> the bison call in tools/perf/Makefile and running make -j4 on a
> smaller box:
>
> 	sleep 10; $(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
>
> Adding the following dependency fixes it for me:
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index bad726a..6c389d9 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -219,7 +219,7 @@ $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
>  $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
>  	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
>  
> -$(OUTPUT)util/pmu-flex.c: util/pmu.l
> +$(OUTPUT)util/pmu-flex.c: util/pmu.l util/pmu-bison.c
>  	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
>  
>  $(OUTPUT)util/pmu-bison.c: util/pmu.y

I guess the $(OUTPUT)util/parse-events-flex.c: line has the same
problem.  Could you check and submit a patch for that too?

Thanks,
Namhyung
