Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HDPyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:54:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47666 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1HDPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:54:49 -0400
Date: Thu, 4 Aug 2011 18:53:47 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: select_task_rq_fair: WARNING: at kernel/lockdep.c match_held_lock
Message-ID: <20110804155347.GB3562@swordfish.minsk.epam.com>
References: <20110804141306.GA3536@swordfish.minsk.epam.com>
 <1312470358.16729.25.camel@twins>
 <20110804153752.GA3562@swordfish.minsk.epam.com>
 <1312472867.16729.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312472867.16729.38.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/04/11 17:47), Peter Zijlstra wrote:
> On Thu, 2011-08-04 at 18:37 +0300, Sergey Senozhatsky wrote:
> > > > [  132.794685] WARNING: at kernel/lockdep.c:3117 match_held_lock+0xf6/0x12e()
> 
> Just to double check, that line is:
> 
>                 if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
> 
> in your kernel source?
> 

Nope, that's `if (DEBUG_LOCKS_WARN_ON(!class))'

3106 static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
3107 {                                                                                                                                                                                                                             
3108     if (hlock->instance == lock)
3109         return 1;
3110 
3111     if (hlock->references) {
3112         struct lock_class *class = lock->class_cache[0];
3113 
3114         if (!class)
3115             class = look_up_lock_class(lock, 0);
3116 
3117         if (DEBUG_LOCKS_WARN_ON(!class))
3118             return 0;
3119 
3120         if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
3121             return 0;
3122 
3123         if (hlock->class_idx == class - lock_classes + 1)
3124             return 1;
3125     }
3126 
3127     return 0;
3128 }
3129 


	Sergey
