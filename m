Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2EHNKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:10:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49541 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2EHNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:10:39 -0400
Date: Tue, 8 May 2012 10:10:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com
Subject: Re: [PATCH] perf report: fix compile failure on ppc, 32-bit
Message-ID: <20120508131033.GF2485@infradead.org>
References: <1336442362-53217-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336442362-53217-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 07, 2012 at 07:59:22PM -0600, David Ahern escreveu:
> Builds currently fail with:
>     CC /tmp/pbuild/builtin-report.o
> cc1: warnings being treated as errors
> builtin-report.c: In function ‘hists__fprintf_nr_sample_events’:
> builtin-report.c:307: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘u64’
> make: *** [/tmp/pbuild/builtin-report.o] Error 1

Jiri sent this, I reproduced it yesterday on an Atom machine, will push
today, thanks,

- Arnaldo
 
> $ rpm -q gcc
> gcc-4.4.4-10.fc12.ppc
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-report.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 5df829f..7477655 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -304,7 +304,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
>  	if (evname != NULL)
>  		ret += fprintf(fp, " of event '%s'", evname);
>  
> -	ret += fprintf(fp, "\n# Event count (approx.): %lu", nr_events);
> +	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
>  	return ret + fprintf(fp, "\n#\n");
>  }
>  
> -- 
> 1.7.5.4
