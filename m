Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab0EDUsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:48:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0EDUsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:48:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=i0cCftgv4t36dLVt2KhGs7A57AdGytHezhWf81Hy+ZlXLTyRcjhv/fTe4vWuSow0Q
	P8PSTzXPeCRcruMwFChTg==
MIME-Version: 1.0
In-Reply-To: <1273004398-19760-33-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
	 <1273004398-19760-33-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Tue, 4 May 2010 13:48:10 -0700
Message-ID: <m2v6599ad831005041348le3a2373fmab4626bd51cfc698@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 33/48] cgroups: __rcu annotations
From: Paul Menage <menage@google.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 1:19 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  include/linux/cgroup.h |    4 ++--
>  include/linux/sched.h  |    2 +-
>  kernel/cgroup.c        |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 8f78073..b147fd5 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -75,7 +75,7 @@ struct cgroup_subsys_state {
>
>        unsigned long flags;
>        /* ID for this css, if possible */
> -       struct css_id *id;
> +       struct css_id __rcu *id;
>  };
>
>  /* bits in struct cgroup_subsys_state flags field */
> @@ -205,7 +205,7 @@ struct cgroup {
>        struct list_head children;      /* my children */
>
>        struct cgroup *parent;          /* my parent */
> -       struct dentry *dentry;          /* cgroup fs entry, RCU protected */
> +       struct dentry __rcu *dentry;    /* cgroup fs entry, RCU protected */
>
>        /* Private pointers for each registered subsystem */
>        struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index dad7f66..7307c74 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1429,7 +1429,7 @@ struct task_struct {
>  #endif
>  #ifdef CONFIG_CGROUPS
>        /* Control Group info protected by css_set_lock */
> -       struct css_set *cgroups;
> +       struct css_set __rcu *cgroups;
>        /* cg_list protected by css_set_lock and tsk->alloc_lock */
>        struct list_head cg_list;
>  #endif
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3a53c77..5cfbc93 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -138,7 +138,7 @@ struct css_id {
>         * is called after synchronize_rcu(). But for safe use, css_is_removed()
>         * css_tryget() should be used for avoiding race.
>         */
> -       struct cgroup_subsys_state *css;
> +       struct cgroup_subsys_state __rcu *css;
>        /*
>         * ID of this css.
>         */
> --
> 1.7.0
>
>
