Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2D0V1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:27:32 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:48136 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab2D0V1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:27:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Fcc: ~/Mail/lkml
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
In-Reply-To: Al Viro's message of  Friday, 27 April 2012 22:12:44 +0100 <20120427211244.GO6871@ZenIV.linux.org.uk>
References: <20120420164239.GH6871@ZenIV.linux.org.uk>
	<CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
	<20120420180748.GI6871@ZenIV.linux.org.uk>
	<20120423180150.GA6871@ZenIV.linux.org.uk>
	<20120424072617.GB6871@ZenIV.linux.org.uk>
	<20120426183742.GA324@redhat.com>
	<20120426231942.GJ6871@ZenIV.linux.org.uk>
	<20120427172444.GA30267@redhat.com>
	<20120427184528.GL6871@ZenIV.linux.org.uk>
	<20120427202002.8ED632C0BF@topped-with-meat.com>
	<20120427211244.GO6871@ZenIV.linux.org.uk>
X-Zippy-Says: BRYLCREAM is CREAM O' WHEAT in another DIMENSION..
Message-Id: <20120427212729.652542C0AF@topped-with-meat.com>
Date: Fri, 27 Apr 2012 14:27:29 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=e8d9udV/ c=1 sm=1 a=No4if-_LAocA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=keYpsyYYbXNozSzVF_oA:9
		a=CjuIK1q_8ugA:10 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK...  FWIW, it sounds like an argument for using it (or a function in
> kernel/signal.c that would call it) on all architectures.

That was certainly always the intent.  But I only touched myself the arch's
that I was prepared to test reasonably.

> Note that there's an extra complication on alpha and itanic - we have more
> than just struct pt_regs * there.  If we care about the rest of registers
> (struct switch_stack on alpha), we probably need to do something about that.

The presumed plan so far was just that anybody would use user_regset for
any serious tracer/debugger stuff.  That is certainly much more costly on
ia64 than passing along a few more values.  If anybody ever cares, the
tracehook functions' signatures can always be adjusted in the future.

> I wonder how alpha and itanic deal with do_coredump(), BTW - it gets
> pt_regs, but not the rest...

The expectation was that every arch would eventually switch on
CORE_DUMP_USE_REGSET.  (Looks like so far 12 do and so ~16 don't.)
Certainly avoiding the overhead of user_regset for core dumping is not
worth any new code complexity or extra arch hooks, since that overhead
even on the worst-case arch (ia64) has got to be marginal in comparison
to all the memory-copying and i/o going on.  For imagined potential
tracing/fancier-debugging cases that might be used in high-throughput
ways the question would be different, but such uses still remain to be
implemented.


Thanks,
Roland
