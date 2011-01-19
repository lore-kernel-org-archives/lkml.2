Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1ASPEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:04:54 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:51316 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab1ASPEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:04:53 -0500
Subject: Re: [PATCH] Switch proc interfaces in kernel/ to %pK
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <4D363E92.2020602@hitachi.com>
References: <1295391078.1831.21.camel@dan>  <4D363E92.2020602@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 10:04:51 -0500
Message-ID: <1295449491.1806.13.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 10:29 +0900, Masami Hiramatsu wrote:
> (2011/01/19 7:51), Dan Rosenberg wrote:
> > Switch users of %p in /proc interfaces in kernel/ to %pK, to allow
> > configuring the level of exposure of kernel pointers via the
> > kptr_restrict sysctl.
> 
> This report_probe interface is at /sys/kernel/debug/kprobes/list.
> Is that policy applied to debugfs interface (for debug) too?
> # in that case, you might update ftrace and perf tracing interfaces...
> 

There's no reason to not update ftrace and perf too, since I'd assume no
one is using debugging interfaces without root privileges anyway.  I'll
add them to my list.

> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index 7798181..2437ca4 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -2021,11 +2021,11 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
> >  		kprobe_type = "k";
> >  
> >  	if (sym)
> > -		seq_printf(pi, "%p  %s  %s+0x%x  %s ",
> > +		seq_printf(pi, "%pK  %s  %s+0x%x  %s ",
> >  			p->addr, kprobe_type, sym, offset,
> >  			(modname ? modname : " "));
> >  	else
> > -		seq_printf(pi, "%p  %s  %p ",
> > +		seq_printf(pi, "%pK  %s  %pK ",
> >  			p->addr, kprobe_type, p->addr);
> >  
> >  	if (!pp)
> 
> 
> -- 
> Masami HIRAMATSU
> 2nd Dept. Linux Technology Center
> Hitachi, Ltd., Systems Development Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com


