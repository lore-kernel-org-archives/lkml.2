Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1L1KZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 05:25:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:43739 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab1L1KZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 05:25:43 -0500
Message-ID: <1325067910.6632.42.camel@pasglop>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Dec 2011 21:25:10 +1100
In-Reply-To: <CA+55aFyr69__vsorCXKZ7UezvXkCkZaot3=5b5xSHaYBEJ2ZKQ@mail.gmail.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
	 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
	 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
	 <20111220162315.GC10752@google.com>
	 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
	 <20111220202854.GH10752@google.com>
	 <alpine.DEB.2.00.1112210851230.9601@router.home>
	 <20111221170535.GB9213@google.com>
	 <CA+55aFyr69__vsorCXKZ7UezvXkCkZaot3=5b5xSHaYBEJ2ZKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 18:19 -0800, Linus Torvalds wrote:
> On Wed, Dec 21, 2011 at 9:05 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > machines.  (cc'ing arch) Does anyone have better insight here?  How
> > much more expensive are local irq save/restore compared to inc/dec'ing
> > preempt count on various archs?
> 
> I think powerpc does sw irq disable, so it's pretty much the same.

On 64-bit only, but it's probably still better than going for an atomic
op, our atomics tend to be handled at the l2 level and so are sloooow.

 .../...

> So I really suspect that we could just say: "make the irq-safe version
> be the *only* version", and no architecture will really care. Sure, it
> can be more expensive, but it usually isn't. Only when done badly and
> stupidly is it nasty.

Agreed, keep it simple, or we'll just grow more bugs like this one.

Cheers,
Ben.


