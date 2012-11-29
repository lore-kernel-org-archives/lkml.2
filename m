Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2K3QJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:09:57 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47390 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2K3QJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:09:55 -0500
Date: Thu, 29 Nov 2012 15:52:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/18] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121129185257.GC1957@ghostprotocols.net>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354171126-14387-9-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 29, 2012 at 03:38:35PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When comparing entries for collapsing put the given entry first, and
> then the iterated entry.  This is for the sake of consistency and will

consistency with what? and, see below:

> be required by the event group report.
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

doesn't this now gets inconsistent with the hist_entry__collapse() call?
I.e. iter first, he after, also there is the case for callchains, below,
care to elaborate here?

> -- 
> 1.7.11.7
