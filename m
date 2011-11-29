Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1K2UcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:32:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab1K2UcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:32:15 -0500
Message-ID: <4ED54146.6000507@canonical.com>
Date: Tue, 29 Nov 2011 14:32:06 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 1/3] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat
References: <20111129191252.769160532@openvz.org> <20111129191638.756761754@openvz.org>
In-Reply-To: <20111129191638.756761754@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 01:12 PM, Cyrill Gorcunov wrote:
> It helps to dump and restore this mm_struct members.
>
> Signed-off-by: Cyrill Gorcunov<gorcunov@openvz.org>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>   fs/proc/array.c |    7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.git/fs/proc/array.c
> ===================================================================
> --- linux-2.6.git.orig/fs/proc/array.c
> +++ linux-2.6.git/fs/proc/array.c
> @@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
>
>   	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
>   %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
> +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
>   		pid_nr_ns(pid, ns),
>   		tcomm,
>   		state,
> @@ -511,7 +511,10 @@ static int do_task_stat(struct seq_file
>   		task->policy,
>   		(unsigned long long)delayacct_blkio_ticks(task),
>   		cputime_to_clock_t(gtime),
> -		cputime_to_clock_t(cgtime));
> +		cputime_to_clock_t(cgtime),
> +		mm ? (permitted ? mm->start_data : 1) : 0,
> +		mm ? (permitted ? mm->end_data : 1) : 0,
> +		mm ? (permitted ? mm->start_brk : 1) : 0);
>   	if (mm)
>   		mmput(mm);
>   	return 0;
>

