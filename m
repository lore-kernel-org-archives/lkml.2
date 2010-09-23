Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0IWV5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:57:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738Ab0IWV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:57:45 -0400
Date: Thu, 23 Sep 2010 14:56:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: nhorman@tuxdriver.com, eugene@redhat.com, linux-kernel@vger.kernel.org,
        oleg@tv-sign.ru
Subject: Re: [RFC PATCH] proc: making "limits" world readable
Message-Id: <20100923145642.49f17b20.akpm@linux-foundation.org>
In-Reply-To: <1285060255-15784-1-git-send-email-jolsa@redhat.com>
References: <1285060255-15784-1-git-send-email-jolsa@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 11:10:55 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> hi,
> 
> I'd like to have the /proc/<pid>/limits file world readable,

Why?

> but I'm not sure this could cause some security issue.. thoughts?
> 
> The "limit" file was as a debug feature by following commit:
> - proc: export a processes resource limits via /proc/pid
>   commit d85f50d5e1aa99ab082035f94265847521819e58
>   Author: Neil Horman <nhorman@tuxdriver.com>
> 
> 
> thanks for any ideas,
> jirka
> ---
>  fs/proc/base.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a1c43e7..8e4adda 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2675,7 +2675,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	INF("auxv",       S_IRUSR, proc_pid_auxv),
>  	ONE("status",     S_IRUGO, proc_pid_status),
>  	ONE("personality", S_IRUSR, proc_pid_personality),
> -	INF("limits",	  S_IRUSR, proc_pid_limits),
> +	INF("limits",	  S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif
> @@ -3011,7 +3011,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	INF("auxv",      S_IRUSR, proc_pid_auxv),
>  	ONE("status",    S_IRUGO, proc_pid_status),
>  	ONE("personality", S_IRUSR, proc_pid_personality),
> -	INF("limits",	 S_IRUSR, proc_pid_limits),
> +	INF("limits",	 S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif

