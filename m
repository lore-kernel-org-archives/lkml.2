Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab1BAEpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 23:45:22 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57608 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab1BAEpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 23:45:21 -0500
Date: Mon, 31 Jan 2011 20:45:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: call_function_many: fix list delete vs add race
Message-ID: <20110201044517.GC2158@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <smp-call-function-peter-reply@mdm.bga.com>
 <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <1296508677.26581.84.camel@laptop>
 <1296519764.2349.325.camel@pasglop>
 <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
 <20110201021831.GB2158@linux.vnet.ibm.com>
 <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 12:43:56PM +1000, Linus Torvalds wrote:
> On Tue, Feb 1, 2011 at 12:18 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Documentation/memory-barriers.txt specifies this.
> 
> Good, so it really is documented, with both cases explicitly mentioned.
> 
> That said, I do think that if your memory ordering is much weaker than
> x86, you are going to see bugs that most testers don't see, and it
> simply might not be worth it.

IBM's CPUs do split the difference, with s390 having somewhat stronger
ordering than x86, and with powerpc being rather weaker (along with arm,
ia64, and some flavors of mips, but stronger than alpha).  But yes, this
does mean that there are bugs that don't show up on x86 and s390, but
that do on powerpc, arm, ia64, and some mips, to say nothing of alpha.
Similarly, there are bugs that show up on x86 due to unsynchronized
timestamp counters that powerpc and s390 avoid due to the guaranteed
synchronization on those platforms.

Whether the weaker ordering provides worthwhile benefits is an interesting
debate that I do not believe we will be able to resolve here.  ;-)

							Thanx, Paul
