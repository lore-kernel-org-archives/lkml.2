Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab0CQOLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0CQOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:11:48 -0400
Message-ID: <4BA0E3CC.4060909@redhat.com>
Date: Wed, 17 Mar 2010 10:14:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf probe: Fix !dwarf build
References: <20100316220612.32050.33806.stgit@localhost6.localdomain6> <tip-3b0d516463f8deb897a55cb81e9dbbe58a2490ed@git.kernel.org>
In-Reply-To: <tip-3b0d516463f8deb897a55cb81e9dbbe58a2490ed@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, thank you,

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

tip-bot for Ingo Molnar wrote:
> Commit-ID:  3b0d516463f8deb897a55cb81e9dbbe58a2490ed
> Gitweb:     http://git.kernel.org/tip/3b0d516463f8deb897a55cb81e9dbbe58a2490ed
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 17 Mar 2010 12:13:28 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 17 Mar 2010 12:13:28 +0100
> 
> perf probe: Fix !dwarf build
> 
> Fix the !drawf build.
> 
> This uses the existing NO_DWARF_SUPPORT mechanism we use for that,
> but it's really fragile and needs a cleanup. (in a separate patch)
> 
> 1) Such uses:
> 
>  #ifndef NO_DWARF_SUPPORT
> 
> are double inverted logic a'la 'not not'. Instead the flag should
> be called DWARF_SUPPORT.
> 
> 2) Furthermore, assymetric #ifdef polluted code flow like:
> 
>         if (need_dwarf)
>  #ifdef NO_DWARF_SUPPORT
>                 die("Debuginfo-analysis is not supported");
>  #else   /* !NO_DWARF_SUPPORT */
>                 pr_debug("Some probes require debuginfo.\n");
> 
>         fd = open_vmlinux();
> 
> is very fragile and not acceptable. Instead of that helper functions
> should be created and the dwarf/no-dwarf logic should be separated more
> cleanly.
> 
> 3) Local variable #ifdefs like this:
> 
>  #ifndef NO_DWARF_SUPPORT
>         int fd;
>  #endif
> 
> Are fragile as well and should be eliminated. Helper functions achieve
> that too.
> 
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  tools/perf/util/probe-event.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 64dea6c..f333269 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1012,8 +1012,10 @@ end_dwarf:
>  	if (!sym)
>  		die("Kernel symbol \'%s\' not found - probe not added.",
>  		    tev->point.symbol);
> +#ifndef NO_DWARF_SUPPORT
>  found:
>  	close(fd);
> +#endif
>  	return ntevs;
>  }
>  
> @@ -1172,10 +1174,13 @@ void show_line_range(struct line_range *lr)
>  	unsigned int l = 1;
>  	struct line_node *ln;
>  	FILE *fp;
> +#ifndef NO_DWARF_SUPPORT
>  	int fd, ret;
> +#endif
>  
>  	/* Search a line range */
>  	init_vmlinux();
> +#ifndef NO_DWARF_SUPPORT
>  	fd = open_vmlinux();
>  	if (fd < 0)
>  		die("Could not open debuginfo file.");
> @@ -1183,6 +1188,7 @@ void show_line_range(struct line_range *lr)
>  	if (ret <= 0)
>  		die("Source line is not found.\n");
>  	close(fd);
> +#endif
>  
>  	setup_pager();
>  

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

