Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2ISDCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:02:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44960 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2ISDCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:02:38 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-a7-505935cb2c77
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] tools lib traceevent: Use calloc were applicable
References: <1347915049-19093-1-git-send-email-acme@infradead.org>
	<1347915049-19093-3-git-send-email-acme@infradead.org>
Date: Wed, 19 Sep 2012 11:54:01 +0900
In-Reply-To: <1347915049-19093-3-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Mon, 17 Sep 2012 17:50:47 -0300")
Message-ID: <87boh23epi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 17:50:47 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Replacing the equivalent open coded malloc + memset bits.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Link: http://lkml.kernel.org/n/tip-598fjtjbzal4wxh7fp0yv0q1@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/lib/traceevent/event-parse.c |   44 ++++++++++++------------------------
>  1 file changed, 14 insertions(+), 30 deletions(-)
>
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 278f989..5e38d2f 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -117,14 +117,7 @@ void breakpoint(void)
>  
>  struct print_arg *alloc_arg(void)
>  {
> -	struct print_arg *arg;
> -
> -	arg = malloc_or_die(sizeof(*arg));
> -	if (!arg)
> -		return NULL;
> -	memset(arg, 0, sizeof(*arg));
> -
> -	return arg;
> +	return calloc(1, sizeof(struct print_arg));
>  }

This requires every callsite of the function should handle allocation
failure.

Thanks,
Namhyung
