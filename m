Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1AKBxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:53:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63886 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1AKBxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TrtURjh1HxUX+uT5elzncOG2nZd39xla7C7Vbj0L3dLXCOPXclpUJghj+ff0Mb6ZD0
         tV5WYqoVmazx/AgCb9xveD/GqTCm8YqfJ3CSz6WgNQCuE2QFjZdPkcCtiKtJLXtEgliX
         W50xOVKUYGEUNBNTkw8ToyZ0VzhOobvtGdblc=
MIME-Version: 1.0
In-Reply-To: <20110110051551.GC2772@in.ibm.com>
References: <20110110051445.GB2772@in.ibm.com>
	<20110110051551.GC2772@in.ibm.com>
Date: Tue, 11 Jan 2011 09:53:05 +0800
Message-ID: <AANLkTi=kEFcJ183xUCXGL=QqPLnOYBNtpQ=i5F9kTwK4@mail.gmail.com>
Subject: Re: [PATCH -tip 1/2] sched: Reinstate group names in /proc/sched_debug.
From: Yong Zhang <yong.zhang0@gmail.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 1:15 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> sched: Reinstate group names in /proc/sched_debug.
>
> Displaying of group names in /proc/sched_debug was dropped in autogroup
> patches. Add group names while displaying cfs_rq and tasks information.
>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
> @@ -144,7 +167,11 @@ void print_cfs_rq(struct seq_file *m, in
>        struct sched_entity *last;
>        unsigned long flags;
>
> +#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)

defined(CONFIG_CGROUP_SCHED) is not necessary here,
CONFIG_[FAIR|RT]_GROUP_SCHED always imply CONFIG_CGROUP_SCHED

> +       SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, task_group_path(cfs_rq->tg));
> +#else
>        SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
> +#endif
>        SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
>                        SPLIT_NS(cfs_rq->exec_clock));
>
> @@ -191,7 +218,11 @@ void print_cfs_rq(struct seq_file *m, in
>
>  void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>  {
> +#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)

Ditto.

Thanks,
Yong

-- 
Only stand for myself
