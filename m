Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab2FFSIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:08:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47991 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab2FFSIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:08:12 -0400
Subject: Re: [PATCH 2/2] [POWERPC] uprobes: powerpc port
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: ananth@in.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, oleg@redhat.com,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20120606093541.GA29580@in.ibm.com>
References: <20120606091950.GB6745@in.ibm.com>
	 <20120606092150.GC6745@in.ibm.com> <1338974822.2749.89.camel@twins>
	 <20120606093541.GA29580@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 11:08:04 -0700
Message-ID: <1339006084.3458.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060618-7182-0000-0000-000001AF0A48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 15:05 +0530, Ananth N Mavinakayanahalli wrote:
> On Wed, Jun 06, 2012 at 11:27:02AM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-06 at 14:51 +0530, Ananth N Mavinakayanahalli wrote:
> > > One TODO in this port compared to x86 is the uprobe abort_xol() logic.
> > > x86 depends on the thread_struct.trap_nr (absent in powerpc) to determine
> > > if a signal was caused when the uprobed instruction was single-stepped/
> > > emulated, in which case, we reset the instruction pointer to the probed
> > > address and retry the probe again. 
> > 
> > Another curious difference is that x86 uses an instruction decoder and
> > contains massive tables to validate we can probe a particular
> > instruction.

Part of that difference is because the x86 instruction set is a lot more
complex.  Another part is due to the lack, back when the x86 code was
created, of robust handling by uprobes of traps by probed instructions.
So we refused to probe instructions that we knew (or strongly suspected)
would generate traps in user mode -- e.g., privileged instructions,
illegal instructions.  A couple of times we had to "legalize"
instructions or prefixes that we didn't originally expect to encounter.

> > 
> > Can we probe all possible PPC instructions?
> 
> For the kernel, the only ones that are off limits are rfi (return from
> interrupt), mtmsr (move to msr). All other instructions can be probed.
> 
> Both those instructions are supervisor level, so we won't see them in
> userspace at all; so we should be able to probe all user level
> instructions.

Presumably rfi or mtmsr could show up in the instruction stream via an
erroneous or mischievous asm statement.  It'd be good to verify that you
handle that gracefully.

> 
> I am not aware of specific caveats for vector/altivec instructions;
> maybe Paul or Ben are more suitable to comment on that.
> 
> Ananth
> 

Jim


