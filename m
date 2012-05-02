Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2ECO0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:26:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40353 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2ECO0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:26:02 -0400
Date: Wed, 2 May 2012 16:12:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: Fix Makefile to clean auto-generated
 bison/flex files properly
Message-ID: <20120502191205.GG5745@infradead.org>
References: <1327744256-10786-1-git-send-email-js1304@gmail.com>
 <1336036107-12334-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336036107-12334-1-git-send-email-js1304@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 03, 2012 at 02:08:27AM -0700, Joonsoo Kim escreveu:
> The commit 65f3e56e0c81 ("perf tools: Remove auto-generated bison/flex
> files") removed those files from git and modified Makefile to clean
> auto-generated bison/flex files. But, in Makefile, regular expression
> "*-{bison,flex}*" doesn't work. Fix it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 9bf3fc7..295c477 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -987,7 +987,7 @@ clean:
>  	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
>  	$(MAKE) -C Documentation/ clean
>  	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
> -	$(RM) $(OUTPUT)util/*-{bison,flex}*
> +	$(RM) $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
>  	$(python-clean)

Are you sure?

[acme@sandy perf]$ make -j8 > /dev/null
PERF_VERSION = 3.4.rc2.45.g89290d
    * new build flags or prefix
[acme@sandy perf]$ ls -la util/*bison*
-rw-rw-r--. 1 acme acme  51448 May  2 16:10 util/parse-events-bison.c
-rw-rw-r--. 1 acme acme   2553 May  2 16:10 util/parse-events-bison.h
-rw-rw-r--. 1 acme acme 179488 May  2 16:10 util/parse-events-bison.o
-rw-rw-r--. 1 acme acme  12484 May  2 16:10 util/parse-events-bison.output
-rw-rw-r--. 1 acme acme  43849 May  2 16:10 util/pmu-bison.c
-rw-rw-r--. 1 acme acme   2313 May  2 16:10 util/pmu-bison.h
-rw-rw-r--. 1 acme acme  66064 May  2 16:10 util/pmu-bison.o
-rw-rw-r--. 1 acme acme   3416 May  2 16:10 util/pmu-bison.output
[acme@sandy perf]$ make clean > /dev/null
[acme@sandy perf]$ ls -la util/*bison*
ls: cannot access util/*bison*: No such file or directory
[acme@sandy perf]$

[acme@sandy perf]$ grep RM.*bison Makefile
	$(RM) $(OUTPUT)util/*-{bison,flex}*
[acme@sandy perf]$

[acme@sandy perf]$ make --version
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for x86_64-redhat-linux-gnu
[acme@sandy perf]$
