Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab1LFNUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:20:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031Ab1LFNUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:20:48 -0500
Date: Tue, 6 Dec 2011 11:20:32 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] perf tools: Fix out-of-bound access to struct
	perf_session
Message-ID: <20111206132032.GD7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-5-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167560-2282-5-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:32:34AM +0100, Robert Richter escreveu:
> If filename is NULL there is an out-of-bound access to struct
> perf_session if it would be used with perf_session__open(). Shouldn't
> actually happen in current implementation as filename is always
> !NULL. Fixing this by always null-terminating filename.

Interesting, defensive programing, ok.
 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/util/session.c |    2 +-
>  tools/perf/util/session.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 85c1e6b7..2ad9c10 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -132,7 +132,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
>  				       bool force, bool repipe,
>  				       struct perf_event_ops *ops)
>  {
> -	size_t len = filename ? strlen(filename) + 1 : 0;
> +	size_t len = filename ? strlen(filename) : 0;
>  	struct perf_session *self = zalloc(sizeof(*self) + len);
>  
>  	if (self == NULL)
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 6e393c9..f320cd5 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -54,7 +54,7 @@ struct perf_session {
>  	char			*cwd;
>  	struct ordered_samples	ordered_samples;
>  	struct callchain_cursor	callchain_cursor;
> -	char			filename[0];
> +	char			filename[1];
>  };
>  
>  struct perf_evsel;
> -- 
> 1.7.7
> 
