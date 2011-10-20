Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab1JTSjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 14:39:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37432 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab1JTSjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 14:39:19 -0400
Date: Thu, 20 Oct 2011 20:39:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, Tejun Heo <htejun@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111020183913.GA21918@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Rientjes <rientjes@google.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Tejun Heo <tj@kernel.org>, Tejun Heo <htejun@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20111015201239.GA3475@swordfish>
 <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
 <20111015222324.GA16432@liondog.tnic>
 <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 03:32:32PM -0700, David Rientjes wrote:
> Could you try to revert f59de8992aa6 ("lockdep: Clear whole lockdep_map on 
> initialization") with this patch and see if it helps?  Thanks.
> ---
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2874,7 +2874,10 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
>  void lockdep_init_map(struct lockdep_map *lock, const char *name,
>  		      struct lock_class_key *key, int subclass)
>  {
> -	memset(lock, 0, sizeof(*lock));
> +	int i;
> +
> +	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
> +		lock->class_cache[i] = NULL;
>  
>  #ifdef CONFIG_LOCK_STAT
>  	lock->cpu = raw_smp_processor_id();

FWIW,

the box has been running here with f59de8992aa6 reverted for a couple of
days now and no sign of the warning. I'll keep watching it but it looks
ok so far, so David, you could've nailed it.

Thanks.

-- 
Regards/Gruss,
    Boris.
