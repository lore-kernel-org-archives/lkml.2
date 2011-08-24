Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab1HXVqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:46:31 -0400
Received: from claw.goop.org ([74.207.240.146]:53628 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab1HXVqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:46:30 -0400
Message-ID: <4E557132.2020109@goop.org>
Date: Wed, 24 Aug 2011 14:46:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 02:36 PM, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Hi all,
>
> Another spin of the cmpxchg/xadd/ticketlock cleanups.
>
> Changes from last post:
>   - reorder all the cmpxchg/xadd patches first
>   - change xadd to return prev rather than implicitly update arg
>   - recast ticketlock cleanup in terms of xadd
>   - drop conversion of unlock to C
>
> This is also available at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/ticketlock-cleanup
>
>  arch/x86/include/asm/atomic.h         |    8 +-
>  arch/x86/include/asm/atomic64_64.h    |    6 +-
>  arch/x86/include/asm/cacheflush.h     |    2 +-
>  arch/x86/include/asm/cmpxchg.h        |  232 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/cmpxchg_32.h     |  128 ++----------------
>  arch/x86/include/asm/cmpxchg_64.h     |  131 -------------------
>  arch/x86/include/asm/rwsem.h          |   15 +--
>  arch/x86/include/asm/spinlock.h       |  110 ++++------------
>  arch/x86/include/asm/spinlock_types.h |   22 +++-
>  arch/x86/include/asm/uv/uv_bau.h      |    6 +-
>  arch/x86/kernel/acpi/boot.c           |   10 +-
>  arch/x86/kernel/cpu/mcheck/mce.c      |    2 +-
>  arch/x86/xen/p2m.c                    |   10 +-
>  13 files changed, 311 insertions(+), 371 deletions(-)
>
> Thanks,
> 	J

Uh, that's 00/12, and ignore the below; that's left over from the
previous posting.

    J

>
> Jeremy Fitzhardinge (18):
>   x86/ticketlock: clean up types and accessors
>   x86/ticketlock: convert spin loop to C
>   x86/ticketlock: Use C for __ticket_spin_unlock
>   x86/ticketlock: make large and small ticket versions of spin_lock the
>     same
>   x86/ticketlock: make __ticket_spin_lock common
>   x86/ticketlock: make __ticket_spin_trylock common
>   x86: add xadd helper macro
>   x86/ticketlock: use xadd helper
>   x86/cmpxchg: linux/alternative.h has LOCK_PREFIX
>   x86/cmpxchg: move 32-bit __cmpxchg_wrong_size to match 64 bit.
>   x86/cmpxchg: move 64-bit set64_bit() to match 32-bit
>   x86/cmpxchg: unify cmpxchg into cmpxchg.h
>   x86: add cmpxchg_flag() variant
>   x86/ticketlocks: use cmpxchg_flag for trylock
>   x86: use cmpxchg_flag() where applicable
>   x86: report xchg/cmpxchg/xadd usage errors consistently
>   x86: add local and sync variants of xadd
>   x86: use xadd helper more widely
>
>  arch/x86/include/asm/atomic.h         |    4 +-
>  arch/x86/include/asm/atomic64_64.h    |    4 +-
>  arch/x86/include/asm/cacheflush.h     |    2 +-
>  arch/x86/include/asm/cmpxchg.h        |  223 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/cmpxchg_32.h     |  128 ++-----------------
>  arch/x86/include/asm/cmpxchg_64.h     |  131 -------------------
>  arch/x86/include/asm/rwsem.h          |   11 +--
>  arch/x86/include/asm/spinlock.h       |  140 +++++++--------------
>  arch/x86/include/asm/spinlock_types.h |   22 +++-
>  arch/x86/include/asm/uv/uv_bau.h      |    4 +-
>  arch/x86/kernel/acpi/boot.c           |   10 +-
>  arch/x86/kernel/cpu/mcheck/mce.c      |    2 +-
>  arch/x86/xen/p2m.c                    |   10 +-
>  13 files changed, 321 insertions(+), 370 deletions(-)
>

