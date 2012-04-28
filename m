Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2D1IgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:36:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53511 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2D1IgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:36:08 -0400
Date: Sat, 28 Apr 2012 10:36:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and -mfentry?
Message-ID: <20120428083603.GJ27374@one.firstfloor.org>
References: <1335552399.28106.228.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335552399.28106.228.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) Have kconfig detect if -mfentry is supported with the current
> compiler. If it is, then enable a "auto" config called
> CONFIG_CC_HAS_FENTRY, and allow function tracer be able to select
> FRAME_POINTER if that's not defined.
> 
> I actually got this to work, but it only works if the host compiler is
> the same as the compiler building the kernel. Which in lots of cases is
> not (my default setup does not have this).

Kconfig just needs to learn how to run the target compiler

I think that's the right direction. Right now our main
Makefiles get polluted more and more with "test compiles", each
of which makes a "null make" slower and slower. 

I just measured and a null compile (nothing changes) of a current
tree calls "gcc" 141 times.

All this stuff should be cached in the Kconfig instead.

It may break some obscure setups (that can be probably fixed without
too much effort), but the development turnaround improvement
for everyone else would be worth it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
