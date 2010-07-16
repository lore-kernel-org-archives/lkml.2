Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab0GPSok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:44:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758790Ab0GPSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <4C40A4E8.5090605@redhat.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.252253097@efficios.com>
	<4C405078.20707@redhat.com>
	<20100716144927.GA22516@Krystal>
	<4C408D0C.5050709@redhat.com>
	<20100716165855.GA3836@Krystal>
	<4C409CBA.1050709@redhat.com>
	<4C409F62.6030303@zytor.com>
	<4C40A1BD.4040507@redhat.com>
	<4C40A227.6000207@zytor.com>
	<4C40A4E8.5090605@redhat.com>
Date: Fri, 16 Jul 2010 11:37:05 -0700
Message-ID: <AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:28 AM, Avi Kivity <avi@redhat.com> wrote:
>
> Use kmalloc and percpu pointers, it's not that onerous.

What people don't seem to understand is that WE SHOULD NOT MAKE NMI
FORCE US TO DO "STRANGE" CODE IN CODE-PATHS THAT HAVE NOTHING
WHAT-SO-EVER TO DO WITH NMI.

I'm shouting, because this point seems to have been continually
missed. It was missed in the original patches, and it's been missed in
the discussions.

Non-NMI code should simply never have to even _think_ about NMI's. Why
should it? It should just do whatever comes "natural" within its own
context.

This is why I've been pushing for the "let's just fix NMI" approach.
Not adding random hacks to other code sequences that have nothing
what-so-ever to do with NMI.

So don't add NMI code to the page fault code. Not to the debug code,
or to the module loading code. Don't say "use special allocations
because the NMI code may care about these particular data structures".
Because that way lies crap and unmaintainability.

                      Linus
