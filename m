Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0GNS4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:56:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40738 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0GNS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:56:24 -0400
Date: Wed, 14 Jul 2010 20:56:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
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
        Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 0/2] x86: NMI-safe trap handlers
Message-ID: <20100714185617.GB22373@basil.fritz.box>
References: <20100714154923.947138065@efficios.com>
 <20100714170606.GA22373@basil.fritz.box>
 <20100714170805.GC4955@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714170805.GC4955@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 01:08:05PM -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > > x86_32 cannot use vmalloc_sync_all() to sychronize the TLBs from every
> > > processes because the vmalloc area is mapped in a different address space for
> > 
> > That doesn't make sense. vmalloc_all_sync() should work on 32bit too.
> > It just needs to walk all processes and fix up every page table.
> 
> Yeah, I've been taken aback when Tejun told me that a few moments ago. I
> initially thought that vmalloc_sync_all() synchronized all page mappings of all
> processes on x86_32. But apparently that does not seem to be the case. I'm
> adding him in CC.

Well it worked when it was originally written. That was for the case
of a NMI handler in a module. If it doesn't work fix it. I don't 
think the NMI-safe fault is really needed with it.

-Andi
