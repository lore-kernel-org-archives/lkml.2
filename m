Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0LFDUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:20:52 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53245 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab0LFDUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:20:50 -0500
X-AuditID: b753bd60-a30f9ba000000f8d-20-4cfc5690ff2b
Message-ID: <4CFC568B.4090102@hitachi.com>
Date: Mon, 06 Dec 2010 12:20:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  7/7] perf bts trace: add print all option
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203040022.7827.53037.stgit@localhost6.localdomain6>
In-Reply-To: <20101203040022.7827.53037.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 13:00), Akihiro Nagai wrote:
> For ease of use, add option printing all information '-A' or '--all'.
> This option can print following information.
>   - pid
>   - command name
>   - address
>   - function+offset
>   - elf file path
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

Looks good to me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/Documentation/perf-bts.txt |    3 +++
>  tools/perf/builtin-bts.c              |    6 ++++++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
> index 13ee862..c598dd2 100644
> --- a/tools/perf/Documentation/perf-bts.txt
> +++ b/tools/perf/Documentation/perf-bts.txt
> @@ -44,6 +44,9 @@ OPTIONS
>  -s::
>  --symbol::
>  	Print function name and offset. (default)
> +-A::
> +--all::
> +	Print all information.
>  
>  SEE ALSO
>  --------
> diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
> index 71c7fbe..c359f70 100644
> --- a/tools/perf/builtin-bts.c
> +++ b/tools/perf/builtin-bts.c
> @@ -34,6 +34,9 @@ struct exec_info {
>  #define EI_FLAG_PRINT_ELFPATH		(1 << 3)
>  #define EI_FLAG_PRINT_SYMBOL		(1 << 4)
>  
> +/* all print flags are enabled */
> +#define	 EI_FLAG_PRINT_ALL		-1UL
> +
>  /* it's used when no print item specified */
>  #define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_SYMBOL
>  
> @@ -92,6 +95,9 @@ static const struct option bts_options[] = {
>  				   "print function+offset (default)",
>  				   set_print_flags,
>  				   (void *)EI_FLAG_PRINT_SYMBOL),
> +	OPT_CALLBACK_DEFAULT_NOOPT('A', "all", NULL, NULL,
> +				   "print all items", set_print_flags,
> +				   (void *)EI_FLAG_PRINT_ALL),
>  	OPT_END()
>  };
>  
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
