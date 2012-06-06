Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2FFJfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:35:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56274 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2FFJfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:35:50 -0400
Date: Wed, 6 Jun 2012 15:05:41 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        oleg@redhat.com
Subject: Re: [PATCH 2/2] [POWERPC] uprobes: powerpc port
Message-ID: <20120606093541.GA29580@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120606091950.GB6745@in.ibm.com> <20120606092150.GC6745@in.ibm.com> <1338974822.2749.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338974822.2749.89.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060609-7182-0000-0000-000001AD07B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:27:02AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 14:51 +0530, Ananth N Mavinakayanahalli wrote:
> > One TODO in this port compared to x86 is the uprobe abort_xol() logic.
> > x86 depends on the thread_struct.trap_nr (absent in powerpc) to determine
> > if a signal was caused when the uprobed instruction was single-stepped/
> > emulated, in which case, we reset the instruction pointer to the probed
> > address and retry the probe again. 
> 
> Another curious difference is that x86 uses an instruction decoder and
> contains massive tables to validate we can probe a particular
> instruction.
> 
> Can we probe all possible PPC instructions?

For the kernel, the only ones that are off limits are rfi (return from
interrupt), mtmsr (move to msr). All other instructions can be probed.

Both those instructions are supervisor level, so we won't see them in
userspace at all; so we should be able to probe all user level
instructions.

I am not aware of specific caveats for vector/altivec instructions;
maybe Paul or Ben are more suitable to comment on that.

Ananth

