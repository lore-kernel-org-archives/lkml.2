Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935050Ab0GOXsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:48:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51724 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933992Ab0GOXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:48:22 -0400
Date: Fri, 16 Jul 2010 01:48:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100715234821.GB25420@one.firstfloor.org>
References: <AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com> <20100715183153.GA9276@Krystal> <AANLkTilfXUtQznSzOmO9ecoaviIt62Hv6jdUOMSRLdrF@mail.gmail.com> <AANLkTimAn0uMpeYKctO0qxM6nwbfev3RHARLZIbf991k@mail.gmail.com> <20100715220117.GA1499@Krystal> <AANLkTinL3S3iMSoP0fb6bxn9IY62OmytBtbqCKy9CZk2@mail.gmail.com> <AANLkTinOTwnSNgwX7PnalhzwWMjwie0Xk_Lnrn_0bLzz@mail.gmail.com> <20100715225844.GA25420@one.firstfloor.org> <4C3F97A5.4020107@zytor.com> <AANLkTinLg2Xx0x6jrKkK_em6dA0cEfujnV3XIZ6I10jI@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLg2Xx0x6jrKkK_em6dA0cEfujnV3XIZ6I10jI@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 04:23:20PM -0700, Linus Torvalds wrote:
> On Thu, Jul 15, 2010 at 4:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 07/15/2010 03:58 PM, Andi Kleen wrote:
> >>> Why do we force IST use for NMI, btw? Maybe we shouldn't, and just use
> >>> the normal kernel stack mechanisms?
> >>
> >> If you don't use IST the SYSCALL entry is racy during the window
> >> when RSP is not set up yet (same for MCE etc.)
> >>
> >
> > Right, the kernel stack is not ready.
> 
> Well, it may not be ready for the _current_ NMI handler, but if we're
> going to do a stack switch in sw on NMI anyway... ?

The CPU written initial stack frame would still go on the wrong stack.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
