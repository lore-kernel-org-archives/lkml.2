Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2IQPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2IQPXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:23:34 -0400
Date: Mon, 17 Sep 2012 12:23:01 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] perf ui/browser: Integrate script browser into
 annotation browser
Message-ID: <20120917152301.GB16820@infradead.org>
References: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
 <1347007349-3102-7-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347007349-3102-7-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 07, 2012 at 04:42:28PM +0800, Feng Tang escreveu:
> Integrate the script browser into annotation, users can press function
> key 'r' to list all perf scripts and select one of them to run that
> script, the output will be shown in a separate browser.

I think this needs a bit more work... i.e. I tried it with your script,
event_analyzing_sample and I kinda get meaningful output when pressing
'r' + that script from the top and hists browser.

But with other scripts, and you filtered the -top suffixed ones, that
require special handling, I get things like "Press Control+C to get a
summary", and when I press that, the browser exits, going back to
annotate or report/top browser.

I.e. this only works if we are processing a perf.data file made
specially for that specific script, right? I.e. the record phase is not
integrated at all, just running specific scripts in specific perf.data
files.

How to allow the user to chose appropriate scripts to run each perf.data
file is an aspect of usability that is missing...

Can you ellaborate on the assumptions you made while working on this, do
they match what I described above as how to use this scripts browser?

So I merged part of this patchset, but will wait till more discussion
happens on the browsing part,

Thanks,

- Arnaldo
 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  tools/perf/ui/browsers/annotate.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
> index 67a2703..13ac54c 100644
> --- a/tools/perf/ui/browsers/annotate.c
> +++ b/tools/perf/ui/browsers/annotate.c
> @@ -675,8 +675,14 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
>  		"o             Toggle disassembler output/simplified view\n"
>  		"s             Toggle source code view\n"
>  		"/             Search string\n"
> +		"r             Run available scripts\n"
>  		"?             Search previous string\n");
>  			continue;
> +		case 'r':
> +			{
> +				script_browse(NULL);
> +				continue;
> +			}
>  		case 'H':
>  			nd = browser->curr_hot;
>  			break;
> -- 
> 1.7.1
