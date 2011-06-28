Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1F1OR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:17:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37206 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab1F1OP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:15:57 -0400
Message-ID: <4E09E21A.8060202@gmail.com>
Date: Tue, 28 Jun 2011 08:15:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip 10/13] [RESEND]perf probe: Warn when more than two
 lines are given
References: <20110627072626.6528.41792.stgit@fedora15> <20110627072733.6528.82721.stgit@fedora15>
In-Reply-To: <20110627072733.6528.82721.stgit@fedora15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/27/2011 01:27 AM, Masami Hiramatsu wrote:
> Print warning which warns only the last specified --line option is valid.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
> 
>  tools/perf/builtin-probe.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 2c0e64d..4f3460a 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -134,10 +134,15 @@ static int opt_show_lines(const struct option *opt __used,
>  {
>  	int ret = 0;
>  
> -	if (str)
> -		ret = parse_line_range_desc(str, &params.line_range);
> -	INIT_LIST_HEAD(&params.line_range.line_list);
> +	if (!str)
> +		return 0;
> +
> +	if (params.show_lines)
> +		pr_warning("Warning: more than two --line option are"
> +			   " detected. Only last option is valid.\n");

This detects a second --line option, but your warning suggests two
--line options are ok. Should that warning be "more than one --line
option is"

David

>  	params.show_lines = true;
> +	ret = parse_line_range_desc(str, &params.line_range);
> +	INIT_LIST_HEAD(&params.line_range.line_list);
>  
>  	return ret;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
