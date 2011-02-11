Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1BKAte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:49:34 -0500
Received: from www.tglx.de ([62.245.132.106]:45887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab1BKAtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:49:33 -0500
Date: Fri, 11 Feb 2011 01:49:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
In-Reply-To: <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102110135320.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com> <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6> <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1841416187-1297385361=:31804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1841416187-1297385361=:31804
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 10 Feb 2011, Linus Torvalds wrote:

> On Thu, Feb 10, 2011 at 4:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >  29 files changed, 1353 insertions(+), 899 deletions(-)
> 
> So what is it that adds so many lines? Your description made me think
> "cleanups", not "50% more code"
> 
> (Yeah, yeah, I could look at the code, but I also want to point out
> that this really doesn't look like much of an improvement from a
> high-level standpoint)

Part of it is then namespace cleanup which makes the deprecated
functions wrappers around the new ones. Easy to solve with a script.

More stuff will go way again when the wrappers which I added to
prevent wreckage of arch/* fiddling with irq_desc are gone

The other things are simple inline functions which provide accessors
to state which is intentionally named:

   state_use_accessors, 

For simple reasons:

1) while you type it it should click that you're doing something wrong

2) easy to grep for to find offenderrs. git grep status sucks

There are more wrappers in the core code kernel/irq solely to prevent
using anything which got deprecated.

So yes, it's net more source lines, but not resulting in any binary
bloat.

Thanks,

	tglx



---1463795968-1841416187-1297385361=:31804--
