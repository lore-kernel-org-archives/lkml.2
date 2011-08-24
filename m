Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1HXVnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:43:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60633 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1HXVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:43:40 -0400
Date: Wed, 24 Aug 2011 23:43:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
Message-ID: <20110824214334.GS25996@one.firstfloor.org>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com> <m2pqjud1fz.fsf@firstfloor.org> <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:38:12PM -0700, Linus Torvalds wrote:
> On Wed, Aug 24, 2011 at 1:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Can't we just get rid of the small ticket size code path?
> >
> > I couldn't benchmark any difference between the two last time
> > I tried.
> 
> The small locks aren't any faster. They are just smaller.

Are you sure? 

AFAIK it's always

typedef struct arch_spinlock {
        unsigned int slock;
} arch_spinlock_t;

-Andi
