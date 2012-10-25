Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935685Ab2JYNjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:39:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:52463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2JYNjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:39:05 -0400
Message-ID: <1351172289.12171.4.camel@twins>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 15:38:09 +0200
In-Reply-To: <CAMuHMdXUg-gzTD1NyBH=cfreg8vqN-dDpVGiEkj_pkS-4a1odg@mail.gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CAMuHMdXUg-gzTD1NyBH=cfreg8vqN-dDpVGiEkj_pkS-4a1odg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 07:21 +0200, Geert Uytterhoeven wrote:
> On Wed, Oct 24, 2012 at 11:53 PM, Juri Lelli <juri.lelli@gmail.com> wrote:
> > +#ifdef __SIZEOF_INT128__ /* gcc-4.6+ */
> > +       unsigned __int128 val;
> > +#endif
> 
> So the definition of val depends on (gcc) __SIZEOF_INT128__...
> 
> > +/*
> > + * Make usage of __int128 dependent on arch code so they can
> > + * judge if gcc is doing the right thing for them and can over-ride
> > + * any funnies.
> > + */
> > +
> > +#ifndef ARCH_HAS_INT128
> 
> ... but all generic users depend on (Kconfig) ARCH_HAS_INT128?

Ah, you're saying both should depend on the same thing. I fear there's a
chicken-egg problem in the code as it is now, the asm/math128.h thing
needs the data structure but is also the one setting ARCH_HAS_INT128.

So its not Kconfig.

> How can Kconfig know if gcc supports this?

It cannot, its per the asm/math128.h header to opt-in on using it. This
so archs can make sure gcc doesn't generate broken code or relies on
libgcc for its __int128 implementation.

Now, if we do as Linus suggests and push the data structure definition
into a separate header we could possibly avoid this.
