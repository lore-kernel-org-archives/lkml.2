Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2E3LW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:22:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:43845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2E3LWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:22:54 -0400
Message-ID: <1338376967.26856.262.camel@twins>
Subject: Re: [PATCH v3 6/6] expose per-taskgroup schedstats in cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 13:22:47 +0200
In-Reply-To: <1338371317-5980-7-git-send-email-glommer@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-7-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
> +static u64 tg_idle(struct task_group *tg, int cpu)
> +{
> +       u64 val;
> +
> +       if (tg != &root_task_group) {
> +               val = cfs_read_sleep(tg->se[cpu]);
> +               /* If we have rt tasks running, we're not really idle */
> +               val -= rt_rq(exec_clock, tg, cpu);
> +       } else
> +               /*
> +                * There are many errors here that we are accumulating.
> +                * However, we only provide this in the interest of having
> +                * a consistent interface for all cgroups. Everybody
> +                * probing the root cgroup should be getting its figures
> +                * from system-wide files as /proc/stat. That would be faster
> +                * to begin with...
> +                *
> +                * Ditto for steal.
> +                */
> +               val = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE] * TICK_NSEC;

You just violated 2 coding style rules in one go :-)

If one side of the if-else has braces, the other side should have too.
If a block is multi-line (regardless of multi-stmt) it should have
braces.

/me hands you a bucket full of {}.

> +       return val;
> +} 
