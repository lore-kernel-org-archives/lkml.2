Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1LFOCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:02:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57188 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab1LFOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:02:51 -0500
Date: Tue, 6 Dec 2011 12:02:43 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, asharma@fb.com, devel@openvz.org, dsahern@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/7] perf: use event_name() to get an event name
Message-ID: <20111206140243.GD10709@infradead.org>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
 <1322471015-107825-2-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322471015-107825-2-git-send-email-avagin@openvz.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 28, 2011 at 12:03:29PM +0300, Andrew Vagin escreveu:
> perf_evsel.name may be not initialized

I'm applying this one to my perf/urgent branch and will ask Ingo to
merge it today.
 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  tools/perf/util/header.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index bcd05d0..33c17a2 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -388,7 +388,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
>  		/*
>  		 * write event string as passed on cmdline
>  		 */
> -		ret = do_write_string(fd, attr->name);
> +		ret = do_write_string(fd, event_name(attr));
>  		if (ret < 0)
>  			return ret;
>  		/*
> -- 
> 1.7.1
