Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1JQScI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:32:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34807 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:32:07 -0400
MIME-Version: 1.0
In-Reply-To: <1318874090.4172.84.camel@twins>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <1318847658.6594.40.camel@twins> <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
 <1318874090.4172.84.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Oct 2011 11:31:46 -0700
X-Google-Sender-Auth: l7jvbExrmUFL860zZMWJ1Y8QJaY
Message-ID: <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 10:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> I could of course propose this... but I really won't since I'm half
> retching by now.. ;-)

Wow. Is this "ugly and fragile code week" and I just didn't get the memo?

I do wonder if we might not fix the problem by just taking the
*existing* lock in the right order?

IOW, how nasty would be it be to make "scheduler_tick()" just get the
cputimer->lock outside or rq->lock?

Sure, we'd hold that lock *much* longer than we need, but how much do
we care? Is that a lock that gets contention? It migth be the simple
solution for now - I *would* like to get 3.1 out..

                        Linus
