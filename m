Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab0GORil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:38:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44306 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933910Ab0GORij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:38:39 -0400
Date: Thu, 15 Jul 2010 13:38:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100715173836.GA17376@Krystal>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714203940.GC22096@Krystal> <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com> <20100714222115.GA30122@Krystal> <AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com> <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com> <20100715164450.GC30989@Krystal> <AANLkTik4mdj3h16CU2GUQAQuG4yeAWFuZsqbPC0ra6Id@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik4mdj3h16CU2GUQAQuG4yeAWFuZsqbPC0ra6Id@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:36:33 up 173 days, 20:13,  6 users,  load average: 0.12, 0.06,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Thu, Jul 15, 2010 at 9:44 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > The first thing that strikes me is that we could be interrupted by a standard
> > interrupt on top of the iret instruction below.
> 
> No, that can never happen.
> 
> Why? Simple: regular interrupts aren't ever enabled in eflags. So the
> only kinds of traps we can get are NMI's (that don't follow the normal
> rules), and exceptions.

Ah, you're right, since NMIs are an intr gate, IF is disabled in the EFLAGS all
along.

> 
> Of course, if there is some trap that re-enables interrupts even if
> the trap happened in an interrupt-disabled region, then that would
> change things, but that would be a bad bug regardless (and totally
> independently of any NMI issues). So in that sense it's a "could
> happen", but it's something that would be a totally separate bug.

Yep, this kind of scenario would therefore be a bug that does not belong to the
specific realm of nmis.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
