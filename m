Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1ITUx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:53:27 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47735 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1ITUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:53:25 -0400
Date: Tue, 20 Sep 2011 21:53:17 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 8/26]   x86: analyze instruction and
 determine fixups.
Message-ID: <20110920205317.GA1508@stefanha-thinkpad.localdomain>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120127.25326.71509.sendpatchset@srdronam.in.ibm.com>
 <20110920171310.GC27959@stefanha-thinkpad.localdomain>
 <20110920181225.GA5149@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920181225.GA5149@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 02:12:25PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 20, 2011 at 06:13:10PM +0100, Stefan Hajnoczi wrote:
> > You've probably thought of this but it would be nice to skip XOL for
> > nops.  This would be a common case with static probes (e.g. sdt.h) where
> > the probe template includes a nop where we can easily plant int $0x3.
> 
> Do we now have sdt.h support for uprobes?  That's one of the killer
> features that always seemed to get postponed.

Not yet but it's a question of doing roughly what SystemTap does to
parse the appropriate ELF sections and then putting those probes into
uprobes.

Masami looked at this and found that SystemTap sdt.h currently requires
an extra userspace memory store in order to activate probes.  Each probe
has a "semaphore" 16-bit counter which applications may test before
hitting the probe itself.  This is used to avoid overhead in
applications that do expensive argument processing (e.g. creating
strings) for probes.

But this should be solvable so it would be possible to use perf-probe(1)
on a std.h-enabled binary.  Some distros already ship such binaries!

Stefan
