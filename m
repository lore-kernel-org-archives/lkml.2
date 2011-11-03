Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1KCVgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:36:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62900 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:36:30 -0400
Message-ID: <4EB3095A.9050803@gmail.com>
Date: Fri, 04 Nov 2011 01:36:26 +0400
From: "avagin@gmail.com" <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org>  <1320275277.4793.54.camel@gandalf.stny.rr.com> <1320329977.27370.16.camel@gandalf.stny.rr.com>
In-Reply-To: <1320329977.27370.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

>
> Can you try this patch on perf. It's untested (not even compiled tested)
It looks like it works now. Thanks.
>
> -- Steve
>
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 0a7ed5b..6c164dc 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -1537,6 +1537,8 @@ process_flags(struct event *event, struct print_arg *arg, char **tok)
>   	field = malloc_or_die(sizeof(*field));
>
>   	type = process_arg(event, field,&token);
> +	while (type == EVENT_OP)
> +		type = process_op(event, field,&token);
>   	if (test_type_token(type, token, EVENT_DELIM, ","))
>   		goto out_free;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

