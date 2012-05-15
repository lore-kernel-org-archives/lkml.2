Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab2EOImm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:42:42 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64758 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab2EOImk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:42:40 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-92-4fb216fdff6f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Check return value of tracing_dentry_percpu()
References: <1335143517-2285-1-git-send-email-namhyung.kim@lge.com>
Date: Tue, 15 May 2012 17:41:01 +0900
In-Reply-To: <1335143517-2285-1-git-send-email-namhyung.kim@lge.com> (Namhyung
	Kim's message of "Mon, 23 Apr 2012 10:11:57 +0900")
Message-ID: <87mx59zvj6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve.

Can you have a look at this?

Thanks,
Namhyung

On Mon, 23 Apr 2012 10:11:57 +0900, Namhyung Kim wrote:
> If tracing_dentry_percpu() failed, tracing_init_debugfs_percpu()
> will try to create each cpu directories on debugfs' root directory
> as d_percpu is NULL.
>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  kernel/trace/trace.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index ed7b5d1e12f4..54df9a672fd9 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4367,6 +4367,9 @@ static void tracing_init_debugfs_percpu(long cpu)
>  	struct dentry *d_cpu;
>  	char cpu_dir[30]; /* 30 characters should be more than enough */
>  
> +	if (!d_percpu)
> +		return;
> +
>  	snprintf(cpu_dir, 30, "cpu%ld", cpu);
>  	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
>  	if (!d_cpu) {
