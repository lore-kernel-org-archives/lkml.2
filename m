Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2LDNoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:44:17 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39088 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2LDNoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:44:16 -0500
Date: Tue, 4 Dec 2012 10:44:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121204134405.GA3159@ghostprotocols.net>
References: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
 <1354596265-9901-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354596265-9901-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 04, 2012 at 01:44:23PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When comparing entries for collapsing put the given entry first, and
> then the iterated entry.  This is not the case of hist_entry__cmp()
> when called if given sort keys don't require collapsing.  So change
> the order for the sake of consistency.  It will be required for
> matching and/or linking multiple hist entries.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/hist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 82df1b26f0d4..161c35e7ed0e 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -433,7 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
>  		parent = *p;
>  		iter = rb_entry(parent, struct hist_entry, rb_node_in);
>  
> -		cmp = hist_entry__collapse(iter, he);
> +		cmp = hist_entry__collapse(he, iter);
>  
>  		if (!cmp) {
>  			he_stat__add_stat(&iter->stat, &he->stat);

What about this he_stat__add_stat call? Now the hist_entry__collapse
receives (he, iter)  while this right next function call receives (iter,
he).

- Arnaldo

> -- 
> 1.7.11.7
