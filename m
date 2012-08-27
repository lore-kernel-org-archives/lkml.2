Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2H0Pe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2H0PeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:34:24 -0400
Date: Mon, 27 Aug 2012 12:33:55 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf tools: Fix a compiling error in
 trace-event-perl.c for 32 bits machine
Message-ID: <20120827153355.GA17634@infradead.org>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
 <1346053107-11946-2-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346053107-11946-2-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 27, 2012 at 03:38:25PM +0800, Feng Tang escreveu:
> On my x86_32 mahcine, there is a compile error:
> 
> 	CC util/scripting-engines/trace-event-perl.o
> 	cc1: warnings being treated as errors
> 	util/scripting-engines/trace-event-perl.c: In function ‘perl_process_tracepoint’:
> 	util/scripting-engines/trace-event-perl.c:285: error: format ‘%d’ expects type ‘int’, but argument 2 has type ‘__u64’
> 	make: *** [util/scripting-engines/trace-event-perl.o] Error 1
> 
> Fix it by using the "%lld" for __u64.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
> index d280010..1cde6aa 100644
> --- a/tools/perf/util/scripting-engines/trace-event-perl.c
> +++ b/tools/perf/util/scripting-engines/trace-event-perl.c
> @@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
>  
>  	event = find_cache_event(evsel);
>  	if (!event)
> -		die("ug! no event found for type %d", evsel->attr.config);
> +		die("ug! no event found for type %lld", evsel->attr.config);

Please use PRIu64 instead, like in:

grep PRIu64 tools/perf/*/*.c
  
>  	pid = raw_field_value(event, "common_pid", data);
>  
> -- 
> 1.7.1
