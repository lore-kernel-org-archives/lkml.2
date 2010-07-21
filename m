Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab0GUOXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:23:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab0GUOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:23:14 -0400
Date: Wed, 21 Jul 2010 11:22:51 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
Message-ID: <20100721142251.GB17631@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100720041938.GA28533@infradead.org>
 <20100720063805.GA19375@linux.vnet.ibm.com>
 <20100720210358.GA17631@ghostprotocols.net>
 <20100721024200.GC19375@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721024200.GC19375@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 21, 2010 at 08:12:00AM +0530, Srikar Dronamraju escreveu:
> > Em Tue, Jul 20, 2010 at 12:08:05PM +0530, Srikar Dronamraju escreveu:
> > > > A minor note on perf probe -S output:  This seems to include a lot of
> > > > T.456 or similar labels, which from my recollection are gcc internal
> > > > things.  It would be good to filter those out as they aren't quite
> > > > useful and just fill up the list.

> > > Okay .. will take a look. Offhand I dont know about the T.456
> > > labels, so I will google and see if its possible for us to identify if
> > > its a t.456 label. However if you know how to identify a t456 label
> > > from normal functions, then it would be great.

> > We may have some hint on the symtab, having access to one of those files
> > to look at its symtab will help.
> 
> I tried searching for t.456 gcc labels in google. I dont think I found
> anything interesting. Are we looking at not listing symbols that end
> with @plt? Can you please list an example t.456 label. Also any pointers to
> where I can find more information on the same would be very useful.

I guess this is what he means:

[acme@doppio linux-2.6-tip]$ grep ' [TtWw] .\+\.' /proc/kallsyms | head -5
ffffffff81000646 t trace_kmalloc.clone.0
ffffffff810006ac t create_dev.clone.0
ffffffff81006ae4 t test_ti_thread_flag.clone.0
ffffffff8100a388 t trace_power_start.clone.0
ffffffff8100ad8d t user_regset_copyin.clone.0
[acme@doppio linux-2.6-tip]$ readelf -s ../build/v2.6.35-rc5-tip+/vmlinux | grep ' FUNC .\+\.' | head -5
   165: ffffffff81000646   101 FUNC    LOCAL  DEFAULT    1 trace_kmalloc.clone.0
   180: ffffffff810006ac    44 FUNC    LOCAL  DEFAULT    1 create_dev.clone.0
   438: ffffffff81006ae4    22 FUNC    LOCAL  DEFAULT    1 test_ti_thread_flag.clone
   510: ffffffff81ae5c40   136 FUNC    LOCAL  DEFAULT   22 e820_end_pfn.clone.0
   750: ffffffff8100a388    65 FUNC    LOCAL  DEFAULT    1 trace_power_start.clone.0
[acme@doppio linux-2.6-tip]$

Or at least those are the ones with dots here.

- Arnaldo
