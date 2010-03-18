Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0CRUDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:03:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0CRUDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:03:37 -0400
Message-ID: <4BA28708.3080705@redhat.com>
Date: Thu, 18 Mar 2010 16:03:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf events: Fix false positive build warning
 with older GCC's
References: <20100316220612.32050.33806.stgit@localhost6.localdomain6> <tip-55632770d7298835645489828af87f854c47749c@git.kernel.org>
In-Reply-To: <tip-55632770d7298835645489828af87f854c47749c@git.kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Ingo Molnar wrote:
> Commit-ID:  55632770d7298835645489828af87f854c47749c
> Gitweb:     http://git.kernel.org/tip/55632770d7298835645489828af87f854c47749c
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Thu, 18 Mar 2010 16:51:16 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 18 Mar 2010 17:03:24 +0100
> 
> perf events: Fix false positive build warning with older GCC's
> 
> gcc 4.2.1 produces:
> 
>  util/probe-event.c: In function 'add_perf_probe_events':
>  util/probe-event.c:883: warning: 'tev' may be used uninitialized in this function
>  make: *** [util/probe-event.o] Error 1
> 
> Newer GCCs get this right.
> 
> To work it around, initialize the variable to NULL so that older GCCs see
> it as initialized too.

Hmm, indeed. this code implies that ntevs > 0, it seems that we'd better
check it first (e.g. 'if(ntevs <= 0) return;') too.

Thank you,

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
>  tools/perf/util/probe-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index f333269..c6603f3 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -880,7 +880,7 @@ static void __add_kprobe_trace_events(struct perf_probe_event *pev,
>  				      int ntevs, bool allow_suffix)
>  {
>  	int i, fd;
> -	struct kprobe_trace_event *tev;
> +	struct kprobe_trace_event *tev = NULL;
>  	char buf[64];
>  	const char *event, *group;
>  	struct strlist *namelist;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
