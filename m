Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2IHOFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:05:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43338 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2IHOFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:05:51 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 4/5] perf ui/browser: Use perf_hpp__format functions
References: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
	<1346640790-17197-5-git-send-email-namhyung@kernel.org>
	<20120908003218.GC20401@ghostprotocols.net>
Date: Sat, 08 Sep 2012 23:05:43 +0900
In-Reply-To: <20120908003218.GC20401@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Fri, 7 Sep 2012 17:32:18 -0700")
Message-ID: <87ehmca9u0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2012 17:32:18 -0700, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 03, 2012 at 11:53:09AM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Override hpp->color functions for TUI. Because line coloring is done
>> outside of the function, it just sets the percent value and pass it.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/ui/browsers/hists.c | 94 ++++++++++++++++++++++++++++++++----------
>>  tools/perf/ui/tui/setup.c      |  4 ++
>>  2 files changed, 76 insertions(+), 22 deletions(-)
>> 
>> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
>> index 81bd8c2af730..144d7be2872e 100644
>> --- a/tools/perf/ui/browsers/hists.c
>> +++ b/tools/perf/ui/browsers/hists.c
>> @@ -28,6 +28,8 @@ struct hist_browser {
>>  	bool		     has_symbols;
>>  };
>>  
>> +extern void hist_browser__init_hpp(void);
>
> I folded the patch below so that we have the lines starting at column 1
> like before, i.e. we were using " %5.2f" for the overhead and now you
> changed it to "%5.2f".

Looks good to me.

Thanks,
Namhyung

>
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 144d7be..5a5739b 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -605,7 +605,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  	char s[256];
>  	double percent;
>  	int i, printed = 0;
> -	int width = browser->b.width;
> +	int width = browser->b.width - 1;
>  	char folded_sign = ' ';
>  	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
>  	off_t row_offset = entry->row_offset;
> @@ -627,7 +627,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  			.total_period	= browser->hists->stats.total_period,
>  		};
>  
> -		ui_browser__gotorc(&browser->b, row, 0);
> +		ui_browser__gotorc(&browser->b, row, 1);
>  
>  		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
>  			if (!perf_hpp__format[i].cond)
