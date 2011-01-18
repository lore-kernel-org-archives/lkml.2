Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1ARWxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:53:24 -0500
Received: from smtp-out.google.com ([74.125.121.67]:26142 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1ARWxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:53:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uD6WqQYMQL/Ib2Z88pkUY/sHPVruf2z3idkcTbVWd6exaHxjc62Kj+s1sTmIR7n6sx
         RH3Thp5qLzrOmwL647Lw==
MIME-Version: 1.0
In-Reply-To: <1295391078.1831.21.camel@dan>
References: <1295391078.1831.21.camel@dan>
From: Paul Menage <menage@google.com>
Date: Tue, 18 Jan 2011 14:52:59 -0800
Message-ID: <AANLkTi=3D6Rb1BRTEPWcyiPtkJg9pAv4KxNhXMcLA-sR@mail.gmail.com>
Subject: Re: [PATCH] Switch proc interfaces in kernel/ to %pK
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 2:51 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> Switch users of %p in /proc interfaces in kernel/ to %pK, to allow
> configuring the level of exposure of kernel pointers via the
> kptr_restrict sysctl.
>
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Acked-by: Paul Menage <menage@google.com>

(for cgroup.c)


> ---
>  kernel/cgroup.c           |    2 +-
>  kernel/kprobes.c          |    4 ++--
>  kernel/lockdep_proc.c     |   10 +++++-----
>  kernel/time/timer_stats.c |    2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b24d702..b04951b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4894,7 +4894,7 @@ static int cgroup_css_links_read(struct cgroup *cont,
>                struct css_set *cg = link->cg;
>                struct task_struct *task;
>                int count = 0;
> -               seq_printf(seq, "css_set %p\n", cg);
> +               seq_printf(seq, "css_set %pK\n", cg);
>                list_for_each_entry(task, &cg->tasks, cg_list) {
>                        if (count++ > MAX_TASKS_SHOWN_PER_CSS) {
>                                seq_puts(seq, "  ...\n");
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 7798181..2437ca4 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2021,11 +2021,11 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
>                kprobe_type = "k";
>
>        if (sym)
> -               seq_printf(pi, "%p  %s  %s+0x%x  %s ",
> +               seq_printf(pi, "%pK  %s  %s+0x%x  %s ",
>                        p->addr, kprobe_type, sym, offset,
>                        (modname ? modname : " "));
>        else
> -               seq_printf(pi, "%p  %s  %p ",
> +               seq_printf(pi, "%pK  %s  %pK ",
>                        p->addr, kprobe_type, p->addr);
>
>        if (!pp)
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index 1969d2f..215638d 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -65,7 +65,7 @@ static int l_show(struct seq_file *m, void *v)
>                return 0;
>        }
>
> -       seq_printf(m, "%p", class->key);
> +       seq_printf(m, "%pK", class->key);
>  #ifdef CONFIG_DEBUG_LOCKDEP
>        seq_printf(m, " OPS:%8ld", class->ops);
>  #endif
> @@ -83,7 +83,7 @@ static int l_show(struct seq_file *m, void *v)
>
>        list_for_each_entry(entry, &class->locks_after, entry) {
>                if (entry->distance == 1) {
> -                       seq_printf(m, " -> [%p] ", entry->class->key);
> +                       seq_printf(m, " -> [%pK] ", entry->class->key);
>                        print_name(m, entry->class);
>                        seq_puts(m, "\n");
>                }
> @@ -152,7 +152,7 @@ static int lc_show(struct seq_file *m, void *v)
>                if (!class->key)
>                        continue;
>
> -               seq_printf(m, "[%p] ", class->key);
> +               seq_printf(m, "[%pK] ", class->key);
>                print_name(m, class);
>                seq_puts(m, "\n");
>        }
> @@ -502,7 +502,7 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
>                if (!i)
>                        seq_line(m, '-', 40-namelen, namelen);
>
> -               snprintf(ip, sizeof(ip), "[<%p>]",
> +               snprintf(ip, sizeof(ip), "[<%pK>]",
>                                (void *)class->contention_point[i]);
>                seq_printf(m, "%40s %14lu %29s %pS\n",
>                           name, stats->contention_point[i],
> @@ -517,7 +517,7 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
>                if (!i)
>                        seq_line(m, '-', 40-namelen, namelen);
>
> -               snprintf(ip, sizeof(ip), "[<%p>]",
> +               snprintf(ip, sizeof(ip), "[<%pK>]",
>                                (void *)class->contending_point[i]);
>                seq_printf(m, "%40s %14lu %29s %pS\n",
>                           name, stats->contending_point[i],
> diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> index 2f3b585..3069d0d 100644
> --- a/kernel/time/timer_stats.c
> +++ b/kernel/time/timer_stats.c
> @@ -272,7 +272,7 @@ static void print_name_offset(struct seq_file *m, unsigned long addr)
>        char symname[KSYM_NAME_LEN];
>
>        if (lookup_symbol_name(addr, symname) < 0)
> -               seq_printf(m, "<%p>", (void *)addr);
> +               seq_printf(m, "<%pK>", (void *)addr);
>        else
>                seq_printf(m, "%s", symname);
>  }
>
>
>
