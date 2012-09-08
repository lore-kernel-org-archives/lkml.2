Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2IHAya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:54:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56595 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab2IHAy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:54:28 -0400
Date: Fri, 7 Sep 2012 17:32:18 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 4/5] perf ui/browser: Use perf_hpp__format functions
Message-ID: <20120908003218.GC20401@ghostprotocols.net>
References: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
 <1346640790-17197-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346640790-17197-5-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 03, 2012 at 11:53:09AM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Override hpp->color functions for TUI. Because line coloring is done
> outside of the function, it just sets the percent value and pass it.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 94 ++++++++++++++++++++++++++++++++----------
>  tools/perf/ui/tui/setup.c      |  4 ++
>  2 files changed, 76 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 81bd8c2af730..144d7be2872e 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -28,6 +28,8 @@ struct hist_browser {
>  	bool		     has_symbols;
>  };
>  
> +extern void hist_browser__init_hpp(void);

I folded the patch below so that we have the lines starting at column 1
like before, i.e. we were using " %5.2f" for the overhead and now you
changed it to "%5.2f".

- Arnaldo

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 144d7be..5a5739b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -605,7 +605,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	char s[256];
 	double percent;
 	int i, printed = 0;
-	int width = browser->b.width;
+	int width = browser->b.width - 1;
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
@@ -627,7 +627,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.total_period	= browser->hists->stats.total_period,
 		};
 
-		ui_browser__gotorc(&browser->b, row, 0);
+		ui_browser__gotorc(&browser->b, row, 1);
 
 		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
 			if (!perf_hpp__format[i].cond)
