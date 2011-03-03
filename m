Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1CCPyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:54:03 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46457 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753982Ab1CCPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:54:01 -0500
Date: Thu, 3 Mar 2011 10:53:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: stop machine text poke should issue sync core
Message-ID: <20110303155357.GA1590@Krystal>
References: <20110228152405.GA7064@Krystal> <4D6F30DA.2070907@zytor.com> <4D6F3D1B.3030005@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6F3D1B.3030005@hitachi.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:53:40 up 99 days, 20:56,  4 users,  load average: 0.03, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (masami.hiramatsu.pt@hitachi.com) wrote:
> (2011/03/03 15:10), H. Peter Anvin wrote:
> > On 02/28/2011 07:24 AM, Mathieu Desnoyers wrote:
> >>
> >> Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
> >> ===================================================================
> >> --- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c
> >> +++ linux-2.6-lttng/arch/x86/kernel/alternative.c
> >> @@ -612,6 +612,12 @@ static int __kprobes stop_machine_text_p
> >>  
> >>  	flush_icache_range((unsigned long)tpp->addr,
> >>  			   (unsigned long)tpp->addr + tpp->len);
> >> +	/*
> >> +	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
> >> +	 * that a core serializing instruction such as "cpuid" should be
> >> +	 * executed on _each_ core before the new instruction is made visible.
> >> +	 */
> >> +	sync_core();
> >>  	return 0;
> >>  }
> >>  
> > 
> > Isn't this executed from an IPI handler, which will return with IRET (a
> > serializing instruction) anyway?
> 
> No, now stop_machine uses per-cpu workqueue, so that handler will be
> executed from worker threads. There is no iret anymore.
> 
> BTW, Mathieu, since the latest kernel has batch-text_poke_smp, this patch
> needs to be updated.

OK, I'll update the patch and respin it.

Thanks,

Mathieu

> 
> Thank you,
> 
> -- 
> Masami HIRAMATSU
> 2nd Dept. Linux Technology Center
> Hitachi, Ltd., Systems Development Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
