Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2CXMyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 08:54:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:39852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2CXMyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 08:54:17 -0400
Message-ID: <1332593574.16159.31.camel@twins>
Subject: Re: [PATCH 10/10] oom: Make find_lock_task_mm() sparse-aware
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Date: Sat, 24 Mar 2012 13:52:54 +0100
In-Reply-To: <20120324103127.GJ29067@lizard>
References: <20120324102609.GA28356@lizard> <20120324103127.GJ29067@lizard>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 14:31 +0400, Anton Vorontsov wrote:
> This is needed so that callers would not get 'context imbalance'
> warnings from the sparse tool.
> 
> As a side effect, this patch fixes the following sparse warnings:
> 
>   CHECK   mm/oom_kill.c
>   mm/oom_kill.c:201:28: warning: context imbalance in 'oom_badness' -
>   unexpected unlock
>   include/linux/rcupdate.h:249:30: warning: context imbalance in
>   'dump_tasks' - unexpected unlock
>   mm/oom_kill.c:453:9: warning: context imbalance in 'oom_kill_task' -
>   unexpected unlock
>   CHECK   mm/memcontrol.c
>   ...
>   mm/memcontrol.c:1130:17: warning: context imbalance in
>   'task_in_mem_cgroup' - unexpected unlock
> 
> p.s. I know Peter Zijlstra detest the __cond_lock() stuff, but untill
>      we have anything better in sparse, let's use it. This particular
>      patch helped me to detect one bug that I myself made during
>      task->mm fixup series. So, it is useful.

Yeah, so Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Also, why didn't lockdep catch it?

Fix sparse already instead of smearing ugly all over.
