Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1GQP70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:59:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39356 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1GQP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:59:25 -0400
Message-ID: <4E2306DE.4020109@gmail.com>
Date: Sun, 17 Jul 2011 09:59:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 1/6] [BUGFIX] perf script: print correct IP address
References: <20110717093031.3447.52715.stgit@linux3> <20110717093045.3447.27199.stgit@linux3>
In-Reply-To: <20110717093045.3447.27199.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 03:30 AM, Akihiro Nagai wrote:
> perf_session_print_ip() prints addr_location->addr as IP address.
> It's not always same as IP address. To correct it, this function
> must print sample->ip.
> 
> Changes in v2:
>  - add this patch

I submitted a patch for this back in May that was not picked up:
https://lkml.org/lkml/2011/5/30/223

David


> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
> 
>  tools/perf/util/session.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 080e533..453a010 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1263,7 +1263,7 @@ void perf_session__print_ip(union perf_event *event,
>  		}
>  
>  	} else {
> -		printf("%16" PRIx64, al.addr);
> +		printf("%16" PRIx64, sample->ip);
>  		if (print_sym) {
>  			if (al.sym && al.sym->name)
>  				symname = al.sym->name;
> 
