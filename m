Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1FDWFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 18:05:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48044 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1FDWFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 18:05:15 -0400
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arne Jansen <lists@die-jansens.de>, Ingo Molnar <mingo@elte.hu>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTikXU5FFgY4=8MEdRjvt4gbpxm7J5g@mail.gmail.com>
References: <20110405152729.232781355@chello.nl>
	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
	 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
	 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
	 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
	 <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de>
	 <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
	 <4DE8DC28.30709@die-jansens.de>
	 <BANLkTikXU5FFgY4=8MEdRjvt4gbpxm7J5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Jun 2011 00:08:43 +0200
Message-ID: <1307225323.2497.730.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 06:29 +0900, Linus Torvalds wrote:
> On Fri, Jun 3, 2011 at 10:05 PM, Arne Jansen <lists@die-jansens.de> wrote:
> >
> > No change. Also git bisect quite clearly points to
> > 0122ec5b02f766c and ab2515c4b98f7bc4, both are older than
> > b1c43f82c5aa2654 mentioned in the other thread.
> 
> Ok, I haven't heard anything further on this. Ingo? Peter?

I'm a bit stumped, and not being able to reproduce at all :/

> We're getting to the point where we just need to revert the thing,
> since I'm not getting the feeling that there are any fixes
> forthcoming, and I'd like -rc2 to not have this kind of bisected bug.

Agreed.

> Ingo? Those two commits no longer revert cleanly, presumably due to
> other changes in the area (but I didn't check). Can you do a patch to
> do the reverts, and then you can try to re-do the thing later once you
> figure out what's wrong.

Yeah, that wants a whole lot of reverting, from the offending commit up
to and including 317f394160e9beb97d19a84c39b7e5eb3d7815a8.

