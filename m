Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0LZOL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 09:11:26 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41989 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0LZOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 09:11:25 -0500
X-AuditID: b753bd60-a1557ba00000044b-20-4d174d09615b
Message-ID: <4D174D07.6030706@hitachi.com>
Date: Sun, 26 Dec 2010 23:11:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de, vagabon.xyz@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [tip:perf/core] perf probe: Fix wrong warning in __show_one_line()
 if read(1) errors happen
References: <m3y67hsr0m.fsf@gmail.com> <tip-32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee@git.kernel.org>
In-Reply-To: <tip-32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/25 17:58), tip-bot for Franck Bui-Huu wrote:
> Commit-ID:  32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee
> Gitweb:     http://git.kernel.org/tip/32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee
> Author:     Franck Bui-Huu <vagabon.xyz@gmail.com>
> AuthorDate: Wed, 22 Dec 2010 17:37:13 +0100
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Wed, 22 Dec 2010 20:32:08 -0200
> 
> perf probe: Fix wrong warning in __show_one_line() if read(1) errors happen
> 
> This was introduced by commit fde52dbd7f71934aba4e150f3d1d51e826a08850.
> 

It's a good fix for me.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> LKML-Reference: <m3y67hsr0m.fsf@gmail.com>
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/probe-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 099336e..4bde988 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -309,7 +309,7 @@ static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
>  	return 1;
>  error:
>  	if (ferror(fp)) {
> -		pr_warning("Source file is shorter than expected.\n");
> +		pr_warning("File read error: %s\n", strerror(errno));
>  		return -1;
>  	}
>  	return 0;
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
