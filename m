Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0HVVDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 17:03:48 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58799 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752521Ab0HVVDq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 17:03:46 -0400
Date: Sun, 22 Aug 2010 17:03:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
        Jamie Lokier <jamie@shareable.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH for -tip 1/2] kernel.h: add
	MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2
Message-ID: <20100822210342.GA21755@Krystal>
References: <20100821141750.770348530@efficios.com> <20100821142215.023431313@efficios.com> <20100822192705.GE1771@one.firstfloor.org> <20100822193819.GA23299@Krystal> <AANLkTingCD78PYQN1f-0jNQYAU1v6W5RXHe73FnpmqDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTingCD78PYQN1f-0jNQYAU1v6W5RXHe73FnpmqDA@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:03:25 up 211 days, 23:40,  3 users,  load average: 0.13, 0.13,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anca Emanuel (anca.emanuel@gmail.com) wrote:
> I think about some test at the last bit if it is on, the number is not
> a power of 2

Can you give an example, along with the types you have in mind ?

Thanks,

Mathieu

> 
> On Sun, Aug 22, 2010 at 10:38 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> >> > +/* Force a compilation error if condition is constant and not a power of 2 */
> >> > +#define MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2(n)               \
> >> > +   MAYBE_BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
> >>
> >> Looks super-ugly. IMHO just writing MAYBE_BUILD_BUG_ON(!n || n & (n - 1)) directly
> >> would be clear enough. If you really think that's unclear define a generic
> >> is_power_of_two() macro.
> >
> > There is already a is_power_of_two macro in log2.h, but I fear it might
> > incorrectly interact with "MAYBE_BUILD_BUG_ON" (for some reason passing the
> > constant result of a static inline is not treated as a constant by the macro,
> > and thus it always "passes" the test).
> >
> > So if everyone object to this new macro, I'd be tempted to just go with your
> > suggestion. However the fact that we already have BUILD_BUG_ON_NOT_POWER_OF_2(n)
> > made me think that some people prefer to have it done as a macro.
> >
> > Other opinions ?
> >
> > Thanks,
> >
> > Mathieu
> >
> >
> > --
> > Mathieu Desnoyers
> > Operating System Efficiency R&D Consultant
> > EfficiOS Inc.
> > http://www.efficios.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
