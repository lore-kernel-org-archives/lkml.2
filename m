Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab1CaPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:54:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549Ab1CaPyU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110331040818.GB1255@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <20110331033432.GA434@redhat.com>
 <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com> <20110331040818.GB1255@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 08:53:26 -0700
Message-ID: <AANLkTi=uef63-mHHgHFU14H_Rhytcyc2p34Av6Ms6n3D@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And with your fixed trinity thing, I can now do this:

On Wed, Mar 30, 2011 at 9:08 PM, Dave Jones <davej@redhat.com> wrote:
>
> git clone git://git.codemonkey.org.uk/trinity
> cd trinity ; make
> ./trinity --mode=random -i
>
> let it run for a while, then kill it.   kworker should then go nuts.

I really thought "hey, that reproduced it", because "top" did indeed
show kworker going nuts after a while. And perf did show it doing all
that

                   |          queue_work
                   |          schedule_work
                   |          flush_to_ldisc

that looks like the re-scheduling.

But when I killed trinity, kworker immediately calmed down too.

Which I'd actually expect, since any tty it is using (and making cause
problem) should calm down when it's closed - even if it was stuck
before.

But maybe I haven't triggered just the right condition to actually get
it into some really infinite case.

Regardless, I'll put my money where my mouth is, and try to remove the
crazy re-flush thing.

                                         Linus
