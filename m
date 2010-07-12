Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0GLPmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:42:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60824 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0GLPma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:42:30 -0400
Date: Mon, 12 Jul 2010 21:03:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 10/13]  perf: Re-Add make_absolute_path
Message-ID: <20100712153357.GB23776@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
 <20100712140023.GC25238@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100712140023.GC25238@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@infradead.org> [2010-07-12 11:00:23]:

> Em Mon, Jul 12, 2010 at 04:04:12PM +0530, Srikar Dronamraju escreveu:
> > perf: Re-Add make_absolute_path
> > 
> > perf probe for uprobes would use make_absolute_path.
> > make_absolute_path can be used to convert a file name to a dso name.
> > 
> > so if user specifies the function to be traced as malloc@/lib/libc.so.6
> > it needs to be converted to malloc@libc-2.5.so
> 
> Isn't this the other way around? I.e. "if the user specifies
> malloc@libc-2.5.so it needs to be converted to malloc@/lib/libc.so.6"?
> 

Actually we dont need to convert malloc@libc-2.5.so to a
malloc@/lib/libc.so.6. Because we can match the shortname of the dso. 

Problem will occur when users specifies a full path of the file.
Since the file can refer to a symbolic link and the dso will have just
the short name or the target file name. Here I am using
make_absolute_path to resolve to the target file.
Now we can then either check on dso full names or short names.
I have chosen to use the short name.


> Also please remove the xstrdup and die calls from this function, we're
> trying to get rid of all such 'panic' like functions so that we can
> librarize as much code as possible.

Okay, Can I do that in subsequent versions of the patchset?

--
Thanks and Regards
Srikar

