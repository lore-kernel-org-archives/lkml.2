Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab0GOOfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:35:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43755 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab0GOOfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:35:21 -0400
Date: Thu, 15 Jul 2010 16:35:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100715143518.GA18038@basil.fritz.box>
References: <20100714170617.GB4955@Krystal>
 <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
 <20100714184642.GA9728@elte.hu>
 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
 <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
 <20100714195617.GC22373@basil.fritz.box>
 <20100714200552.GA22096@Krystal>
 <20100714223116.GB14533@nowhere>
 <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
 <20100715141118.GA6417@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715141118.GA6417@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But then how did the previous tasks get this new mapping? You said
> we don't walk through every process page tables for vmalloc.

No because those are always shared for the kernel and have been
filled in for init_mm.

Also most updates only update the lower tables anyways, top level
updates are extremly rare. In fact on PAE36 they should only happen
at most once, if at all, and most likely at early boot anyways
where you only  have a single task. 

On x86-64 they will only happen once every 512GB of vmalloc. 
So for most systems also at most once at early boot.
> 
> I would understand this race if we were to walk on every processes page
> tables and add the new mapping on them, but we missed one new task that
> forked or so, because we didn't lock (or just rcu).

The new task will always get a copy of the reference init_mm, which
was already updated.

-Andi
