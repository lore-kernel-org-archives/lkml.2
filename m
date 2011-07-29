Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1G2DiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 23:38:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab1G2DiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 23:38:03 -0400
Message-ID: <4E322B19.3020604@cn.fujitsu.com>
Date: Fri, 29 Jul 2011 11:38:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep: Fix lockdep_no_validate against IRQ
 states
References: <tip-2dp5vmpsxeraqm42kgww6ge2@git.kernel.org>
In-Reply-To: <tip-2dp5vmpsxeraqm42kgww6ge2@git.kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-29 11:37:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-29 11:37:04,
	Serialize complete at 2011-07-29 11:37:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Peter Zijlstra wrote:
> Commit-ID:  efbe2eee6dc0f179be84292bf269528b3ec365e9
> Gitweb:     http://git.kernel.org/tip/efbe2eee6dc0f179be84292bf269528b3ec365e9
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 7 Jul 2011 11:39:45 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 21 Jul 2011 20:43:16 +0200
> 
> lockdep: Fix lockdep_no_validate against IRQ states
> 
> Thomas noticed that a lock marked with lockdep_set_novalidate_class()
> will still trigger warnings for IRQ inversions. Cure this by skipping
> those when marking irq state.
> 
> Reported-and-tested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-2dp5vmpsxeraqm42kgww6ge2@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/lockdep.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 298c927..628276d 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2468,6 +2468,9 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
>  
>  		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
>  
> +		if (hlock_class(hlock)->key == &__lockdep_no_validate__)
> +			continue;
> +

The 2 pointers are not the same type.

kernel/lockdep.c: In function 'mark_held_locks':
kernel/lockdep.c:2471:31: warning: comparison of distinct pointer types lacks a cast

>  		if (!mark_lock(curr, hlock, usage_bit))
>  			return 0;
>  	}
