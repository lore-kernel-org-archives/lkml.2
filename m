Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0LLQCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:02:47 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46181 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0LLQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:02:44 -0500
X-AuditID: b753bd60-a69a5ba000003e7d-6c-4d04f2217d82
Message-ID: <4D04F21D.6060300@hitachi.com>
Date: Mon, 13 Dec 2010 01:02:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Franck Bui-Huu <fbuihuu@gmail.com>, 2nddept-manager@sdl.hitachi.co.jp,
        Francis Moreau <francis.moro@gmail.com>,
        Franck Bui-Huu <vagabon.xyz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf symbols: Stop using vmlinux files with no symbols
References: <1292167014-20936-1-git-send-email-acme@infradead.org> <1292167014-20936-3-git-send-email-acme@infradead.org>
In-Reply-To: <1292167014-20936-3-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/13 0:16), Arnaldo Carvalho de Melo wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Fail if the kernel image contains no symbol, allowing using other images
> in the vmlinux search path that may have a usable symtab.
> 
> Cc: 2nddept-manager@sdl.hitachi.co.jp
> Cc: Francis Moreau <francis.moro@gmail.com>
> Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> LPU-Reference: <m3d3p9ydx9.fsf_-_@gmail.com>
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Looks good for me:)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  tools/perf/util/probe-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index b71acd6..61191c6 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -135,7 +135,7 @@ const char *kernel_get_module_path(const char *module)
>  		if (dso__load_vmlinux(dso, map, vmlinux_name, NULL) <= 0)
>  			return NULL;
>  	} else {
> -		if (dso__load_vmlinux_path(dso, map, NULL) < 0) {
> +		if (dso__load_vmlinux_path(dso, map, NULL) <= 0) {
>  			pr_debug("Failed to load kernel map.\n");
>  			return NULL;
>  		}


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
