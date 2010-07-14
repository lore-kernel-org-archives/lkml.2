Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0GNVpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:45:11 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34657 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0GNVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:45:09 -0400
Date: Wed, 14 Jul 2010 22:45:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
In-Reply-To: <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1007142240560.11778@eddie.linux-mips.org>
References: <20100714154923.947138065@efficios.com>        <20100714155804.049012415@efficios.com>        <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>        <20100714170617.GB4955@Krystal>        <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
        <20100714203940.GC22096@Krystal> <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Linus Torvalds wrote:

> No. As mentioned, there is no such counter in real hardware either.

 There is a 1-bit counter or actually a latch.

> Look at what happens for the not-nested case:
> 
>  - NMI1 triggers. The CPU takes a fault, and runs the NMI handler with
> NMI's disabled

 Correct.

>  - NMI2 triggers. Nothing happens, the NMI's are disabled.

 The NMI latch records the second NMI.  Note this is edge-sensitive like 
the NMI line itself.

>  - NMI3 triggers. Again, nothing happens, the NMI's are still disabled

 Correct.

>  - the NMI handler returns.
> 
>  - What happens now?

 NMI2 latched above causes the NMI handler to be invoked as the next 
instruction after IRET.  The latch is cleared as the interrupt is taken.

> How many NMI interrupts do you get? ONE. Exactly like my "emulate it
> in software" approach. The hardware doesn't have any counters for
> pending NMI's either. Why should the software emulation have them?

 Two. :)

  Maciej
