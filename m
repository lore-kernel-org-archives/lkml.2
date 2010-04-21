Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0DUADN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab0DUADL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:03:11 -0400
Message-ID: <4BCE40A5.1000407@redhat.com>
Date: Tue, 20 Apr 2010 20:02:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Fix perf probe build error
References: <1271808065-25290-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1271808065-25290-1-git-send-regression-fweisbec@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> When we run into dry run mode, we want to make write_kprobe_trace_event
> to succeed on writing the event. Let's initialize it to 0.
> 
> Fixes the following build error:
> 	util/probe-event.c:1266: attention : «ret» may be used uninitialized in this function
> 	util/probe-event.c:1266: note: «ret» was declared here
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thanks! that's what I've found today...

> ---
>  tools/perf/util/probe-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 3967f8f..4fb4803 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1263,7 +1263,7 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
>  
>  static int write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
>  {
> -	int ret;
> +	int ret = 0;
>  	char *buf = synthesize_kprobe_trace_command(tev);
>  
>  	if (!buf) {

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
