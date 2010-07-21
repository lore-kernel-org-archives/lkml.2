Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0GUPue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:50:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0GUPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:50:32 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=plBTy1s6OugA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=gkG9jDavsHGBNX9Oht8A:9 a=f66oFkE-BBrqE5VUN-_79MeJN9AA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20100721142251.GB17631@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100720041938.GA28533@infradead.org>
	 <20100720063805.GA19375@linux.vnet.ibm.com>
	 <20100720210358.GA17631@ghostprotocols.net>
	 <20100721024200.GC19375@linux.vnet.ibm.com>
	 <20100721142251.GB17631@ghostprotocols.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Jul 2010 11:50:29 -0400
Message-ID: <1279727429.4818.72.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 11:22 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 21, 2010 at 08:12:00AM +0530, Srikar Dronamraju escreveu:

> I guess this is what he means:
> 
> [acme@doppio linux-2.6-tip]$ grep ' [TtWw] .\+\.' /proc/kallsyms | head -5
> ffffffff81000646 t trace_kmalloc.clone.0
> ffffffff810006ac t create_dev.clone.0
> ffffffff81006ae4 t test_ti_thread_flag.clone.0
> ffffffff8100a388 t trace_power_start.clone.0
> ffffffff8100ad8d t user_regset_copyin.clone.0
> [acme@doppio linux-2.6-tip]$ readelf -s ../build/v2.6.35-rc5-tip+/vmlinux | grep ' FUNC .\+\.' | head -5
>    165: ffffffff81000646   101 FUNC    LOCAL  DEFAULT    1 trace_kmalloc.clone.0
>    180: ffffffff810006ac    44 FUNC    LOCAL  DEFAULT    1 create_dev.clone.0
>    438: ffffffff81006ae4    22 FUNC    LOCAL  DEFAULT    1 test_ti_thread_flag.clone
>    510: ffffffff81ae5c40   136 FUNC    LOCAL  DEFAULT   22 e820_end_pfn.clone.0
>    750: ffffffff8100a388    65 FUNC    LOCAL  DEFAULT    1 trace_power_start.clone.0
> [acme@doppio linux-2.6-tip]$
> 
> Or at least those are the ones with dots here.

Note, in PPC64 the function names all start with dots. That is, a
function name is just a symbol look up to the actual function which is
referenced by a '.'.


 sys_read: points to .sys_read

 .sys_read: actual address of start of function.

-- Steve


