Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2EXLoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:44:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51472 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2EXLoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:44:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDndFUaehVQjeOhKLAeYxboDqUxrpkFSBXAq9k619apWg@mail.gmail.com>
References: <CAJd=RBDndFUaehVQjeOhKLAeYxboDqUxrpkFSBXAq9k619apWg@mail.gmail.com>
Date: Thu, 24 May 2012 19:44:14 +0800
Message-ID: <CAJd=RBAa4Kq=Ev72-mKfmG7OW6u7pOdZAaDvKLuZYjAX6JLWgw@mail.gmail.com>
Subject: Re: [patch] BFS 420: remove for_each_flag_domain
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 8:56 PM, Hillf Danton <dhillf@gmail.com> wrote:
> The macro, for_each_flag_domain, is no longer used, so remove.
>
> --- a/kernel/sched/bfs.c        Mon May 14 20:50:38 2012
> +++ b/kernel/sched/bfs.c        Wed May 23 20:09:32 2012
> @@ -4951,42 +4951,6 @@ void select_nohz_load_balancer(int stop_
>  }
>
>  void set_cpu_sd_state_idle(void) {}
> -#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> -/**
> - * lowest_flag_domain - Return lowest sched_domain containing flag.
> - * @cpu:       The cpu whose lowest level of sched domain is to
> - *             be returned.
> - * @flag:      The flag to check for the lowest sched_domain
> - *             for the given cpu.
> - *
> - * Returns the lowest sched_domain of a cpu which contains the given flag.
> - */
> -static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
> -{
> -       struct sched_domain *sd;
> -
> -       for_each_domain(cpu, sd)
> -               if (sd && (sd->flags & flag))
> -                       break;
> -
> -       return sd;
> -}
> -
> -/**
> - * for_each_flag_domain - Iterates over sched_domains containing the flag.
> - * @cpu:       The cpu whose domains we're iterating over.
> - * @sd:                variable holding the value of the power_savings_sd
> - *             for cpu.
> - * @flag:      The flag to filter the sched_domains to be iterated.
> - *
> - * Iterates over all the scheduler domains for a given cpu that has the 'flag'
> - * set, starting from the lowest sched_domain to the highest.
> - */
> -#define for_each_flag_domain(cpu, sd, flag) \
> -       for (sd = lowest_flag_domain(cpu, flag); \
> -               (sd && (sd->flags & flag)); sd = sd->parent)
> -
> -#endif /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
>
>  static inline void resched_cpu(int cpu)
>  {
> --
