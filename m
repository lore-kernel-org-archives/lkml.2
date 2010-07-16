Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966119Ab0GPT2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:28:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0GPT2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:28:53 -0400
Date: Fri, 16 Jul 2010 21:28:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716192847.GC7338@basil.fritz.box>
References: <20100714154923.947138065@efficios.com>
 <20100714155804.252253097@efficios.com>
 <4C405078.20707@redhat.com>
 <20100716144927.GA22516@Krystal>
 <4C408D0C.5050709@redhat.com>
 <20100716165855.GA3836@Krystal>
 <4C409CBA.1050709@redhat.com>
 <4C409F62.6030303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C409F62.6030303@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, module loading is already a performance problem; a lot of
> distros load sometimes hundreds of modules on startup, and it's heavily

On startup you don't have many processes.  If there's a problem
it's surely not the fault of vmalloc_sync_all()

BTW in my experience one reason module loading was traditionally slow was
that it did a stop_machine(). I think(?) that has been fixed
at some point. But even with that's it's more an issue on larger
systems.

> I really hope noone ever gets the idea of touching user space from an
> NMI handler, though, and expecting it to work...

It can make sense for a backtrace in a profiler.

In fact perf is nearly doing it I believe, but moves
it to the self IPI handler in most cases.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
