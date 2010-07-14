Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0GNRIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:08:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39390 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156Ab0GNRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:08:07 -0400
Date: Wed, 14 Jul 2010 13:08:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20100714170805.GC4955@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714170606.GA22373@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714170606.GA22373@basil.fritz.box>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:06:35 up 172 days, 19:43,  8 users,  load average: 0.05, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > x86_32 cannot use vmalloc_sync_all() to sychronize the TLBs from every
> > processes because the vmalloc area is mapped in a different address space for
> 
> That doesn't make sense. vmalloc_all_sync() should work on 32bit too.
> It just needs to walk all processes and fix up every page table.

Yeah, I've been taken aback when Tejun told me that a few moments ago. I
initially thought that vmalloc_sync_all() synchronized all page mappings of all
processes on x86_32. But apparently that does not seem to be the case. I'm
adding him in CC.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
