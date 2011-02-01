Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1BAONM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:13:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36340 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1BAONK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:13:10 -0500
Date: Tue, 1 Feb 2011 06:13:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: call_function_many: fix list delete vs add race
Message-ID: <20110201141301.GA23646@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <1296508677.26581.84.camel@laptop>
 <1296519764.2349.325.camel@pasglop>
 <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
 <20110201021831.GB2158@linux.vnet.ibm.com>
 <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
 <20110201044517.GC2158@linux.vnet.ibm.com>
 <AANLkTikZXh4NbwTCj22dTAEjnNjtEdGtQpTDChw=fckN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikZXh4NbwTCj22dTAEjnNjtEdGtQpTDChw=fckN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 03:46:26PM +1000, Linus Torvalds wrote:
> On Tue, Feb 1, 2011 at 2:45 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Feb 01, 2011 at 12:43:56PM +1000, Linus Torvalds wrote:
> >>
> >> That said, I do think that if your memory ordering is much weaker than
> >> x86, you are going to see bugs that most testers don't see, and it
> >> simply might not be worth it.
> >
> > IBM's CPUs do split the difference, with s390 having somewhat stronger
> > ordering than x86, and with powerpc being rather weaker
> 
> I'm not talking about memory ordering as done by the cpu, but as done
> by the spinlock operations. They can be arbitrarily strong, even if
> the CPU architecture itself might be weakly ordered.

Got it.

[ . . . ]

> Quite frankly, the POWER case is made worse by the fact that the
> synchronization primitives have this total confusion about "pipeline"
> synchronization due to historical implementation oddities etc. Talk
> about crazy. The whole "isync" vs "sync" vs "lwsync" thing is just an
> embarrassment.

I am always ready to exploit embarrassing parallelism!

							Thanx, Paul
