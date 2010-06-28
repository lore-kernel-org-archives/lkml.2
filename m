Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0F1OBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab0F1OBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:01:12 -0400
Date: Mon, 28 Jun 2010 15:58:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: Q: sys_futex() && timespec_valid()
Message-ID: <20100628135825.GA17681@redhat.com>
References: <4C2506C3.2000301@us.ibm.com> <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Ulrich Drepper wrote:
>
> ----- "Darren Hart" <dvhltc@us.ibm.com> wrote:
> > Unless there is some good reason to object to breaking the API that I
> > am  missing, I don't mind changing it to -ETIMEDOUT (although -EINVAL
> > seems more intuitive to me).
>
> It's only not intuitive because Oleg misrepresented or at least didn't
> describe the issue.
> ...
> It pure and simply
> a bug fix.

Because personally I disagree that sys_futex()->timespec_valid() is buggy.

I repeated this many times during the previous discussion. I didn't even
try to judge if it is really right or not, because my opinion doesn't matter
at all here.

But it is unfair (imho) to state this code is buggy. The code is correct
even if it does not match your expectations, it works as expected/designed.
And, sys_futex() does this since 2006 iirc.


Honestly, it looks a bit strange to me that you blame the correct code,
and at the same time you ignore the test-case which hangs because the
kernel returns -EFAULT saying that this is the caller's problem.

Oleg.

