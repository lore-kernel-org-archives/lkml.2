Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2BFUJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:09:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab2BFUJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:09:05 -0500
Date: Mon, 6 Feb 2012 18:08:19 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tool: Fix prefix matching for kernel maps
Message-ID: <20120206200819.GJ6367@infradead.org>
References: <1328461865-6127-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328461865-6127-1-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Feb 05, 2012 at 06:11:05PM +0100, Jiri Olsa escreveu:
> In some perf ancient versions we used '[kernel.kallsyms._text]' as
> the name for the kernel map.
> 
> This got changed with commit:
>   perf: 'perf kvm' tool for monitoring guest performance from host
>   commit a1645ce12adb6c9cc9e19d7695466204e3f017fe
>   Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 
> and we started to use following name '[kernel.kallsyms]_text'.
> 
> This name change is important for the report code dealing with ancient
> perf data. When processing the kernel map event, we need to recognize
> the old naming (dont match the last ']') and initialize the kernel map
> correctly.
> 
> The subsequent call to maps__set_kallsyms_ref_reloc_sym deals with the
> superfluous ']' to get correct symbol name.

Good catch & fix, thanks.

People curious about that -1 can look at 'git blame' to read the above
historical explanation ;-)

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 73ddaf0..2044324 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -554,7 +554,7 @@ static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
>  
>  	is_kernel_mmap = memcmp(event->mmap.filename,
>  				kmmap_prefix,
> -				strlen(kmmap_prefix)) == 0;
> +				strlen(kmmap_prefix) - 1) == 0;
>  	if (event->mmap.filename[0] == '/' ||
>  	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
>  
> -- 
> 1.7.4.4
