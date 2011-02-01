Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab1BAGRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 01:17:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:53239 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BAGRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 01:17:17 -0500
Subject: Re: call_function_many: fix list delete vs add race
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Milton Miller <miltonm@bga.com>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296508677.26581.84.camel@laptop> <1296519764.2349.325.camel@pasglop>
	 <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
	 <20110201021831.GB2158@linux.vnet.ibm.com>
	 <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 17:16:01 +1100
Message-ID: <1296540961.2349.336.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 12:43 +1000, Linus Torvalds wrote:
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

Allright. The way we do it on power is stores won't pass the unlock
either way (lwsync). Some loads might migrate up tho.

Cheers,
Ben.

