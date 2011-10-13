Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1JMKyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:54:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:40300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1JMKyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:54:32 -0400
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 13 Oct 2011 12:54:05 +0200
In-Reply-To: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318503245.24856.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 17:51 -0700, Jeremy Fitzhardinge wrote:
> 
> This is is all unnecessary complication if you're not using PV ticket
> locks, it also uses the jump-label machinery to use the standard
> "add"-based unlock in the non-PV case.
> 
>         if (TICKET_SLOWPATH_FLAG &&
>             unlikely(static_branch(&paravirt_ticketlocks_enabled))) {
>                 arch_spinlock_t prev;
> 
>                 prev = *lock;
>                 add_smp(&lock->tickets.head, TICKET_LOCK_INC);
> 
>                 /* add_smp() is a full mb() */
> 
>                 if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
>                         __ticket_unlock_slowpath(lock, prev);
>         } else
>                 __add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX); 

Not that I mind the jump_label usage, but didn't paravirt have an
existing alternative() thingy to do things like this? Or is the
alternative() stuff not flexible enough to express this?
