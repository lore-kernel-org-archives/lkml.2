Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1LFT46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:56:58 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57190 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1LFT45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:56:57 -0500
Date: Tue, 6 Dec 2011 11:56:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
        sergey.senozhatsky@gmail.com, bp@alien8.de, tj@kernel.org,
        yong.zhang0@gmail.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, kmemcheck: Annotate ->lock in
 lockdep_init_map()
In-Reply-To: <tip-d3d03d4fc5b1bec3a579112de170a9676e9d97cb@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1112061156330.24076@chino.kir.corp.google.com>
References: <20111109080451.GB8124@zhy> <tip-d3d03d4fc5b1bec3a579112de170a9676e9d97cb@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, tip-bot for Yong Zhang wrote:

> Commit-ID:  d3d03d4fc5b1bec3a579112de170a9676e9d97cb
> Gitweb:     http://git.kernel.org/tip/d3d03d4fc5b1bec3a579112de170a9676e9d97cb
> Author:     Yong Zhang <yong.zhang0@gmail.com>
> AuthorDate: Wed, 9 Nov 2011 16:04:51 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 6 Dec 2011 08:16:51 +0100
> 
> lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()
> 
> Since commit f59de89 ("lockdep: Clear whole lockdep_map on initialization"),
> lockdep_init_map() will clear all the struct. But it will break
> lock_set_class()/lock_set_subclass(). A typical race condition
> is like below:
> 
>      CPU A                                   CPU B
> lock_set_subclass(lockA);
>  lock_set_class(lockA);
>    lockdep_init_map(lockA);
>      /* lockA->name is cleared */
>      memset(lockA);
>                                      __lock_acquire(lockA);
>                                        /* lockA->class_cache[] is cleared */
>                                        register_lock_class(lockA);
>                                          look_up_lock_class(lockA);
>                                            WARN_ON_ONCE(class->name !=
>                                                      lock->name);
> 
>      lock->name = name;
> 
> So restore to what we have done before commit f59de89 but annotate
> ->lock with kmemcheck_mark_initialized() to suppress the kmemcheck
> warning reported in commit f59de89.
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Suggested-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/20111109080451.GB8124@zhy
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
