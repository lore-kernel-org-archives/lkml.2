Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133Ab2FHJVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:21:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45848 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007Ab2FHJVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:21:12 -0400
Date: Fri, 8 Jun 2012 14:51:04 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] uprobes: powerpc port
Message-ID: <20120608092104.GF13409@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120606092150.GC6745@in.ibm.com> <1338974822.2749.89.camel@twins> <20120606093541.GA29580@in.ibm.com> <1339006084.3458.25.camel@localhost> <20120608043605.GB13409@in.ibm.com> <1339134714.25573.4.camel@concordia> <20120608060104.GD13409@in.ibm.com> <1339136264.25573.7.camel@concordia> <20120608061954.GE13409@in.ibm.com> <1339137497.25573.9.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339137497.25573.9.camel@concordia>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060809-3270-0000-0000-000007008B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:38:17PM +1000, Michael Ellerman wrote:
> On Fri, 2012-06-08 at 11:49 +0530, Ananth N Mavinakayanahalli wrote:
> > On Fri, Jun 08, 2012 at 04:17:44PM +1000, Michael Ellerman wrote:
> > > On Fri, 2012-06-08 at 11:31 +0530, Ananth N Mavinakayanahalli wrote:
> > > > On Fri, Jun 08, 2012 at 03:51:54PM +1000, Michael Ellerman wrote:
> > > > > On Fri, 2012-06-08 at 10:06 +0530, Ananth N Mavinakayanahalli wrote:
> > > > 
> > > > But MSR_PR=1 and hence emulate_step() will return -1 and hence we will
> > > > end up single-stepping using user_enable_single_step(). Same with rfid.
> > > 
> > > Right. But that was exactly Jim's point, you may be asked to emulate
> > > those instructions even though you wouldn't expect to see them in
> > > userspace code, so you need to handle it.
> > > 
> > > Luckily it looks like emulate_step() will do the right thing for you.
> > > It'd be good to test it to make 100% sure.
> > 
> > Sure. Will add that check and send v2.
> 
> Sorry I didn't mean add a test in the code, I meant construct a test
> case to confirm that it works as expected.

Michael,

I just hand-coded the instr to emulate_step() and here are the results:

MSR_PR is set
insn = 7c600124, ret = 0 /* mtmsr */
insn = 7c600164, ret = 0 /* mtmsrd */
insn = 4c000024, ret = -1 /* rfid */
insn = 4c000064, ret = 0 /* rfi */

Also verified that standalone programs with those instructions in inline
asm will die with a SIGILL.

So, for mtmsr, mtmsrd and rfi, we have to single-step them which will
result in a SIGILL in turn.

Ananth

