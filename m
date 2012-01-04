Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2ADXKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:10:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48507 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2ADXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1201041046290.29775@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com> <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home>
 <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com>
 <alpine.DEB.2.00.1112231031001.3482@router.home> <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
 <alpine.DEB.2.00.1201040906090.27157@router.home> <CA+55aFwOp1UbeexKSdQC6YwrA9pS-J5qdqs-68=H8T1GS4Nr1A@mail.gmail.com>
 <alpine.DEB.2.00.1201041046290.29775@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Jan 2012 15:10:22 -0800
X-Google-Sender-Auth: wBIbTr6UCm31hkimR79L9K1piyA
Message-ID: <CA+55aFwgN4QGowU1+5NO0QWr4nT9KDyk8opiVgzmULJG-2eKzg@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 9:00 AM, Christoph Lameter <cl@linux.com> wrote:
>
> xadd is 3 cycles. add is one cycle.

On some uarchs. On new uarchs it can be a single cycle, I think, and
on some uarchs it will even be microcoded and/or only go in one pipe
because it has that odd behavior that it writes both to memory and a
register, and thus doesn't fit the normal fastpaths.

The point is, xadd isn't actually any faster than just doing the
regular "add and read". It's *slower*.

There really isn't ever any reason to use xadd on percpu variables.
That's my point. You claimed that there was a performance advantage.
There really isn't.

So why are you still arguing?

                           Linus
