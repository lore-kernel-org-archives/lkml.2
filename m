Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966140Ab0GPTa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:30:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34906 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab0GPTaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:30:55 -0400
Date: Fri, 16 Jul 2010 21:30:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
        Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716193053.GD7338@basil.fritz.box>
References: <20100714154923.947138065@efficios.com>
 <20100714155804.252253097@efficios.com>
 <4C405078.20707@redhat.com>
 <20100716144927.GA22516@Krystal>
 <4C408D0C.5050709@redhat.com>
 <20100716165855.GA3836@Krystal>
 <4C409CBA.1050709@redhat.com>
 <4C409F62.6030303@zytor.com>
 <4C40A1BD.4040507@redhat.com>
 <AANLkTik0Svj50Wc-HqP2G7OfXaeZHuJf3ad9_5CGSJ-n@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik0Svj50Wc-HqP2G7OfXaeZHuJf3ad9_5CGSJ-n@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:25:19AM -0700, Linus Torvalds wrote:
> On Fri, Jul 16, 2010 at 11:15 AM, Avi Kivity <avi@redhat.com> wrote:
> >
> > I think the concern here is about an NMI handler's code running in vmalloc
> > space, or is it something else?
> 
> I think the concern was also potentially doing things like backtraces
> etc that may need access to the module data structures (I think the
> ELF headers end up all being in vmalloc space too, for example).
> 
> The whole debugging thing is also an issue. Now, I obviously am not a
> big fan of remote debuggers, but everybody tells me I'm wrong. And
> putting a breakpoint on NMI is certainly not insane if you are doing
> debugging in the first place. So it's not necessarily always about the
> page faults.

We already have infrastructure for kprobes to prevent breakpoints
on critical code (the __kprobes section). In principle kgdb/kdb
could be taught about honoring those too.

That wouldn't help for truly external JTAG debuggers, but I would assume
those generally can (should) handle any contexts anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
