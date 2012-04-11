Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2DKRU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:20:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44828 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab2DKRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:20:55 -0400
Date: Wed, 11 Apr 2012 22:42:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH] perf/probe: Provide perf interface for uprobes
Message-ID: <20120411170343.GB29831@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120411135742.29198.45061.sendpatchset@srdronam.in.ibm.com>
 <20120411144918.GD16257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120411144918.GD16257@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041117-4242-0000-0000-0000015010FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@infradead.org> [2012-04-11 11:49:18]:

> Em Wed, Apr 11, 2012 at 07:27:42PM +0530, Srikar Dronamraju escreveu:
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > - Enhances perf to probe user space executables and libraries.
> > - Enhances -F/--funcs option of "perf probe" to list possible probe points in
> >   an executable file or library.
> > - Documents userspace probing support in perf.
> > 
> > [ Probing a function in the executable using function name  ]
> > perf probe -x /bin/zsh zfree
> > 
> > [ Probing a library function using function name ]
> > perf probe -x /lib64/libc.so.6 malloc
> > 
> > [ list probe-able functions in an executable ]
> > perf probe -F -x /bin/zsh
> > 
> > [ list probe-able functions in an library]
> > perf probe -F -x /lib/libc.so.6
> 
> Can we avoid the need for -x? I.e. we could figure out it is userspace
> and act accordingly.
> 

To list the functions in the module ipv6, we use "perf probe -F -m ipv6"
So I used the same logic to use -x for specifying executables.


This is in agreement with probepoint addition where without any
additional options would mean kernel probepoint; m option would mean
module and x option would mean user space executable. 

However if you still think we should change, do let me know.

-- 
Thanks and Regards
Srikar

