Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab0LUJry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:47:54 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34713 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675Ab0LUJrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:47:53 -0500
X-AuditID: b753bd60-a41a1ba000003e7d-c0-4d1077c6e2ed
Message-ID: <4D1077C4.6070301@hitachi.com>
Date: Tue, 21 Dec 2010 18:47:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 3/6] perf-probe: clean up redundant tests in show_line_range()
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com> <1292854685-8230-4-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1292854685-8230-4-git-send-email-fbuihuu@gmail.com>
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
> It also removes some superflous parentheses.

Oh, don't remove your superfluous comments too! ;-)


> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 5cc8f6b..3c92b92 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -383,26 +383,30 @@ int show_line_range(struct line_range *lr, const char *module)
>  		return -errno;
>  	}
>  	/* Skip to starting line number */
> -	while (l < lr->start && ret >= 0)
> +	while (l < lr->start) {
>  		ret = show_one_line(fp, l++, true, false);
> -	if (ret < 0)
> -		goto end;
> +		if (ret < 0)
> +			goto end;
> +	}
>  
>  	list_for_each_entry(ln, &lr->line_list, list) {
> -		while (ln->line > l && ret >= 0)
> -			ret = show_one_line(fp, (l++) - lr->offset,
> -					    false, false);
> -		if (ret >= 0)
> -			ret = show_one_line(fp, (l++) - lr->offset,
> -					    false, true);
> +		for (; ln->line > l; l++) {
> +			ret = show_one_line(fp, l - lr->offset, false, false);
> +			if (ret < 0)
> +				goto end;
> +		}
> +		ret = show_one_line(fp, l++ - lr->offset, false, true);
>  		if (ret < 0)
>  			goto end;
>  	}
>  
>  	if (lr->end == INT_MAX)
>  		lr->end = l + NR_ADDITIONAL_LINES;
> -	while (l <= lr->end && !feof(fp) && ret >= 0)
> -		ret = show_one_line(fp, (l++) - lr->offset, false, false);
> +	while (l <= lr->end && !feof(fp)) {
> +		ret = show_one_line(fp, l++ - lr->offset, false, false);
> +		if (ret < 0)
> +			break;
> +	}
>  end:
>  	fclose(fp);
>  	return ret;


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
