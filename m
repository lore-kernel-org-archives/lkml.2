Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab1LFNaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:30:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031Ab1LFNaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:30:13 -0500
Date: Tue, 6 Dec 2011 11:29:59 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] perf tools: Continue processing header on
	unknown features
Message-ID: <20111206132959.GH7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-4-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167560-2282-4-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:32:33AM +0100, Robert Richter escreveu:
> A feature may be unknown if perf.data is created and parsed on
> different perf tool versions. This should not stop the header to be
> processed, instead continue processing it.

Ok with me.
 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/util/header.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index bcd05d0..95c3ab1 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1105,7 +1105,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
>  	}
>  	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
>  		pr_warning("unknown feature %d\n", feat);
> -		return -1;
> +		return 0;
>  	}
>  	if (!feat_ops[feat].print)
>  		return 0;
> -- 
> 1.7.7
> 
