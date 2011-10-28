Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1J1BZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:25:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1J1BZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:25:28 -0400
Date: Fri, 28 Oct 2011 03:25:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
Message-ID: <20111028012521.GF25795@one.firstfloor.org>
References: <1319764761.23112.14.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319764761.23112.14.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 03:19:21AM +0200, Eric Dumazet wrote:
> In commit 4e60c86bd9e (gcc-4.6: mm: fix unused but set warnings)
> Andi forced VM_BUG_ON(cond) to evaluate cond, even if CONFIG_DEBUG_VM is
> not set :
> 
> #ifdef CONFIG_DEBUG_VM
> #define VM_BUG_ON(cond) BUG_ON(cond)
> #else
> #define VM_BUG_ON(cond) do { (void)(cond); } while (0)
> #endif

Eventually the warnings were disabled in the Makefile.
So it would be reasonable to just revert that patch now, at least
for VM_BUG_ON, if it costs performance.

> 
> So maybe a fix would be to introduce an atomic_read_stable() variant ?
> 
> static inline int atomic_read_stable(const atomic_t *v)
> {
> 	return v->counter;
> }

Seems reasonable too. In fact we usually should have memory barriers
for this anyways which obsolete the volatile.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
