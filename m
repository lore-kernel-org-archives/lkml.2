Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0ITTZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:25:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab0ITTZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:25:29 -0400
Subject: Re: [RFC][PATCH 2/2] kernel: extract thread types from
 task_struct::flags
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Avi Kivity <avi@redhat.com>
In-Reply-To: <20100920121446.18fb3a65.akpm@linux-foundation.org>
References: <20100920151334.569154707@chello.nl>
	 <20100920151839.414197086@chello.nl>
	 <20100920121446.18fb3a65.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 21:25:16 +0200
Message-ID: <1285010716.2275.797.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 12:14 -0700, Andrew Morton wrote:
> On Mon, 20 Sep 2010 17:13:36 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Free up a few more PF_flags by moving thread types out to their own variable.
> > 
> > Initially I compressed the types into less bits inside task_struct::flags, but
> > Thomas suggested I move them to their own field.
> > 
> 
> There doesn't seem to be a huge point to all this, but I guess there's
> some sense in separating "what type of thread this is" from "attributes
> of this thread".  Maybe.  At the expense of a larger task_struct. 

Yeah, with the PF_FLUSHER and PF_ALIGNWARN things removed we again have
2 bits free in flags.

And that's the amount -rt consumes (it adds 2 more: I'm a $FOO thread,
flags).

But having looked at it, I came up with the compress I'm a $FOO thread,
idea. Which would free up a few more bits for future use.

At that time Thomas suggested I move it into a separate field, and then
Linus said, don't compact the types, simply transfer the bits we have.

Anyway, it was all very much RFC.. and comments I got :-)

So can you agree with Linus' proposal of simply moving all type like
bits over to a new word, or would you rather see the linear type field
with an extra helper; possibly part of the existing ->flags field?


