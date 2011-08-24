Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HXSZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:25:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab1HXSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <1314209019.6925.53.camel@twins>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <1314209019.6925.53.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 11:24:40 -0700
Message-ID: <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The patches look good to me, and 50 lines less is always nice too!
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

So I mostly agree, except for the abortion that is the
__ticket_spin_unlock changes. Please just kill that part.

I also personally would have preferred to re-order things a bit. For
example,  I despise

  [PATCH 05/18] x86/ticketlock: make __ticket_spin_lock common

because it is totally pointless. If patch "[PATCH 07/18] x86: add xadd
helper macro" had been before that patch, then the whole "if
(sizeof..)" crap would never have existed. So even though the end
result there looks good (unlike the __ticket_spin_unlock case, which
just *stays* uglier after the whole series), the individual patches
are much uglier than needed, just because they are done in the wrong
order.

So I'd much have preferred that the xadd helper go in first (07/18),
then the patch to make __ticket_spin_lock the same for 32/64 would go
in next (04/18) using that helper, and then they'd just have been
identical automatically.

Instead, there are a few patches that actually make the code uglier
temporarily, only to then be undone later. That seems bogus, when it
looks so simple to fix it.

                       Linus
