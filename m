Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2ADQIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:08:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52371 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2ADQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:08:11 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1201040906090.27157@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com> <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home>
 <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com>
 <alpine.DEB.2.00.1112231031001.3482@router.home> <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
 <alpine.DEB.2.00.1201040906090.27157@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Jan 2012 08:07:48 -0800
X-Google-Sender-Auth: KeBvIwd8rII0WLW6IjQtKUpble0
Message-ID: <CA+55aFwOp1UbeexKSdQC6YwrA9pS-J5qdqs-68=H8T1GS4Nr1A@mail.gmail.com>
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

On Wed, Jan 4, 2012 at 7:30 AM, Christoph Lameter <cl@linux.com> wrote:
>
> As mentioned before the main point of the use of these operations (in the
> form of __this_cpu_op_return) when the cpu is pinned is to reduce the
> number of instructions. __this_cpu_add_return allows replacing ~ 5
> instructions with one.

And that's fine if it's something really core, and something *so*
important that you can tell the difference between one instruction and
three.

Which isn't the case here. In fact, on many (most?) x86
microarchitectures xadd is actually slower than a regular
add-from-memory-and-store - the big advantage of it is that with the
"lock" prefix you do get special atomicity guarantees, and some
algorithms (is semaphores) do want to know the value of the add
atomically in order to know if there were other things going on.

The thing is, I care about maintainability and not having
cross-architecture problems etc. And right now many of the cpulocal
things are *much* more of a maintainability headache than they are
worth.

                     Linus
