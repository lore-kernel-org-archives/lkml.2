Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0LXEqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 23:46:15 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33757 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab0LXEqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 23:46:14 -0500
X-AuditID: b753bd60-9e352ba00000044b-34-4d14259386e4
Message-ID: <4D142591.2030101@hitachi.com>
Date: Fri, 24 Dec 2010 13:46:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: no need to initialize the entire temporary
 buffers in synthesize_perf_probe_point()
References: <m3wrn07blu.fsf@gmail.com>
In-Reply-To: <m3wrn07blu.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/24 0:27), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> This patches only put a single null byte at the beginning of each
> temporary buffers line[], offs[], file[] instead of filling their full
> contents with null bytes.

Hmm, sorry but NAK it.

IMHO, with modern chips, the original code has no problem from the
viewpoint of memory access (all are cached and no need to access just
one byte) nor a bottleneck.
I'd rather use '= ""' style initialization for local variables from the
viewpoint of readability.

Anyway, thank you for looking into the code :-)

Thanks,

> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index adc2620..e453f13 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1058,9 +1058,11 @@ error:
>  static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
>  {
>  	char *buf, *tmp;
> -	char offs[32] = "", line[32] = "", file[32] = "";
> +	char offs[32], line[32], file[32];
>  	int ret, len;
>  
> +	offs[0] = line[0] = file[0] = '\0';
> +
>  	buf = zalloc(MAX_CMDLEN);
>  	if (buf == NULL) {
>  		ret = -ENOMEM;


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
