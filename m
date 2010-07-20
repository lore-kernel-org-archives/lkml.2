Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0GTEUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:20:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0GTEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:20:05 -0400
Date: Tue, 20 Jul 2010 00:19:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <20100720041938.GA28533@infradead.org>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried this again and it worked.  That is kinda worked becuase I could
use it to trace things in my running bash instance, but haven't really
figured out how to trace something useful using the pid based interface.
The processes I care about really don't run long enough for that.

So thanks for the good work so far, but we'll really need a way to
define the trace points per-file and have a way to invoke a program
with tracing that uses it enabled.

A minor note on perf probe -S output:  This seems to include a lot of
T.456 or similar labels, which from my recollection are gcc internal
things.  It would be good to filter those out as they aren't quite
useful and just fill up the list.


And I really need to complain about the per-patch changelogs inside
the visible commit message again.  I know you disagree, but it's
a real pain to read through it in git-log when you look for information
about the patch (which for some of the patches is rather short anyway)
and all you see is some rather useless patch versioning changelogs.
This is what basically all patches to the kernel do, and what's also
suggested in Documentation/SubmittingPatches.

While talking about changelogs: your patches duplicate the patch
subject line inside the mail body, leading to rather funny git
commit messages after a git-am:

commit c32a1b63db113bb1508dbf01af34d29f6cda747a
Author: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date:   Mon Jul 12 16:04:42 2010 +0530

    perf: show functions in a file without using pid
        
    [RFC] perf: show functions in a file without using pid

    ...

