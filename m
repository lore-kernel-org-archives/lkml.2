Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2IYKp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:45:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34388 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2IYKpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:45:25 -0400
Date: Tue, 25 Sep 2012 03:45:19 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf test: Fix build failure
Message-ID: <20120925104519.GA14405@ghostprotocols.net>
References: <1348539628-3821-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348539628-3821-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 11:20:28AM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The commit 6a6cd11d4e57 ("perf test: Add test for the sched tracepoint
> format fields") added following build error:
> 
>   CC builtin-test.o
> builtin-test.c: In function ‘perf_evsel__test_field’:
> builtin-test.c:1216:6: error: variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
> builtin-test.c: In function ‘perf_evsel__tp_sched_test’:
> builtin-test.c:1242:6: error: variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
> cc1: all warnings being treated as errors
> make: *** [builtin-test.o] Error 1


Interesting :-\

[acme@sandy linux]$ gcc --version
gcc (GCC) 4.4.6 20120305 (Red Hat 4.4.6-4)

Didn't catch this one...

Thanks,

- Arnaldo

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 32caf13cfe01..78b47a75a7c9 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -1233,7 +1233,7 @@ static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
>  		ret = -1;
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int perf_evsel__tp_sched_test(void)
> @@ -1286,7 +1286,7 @@ static int perf_evsel__tp_sched_test(void)
>  	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
>  		ret = -1;
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static struct test {
> -- 
> 1.7.11.4
