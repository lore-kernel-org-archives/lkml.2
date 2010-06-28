Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0F1PQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:16:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752905Ab0F1PQU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <alpine.LFD.2.00.1006252140410.18683@localhost.localdomain>
	<235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Date: Mon, 28 Jun 2010 08:15:26 -0700
Message-ID: <AANLkTilaOOlzS2cJXCJF8Qn_cqjr7ywUv9RUTSsK9pf3@mail.gmail.com>
Subject: Re: Q: sys_futex() && timespec_valid()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 1:04 PM, Ulrich Drepper <drepper@redhat.com> wrote:
>
> The tv_sec in timespec is of type time_t and for absolute time values the same
> semantics as for naked time_t values applies.  The absolute time is
>
>  epoch + tv_sec + tv_nsec / 1000000000
>
> If tv_sec is negative these are values before epoch.

That's a totally bogus argument.

Ulrich - you're wrong. Go away.

According to that same argument, negative tv_nsec values (or values
above a billion) would also be ok, since that expression would also
give some random value for time. So clearly, the fact that the
expression gives some random value does _not_ in any way mean that we
should accept that random value. Your "argument" isn't an argument at
all, it's just worthless random noise.

The fact is, a negative tv_sec could indeed mean "before the epoch",
but it could equally well (and way more likely) mean "totally buggy
application" or "overflow of a very large positive value".

In the end, it's quite simple: the kernel doesn't accept invalid
timevals. And negative tv_secs are invalid. It's that simple. If
somebody gives the kernel a timeout from before the epoch, that
somebody is being a total idiot. We know it's not a valid absolute
timeout, since there's no way somebody is "waiting" for something that
happened in the sixties.

Yeah, yeah, maybe you're waiting for flower power and free sex. Good
for you. But if you are, don't ask the Linux kernel to wait with you.
Ok?

                           Linus
