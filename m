Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2BIQeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:34:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59478 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2BIQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:34:49 -0500
Date: Thu, 9 Feb 2012 14:34:41 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 1/2] perf-tool: Don't process samples with no valid
 machine object
Message-ID: <20120209163441.GD2526@infradead.org>
References: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
 <1328803659-30449-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328803659-30449-2-git-send-email-joerg.roedel@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 09, 2012 at 05:07:38PM +0100, Joerg Roedel escreveu:
> The perf sample processing code relies on a valid machine
> object. Make sure that this path is only entered when such a
> object exists.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  tools/perf/builtin-top.c  |    2 +-
>  tools/perf/util/session.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index dd162aa..7c81d1d 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -805,7 +805,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
>  		}
>  
>  
> -		if (event->header.type == PERF_RECORD_SAMPLE) {
> +		if (event->header.type == PERF_RECORD_SAMPLE && machine != NULL) {

Shouldn't we warn the user, even if just once, on the status (last line
on the screen) line?

>  			perf_event__process_sample(&top->tool, event, evsel,
>  						   &sample, machine);
>  		} else if (event->header.type < PERF_RECORD_MAX) {
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index b5ca2558..c9593c7 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -792,7 +792,7 @@ static int perf_session_deliver_event(struct perf_session *session,
>  	switch (event->header.type) {
>  	case PERF_RECORD_SAMPLE:
>  		dump_sample(session, event, sample);
> -		if (evsel == NULL) {
> +		if (evsel == NULL || machine == NULL) {
>  			++session->hists.stats.nr_unknown_id;
>  			return -1;
>  		}
> -- 
> 1.7.5.4
> 
