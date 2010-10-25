Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0JYGf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 02:35:58 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51996 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0JYGf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 02:35:57 -0400
X-AuditID: b753bd60-a87a8ba000003e7d-f8-4cc5254ba062
Message-ID: <4CC52540.7000905@hitachi.com>
Date: Mon, 25 Oct 2010 15:35:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] perf probe: Fix format specified for Dwarf_Off parameter
References: <1287865704-3880-1-git-send-email-acme@infradead.org> <1287865704-3880-6-git-send-email-acme@infradead.org>
In-Reply-To: <1287865704-3880-6-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/24 5:28), Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Fixing the following error on 32-bit arches:
> 
> util/probe-finder.c: In function ‘line_range_search_cb’:
> util/probe-finder.c:1734: error: format ‘%lx’ expects type ‘long
> unsigned int’, but argument 3 has type ‘Dwarf_Off’

Oops, right. Thanks Arnaldo!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/probe-finder.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index c20bd52..3991d73 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1731,7 +1731,8 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
>  	struct line_finder *lf = param->data;
>  	struct line_range *lr = lf->lr;
>  
> -	pr_debug("find (%lx) %s\n", dwarf_dieoffset(sp_die),
> +	pr_debug("find (%llx) %s\n",
> +		 (unsigned long long)dwarf_dieoffset(sp_die),
>  		 dwarf_diename(sp_die));
>  	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
>  	    die_compare_name(sp_die, lr->function)) {


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
