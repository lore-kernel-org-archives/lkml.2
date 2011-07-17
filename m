Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1GQRbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 13:31:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44613 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1GQRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 13:31:10 -0400
Date: Sun, 17 Jul 2011 19:31:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf script: fix display of IP address for non-callchain
 path
Message-ID: <20110717173103.GB29355@somewhere>
References: <1306768587-15376-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306768587-15376-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 09:16:27AM -0600, David Ahern wrote:
> Non-callchain path is using al.addr which prints as:
>   openssl 14564 17672.003587:       7862d _x86_64_AES_encrypt_compact
> 
> This should be sample->ip to print as:
>   openssl 14564 17672.003587:  3f7867862d _x86_64_AES_encrypt_compact
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  tools/perf/util/session.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index e6cf0e2..360d8c4 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1247,7 +1247,7 @@ void perf_session__print_ip(union perf_event *event,
>  		}
>  
>  	} else {
> -		printf("%16" PRIx64, al.addr);
> +		printf("%16" PRIx64, sample->ip);
>  		if (print_sym) {
>  			if (al.sym && al.sym->name)
>  				symname = al.sym->name;
> -- 
> 1.7.5.2
> 
