Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1CYVwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:52:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62769 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1CYVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ichF1g2iABLagm2Yzkzlm/cu5pZAXz7vX1qM4mti6ib5VrbhbtLNaVqMxXKi2YGoxT
         4CMJoAi/6n+hbLyFrr4eIKe0P4b3HarstVUDO+U/jq+uYL5/3YAXnq9h7h4xYe8U208x
         ChKbeKTlaSzX+nEbsfKH3rZS7bS7podNGrGb0=
MIME-Version: 1.0
Date: Fri, 25 Mar 2011 21:52:28 +0000
Message-ID: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
Subject: advice sought: practicality of SMP cache coherency implemented in
 assembler (and a hardware detect line)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

folks, hi,

i've hit an unusual situation where i'm responsible for evaluating and
setting the general specification of a new multi-core processor, but
it's based around a RISC core that cannot be significantly changed
without going through some very expensive verification procedures.  in
the discussions, the engineer responsible for it said that modifying
the cache is prohibitively expensive and time-consuming, but that one
possible workaround would be to have a hardware detection mechanism of
cache-write conflicts, to generate a software interrupt that you would
then simply run some assembly code to flush the 1st-level cache line.
the hardware detection mechanism could be tacked on, would be very
quick and easy to implement, and would generate interrupts to the
specific processor whose data required flushing.

now, whilst it tickles my hardware hacker fancy like anything, because
i feel that this could be used for many other purposes such as
implementing spin-locks, i have some concerns about the performance
implications that i'm not qualified or experienced enough to say one
way or the other if it's a stonking good idea or just outright mad.

so, bearing in mind that sensible answers will likely result in offers
of a consulting contract to actually *implement* the software /
assembly code for the linux kernel modifications required (yes, linux
is already available for this RISC processor type - but only in
single-core), i would greatly appreciate some help in getting answers
to these questions:

* is this even a good idea? does it "fly"?

* if it does work, at what point do the number of cores involved just
make it... completely impractical?  over 2?  over 4?  8? 16?

* i believe the cache lines in the 1st level data cache are 8 bytes
(and the AMBA / AXI bus on each is 64-bit wide) - is that reasonable?

* does anyone know of any other processors that have actually
implemented software-driven cache coherency, esp. ones with linux
kernel running on them, and if so, how does it do?

much appreciated considerate and informative answers - i must
apologise that i will be immediately unsubscribing from linux-kernel
list, and re-subscribing again in the near future, but will be
watching responses via web-based list archives: the number of messages
on lkml is too high to do otherwise.  also for those of you who
remember it: whilst it was fun in a scary kind of way, if would be
nice if this didn't turn into the free-for-all whopper-thread that
occurred back in 2005 or so - this multi-core processor is going to be
based around an existing proven 20-year-old well-established RISC core
that has been running linux for over a decade, it just has never been
put into an SMP arrangement before and we're on rather short
timescales to get it done.

l.
