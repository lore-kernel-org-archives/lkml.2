Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab2FLEB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 00:01:56 -0400
Received: from ozlabs.org ([203.10.76.45]:48576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab2FLEBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 00:01:55 -0400
Message-ID: <1339473706.14757.14.camel@concordia>
Subject: Re: [PATCH 2/2] [POWERPC] uprobes: powerpc port
From: Michael Ellerman <michael@ellerman.id.au>
To: ananth@in.ibm.com
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, oleg@redhat.com,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 12 Jun 2012 14:01:46 +1000
In-Reply-To: <20120608092104.GF13409@in.ibm.com>
References: <20120606092150.GC6745@in.ibm.com>
	 <1338974822.2749.89.camel@twins> <20120606093541.GA29580@in.ibm.com>
	 <1339006084.3458.25.camel@localhost> <20120608043605.GB13409@in.ibm.com>
	 <1339134714.25573.4.camel@concordia> <20120608060104.GD13409@in.ibm.com>
	 <1339136264.25573.7.camel@concordia> <20120608061954.GE13409@in.ibm.com>
	 <1339137497.25573.9.camel@concordia> <20120608092104.GF13409@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 14:51 +0530, Ananth N Mavinakayanahalli wrote:
> On Fri, Jun 08, 2012 at 04:38:17PM +1000, Michael Ellerman wrote:
> > On Fri, 2012-06-08 at 11:49 +0530, Ananth N Mavinakayanahalli wrote:
> > > On Fri, Jun 08, 2012 at 04:17:44PM +1000, Michael Ellerman wrote:
> > > > On Fri, 2012-06-08 at 11:31 +0530, Ananth N Mavinakayanahalli wrote:
> > > > > On Fri, Jun 08, 2012 at 03:51:54PM +1000, Michael Ellerman wrote:
> > > > > > On Fri, 2012-06-08 at 10:06 +0530, Ananth N Mavinakayanahalli wrote:
> > > > > 
> > > > > But MSR_PR=1 and hence emulate_step() will return -1 and hence we will
> > > > > end up single-stepping using user_enable_single_step(). Same with rfid.
> > > > 
> > > > Right. But that was exactly Jim's point, you may be asked to emulate
> > > > those instructions even though you wouldn't expect to see them in
> > > > userspace code, so you need to handle it.
> > > > 
> > > > Luckily it looks like emulate_step() will do the right thing for you.
> > > > It'd be good to test it to make 100% sure.
> > > 
> > > Sure. Will add that check and send v2.
> > 
> > Sorry I didn't mean add a test in the code, I meant construct a test
> > case to confirm that it works as expected.
> 
> Michael,
> 
> I just hand-coded the instr to emulate_step() and here are the results:
> 
> MSR_PR is set
> insn = 7c600124, ret = 0 /* mtmsr */
> insn = 7c600164, ret = 0 /* mtmsrd */
> insn = 4c000024, ret = -1 /* rfid */
> insn = 4c000064, ret = 0 /* rfi */
> 
> Also verified that standalone programs with those instructions in inline
> asm will die with a SIGILL.
> 
> So, for mtmsr, mtmsrd and rfi, we have to single-step them which will
> result in a SIGILL in turn.

What happens in the rfid case? You don't handle -1 from emulate_step()
any differently AFAICS, so don't we try to single step that too?

cheers



