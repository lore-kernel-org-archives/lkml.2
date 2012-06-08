Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab2FHFwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:52:00 -0400
Received: from ozlabs.org ([203.10.76.45]:33578 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119Ab2FHFv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:51:59 -0400
Message-ID: <1339134714.25573.4.camel@concordia>
Subject: Re: [PATCH 2/2] [POWERPC] uprobes: powerpc port
From: Michael Ellerman <michael@ellerman.id.au>
To: ananth@in.ibm.com
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linuxppc-dev@lists.ozlabs.org
Date: Fri, 08 Jun 2012 15:51:54 +1000
In-Reply-To: <20120608043605.GB13409@in.ibm.com>
References: <20120606091950.GB6745@in.ibm.com>
	 <20120606092150.GC6745@in.ibm.com> <1338974822.2749.89.camel@twins>
	 <20120606093541.GA29580@in.ibm.com> <1339006084.3458.25.camel@localhost>
	 <20120608043605.GB13409@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 10:06 +0530, Ananth N Mavinakayanahalli wrote:
> On Wed, Jun 06, 2012 at 11:08:04AM -0700, Jim Keniston wrote:
> > On Wed, 2012-06-06 at 15:05 +0530, Ananth N Mavinakayanahalli wrote:
> > > On Wed, Jun 06, 2012 at 11:27:02AM +0200, Peter Zijlstra wrote:
> > > > On Wed, 2012-06-06 at 14:51 +0530, Ananth N Mavinakayanahalli wrote:
> 
> ...
> 
> > > For the kernel, the only ones that are off limits are rfi (return from
> > > interrupt), mtmsr (move to msr). All other instructions can be probed.
> > > 
> > > Both those instructions are supervisor level, so we won't see them in
> > > userspace at all; so we should be able to probe all user level
> > > instructions.
> > 
> > Presumably rfi or mtmsr could show up in the instruction stream via an
> > erroneous or mischievous asm statement.  It'd be good to verify that you
> > handle that gracefully.
> 
> That'd be flagged elsewhere, by the architecture itself -- you'd get a
> privileged instruciton exception if you try execute any instruction not
> part of the UISA. I therefore don't think its a necessary check in the
> uprobes code.

But you're not executing the instruction, you're passing it to
emulate_step(). Or am I missing something?

cheers

