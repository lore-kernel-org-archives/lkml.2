Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0LFCYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:24:08 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44049 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0LFCYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:24:06 -0500
X-AuditID: b753bd60-a55a3ba000003e7d-1f-4cfc49434259
Message-ID: <4CFC493D.6010605@hitachi.com>
Date: Mon, 06 Dec 2010 11:23:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  1/7] perf: add OPT_CALLBACK_DEFAULT_NOOPT
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203035853.7827.17502.stgit@localhost6.localdomain6>
In-Reply-To: <20101203035853.7827.17502.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 12:58), Akihiro Nagai wrote:
> Add new macro OPT_CALLBACK_DEFAULT_NOOPT for parse_options.
> It enables to pass the default value (opt->defval) to the callback function
> processing options require no argument.
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

This could be useful for perf probe too. :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/util/parse-options.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
> index c7d72dc..abc31a1 100644
> --- a/tools/perf/util/parse-options.h
> +++ b/tools/perf/util/parse-options.h
> @@ -119,6 +119,10 @@ struct option {
>  	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
>  #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
>  	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
> +#define OPT_CALLBACK_DEFAULT_NOOPT(s, l, v, a, h, f, d) \
> +	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),\
> +	.value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d,\
> +	.flags = PARSE_OPT_LASTARG_DEFAULT | PARSE_OPT_NOARG}
>  
>  /* parse_options() will filter out the processed options and leave the
>   * non-option argments in argv[].
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
