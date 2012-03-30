Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab2C3Qn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:43:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38801 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab2C3QnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:43:22 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 9/9] perf tools: Remove auto-generated bison/flex files
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
	<1333123764-15662-10-git-send-email-acme@infradead.org>
Date: Sat, 31 Mar 2012 01:43:13 +0900
In-Reply-To: <1333123764-15662-10-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Fri, 30 Mar 2012 13:09:24 -0300")
Message-ID: <87iphmm44e.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> From: Ingo Molnar <mingo@kernel.org>
>
> These should not be in the Git history - they are auto-generated.
>
> Extend the Makefile rules of the parser files to include the generation
> run.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/20120327183335.GA27621@gmail.com
> [ committer note: Fixed up O= handling ]
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Makefile                  |   47 +-
>  tools/perf/util/parse-events-bison.c | 1917 ----------------------------
>  tools/perf/util/parse-events-bison.h |   81 --
>  tools/perf/util/parse-events-flex.c  | 2272 ----------------------------------
>  tools/perf/util/parse-events-flex.h  |  316 -----
>  tools/perf/util/pmu-bison.c          | 1663 -------------------------
>  tools/perf/util/pmu-bison.h          |   73 --
>  tools/perf/util/pmu-flex.c           | 1821 ---------------------------
>  tools/perf/util/pmu-flex.h           |  316 -----
>  9 files changed, 30 insertions(+), 8476 deletions(-)
>  delete mode 100644 tools/perf/util/parse-events-bison.c
>  delete mode 100644 tools/perf/util/parse-events-bison.h
>  delete mode 100644 tools/perf/util/parse-events-flex.c
>  delete mode 100644 tools/perf/util/parse-events-flex.h
>  delete mode 100644 tools/perf/util/pmu-bison.c
>  delete mode 100644 tools/perf/util/pmu-bison.h
>  delete mode 100644 tools/perf/util/pmu-flex.c
>  delete mode 100644 tools/perf/util/pmu-flex.h
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index b492e3a..3e61c6f 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -61,8 +61,6 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  
>  CC = $(CROSS_COMPILE)gcc
>  AR = $(CROSS_COMPILE)ar
> -FLEX = $(CROSS_COMPILE)flex
> -BISON= $(CROSS_COMPILE)bison
>  
>  # Additional ARCH settings for x86
>  ifeq ($(ARCH),i386)
> @@ -184,7 +182,7 @@ endif
>  
>  ### --- END CONFIGURATION SECTION ---
>  
> -BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> +BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
>  BASIC_LDFLAGS =
>  
>  # Guard against environment variables
> @@ -236,6 +234,25 @@ endif
>  
>  export PERL_PATH
>  
> +FLEX = $(CROSS_COMPILE)flex
> +BISON= $(CROSS_COMPILE)bison

Just out of curiousity, is this $(CROSS_COMPILE) prefix really needed
for flex/bison?

Thanks,
Namhyung

