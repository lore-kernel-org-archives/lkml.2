Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab0GNWbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:31:17 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:42098 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0GNWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:31:12 -0400
Date: Wed, 14 Jul 2010 23:31:10 +0100 (BST)
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
In-Reply-To: <AANLkTilIkE_88jn-DwoXB462wtNzJZSFI9B_x-Sh53EG@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1007142313460.11778@eddie.linux-mips.org>
References: <20100714154923.947138065@efficios.com>        <20100714155804.049012415@efficios.com>        <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>        <20100714170617.GB4955@Krystal>        <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
        <20100714203940.GC22096@Krystal>        <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>        <alpine.LFD.2.00.1007142240560.11778@eddie.linux-mips.org> <AANLkTilIkE_88jn-DwoXB462wtNzJZSFI9B_x-Sh53EG@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Linus Torvalds wrote:

> You just count differently. I don't count the first one (the "real"
> NMI). That obviously happens. So I only count how many interrupts we
> need to fake. That's my "one". That's the one that happens as a result
> of the fault that we take on the iret in the emulated model.

 Ah, I see -- so we are on the same page after all.

> (Yeah, yeah, you can call it a "one-bit counter", but I don't think
> that's a counter. It's just a bit of information).

 Hardware has something like a strapped-high D flip-flop (NMI goes to the 
clock input) with an extra reset input I presume -- this dates back to 
8086 when the transistor count mattered with accuracy higher than 1e6. ;)

  Maciej
