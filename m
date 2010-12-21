Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0LUFaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:30:10 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44577 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0LUFaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:30:08 -0500
X-AuditID: b753bd60-9f754ba00000044b-17-4d103b5e3e21
Message-ID: <4D103B5B.3080905@hitachi.com>
Date: Tue, 21 Dec 2010 14:30:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/6] perf-tools: make perf-probe -L display the absolute
 path of the dumped file
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com> <1292854685-8230-2-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1292854685-8230-2-git-send-email-fbuihuu@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/20 23:18), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> The actual file used by 'perf probe -L sched.c' is reported in the
> ouput of the command.
> 
> But it's simply displayed as it has been given to the command (simply
> sched.c) which is too ambiguous to be really usefull since several
> sched.c files can be found into the same project and we also don't
> know which search path has been used.

It's enough reasonable for me.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 558545e..6fa0403 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -381,7 +381,7 @@ int show_line_range(struct line_range *lr, const char *module)
>  		fprintf(stdout, "<%s:%d>\n", lr->function,
>  			lr->start - lr->offset);
>  	else
> -		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
> +		fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
>  
>  	fp = fopen(lr->path, "r");
>  	if (fp == NULL) {


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
