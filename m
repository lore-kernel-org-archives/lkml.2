Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1HXVjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:39:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab1HXVjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <m2pqjud1fz.fsf@firstfloor.org>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
 <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com>
 <m2pqjud1fz.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 14:38:12 -0700
Message-ID: <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com>
Subject: Re: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 1:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Can't we just get rid of the small ticket size code path?
>
> I couldn't benchmark any difference between the two last time
> I tried.

The small locks aren't any faster. They are just smaller.

Many data structures have spinlocks inside of them, and the smaller
spinlock *should* be able to result in smaller data structures.

Of course, that assumes that they have been packed correctly. And they
seldom are ;(

Looking at 'struct task_struct', for example, the spinlocks there
aren't next to each other, and have pointers and 'unsigned int's
around them, so rather than shrinking the data structure, it just
results in holes.

                       Linus
