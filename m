Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2AZKEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:04:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2AZKEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:04:50 -0500
Date: Thu, 26 Jan 2012 11:04:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        Xiaotian Feng <xtfeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
Message-ID: <20120126100429.GA3853@elte.hu>
References: <4F13EFBE.1030002@linux.vnet.ibm.com>
 <1326707503.2442.219.camel@twins>
 <4F14DEAE.60702@linux.vnet.ibm.com>
 <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
 <4F14E54E.80904@linux.vnet.ibm.com>
 <1327506934.2614.87.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327506934.2614.87.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2012-01-17 at 11:04 +0800, Michael Wang wrote:
> > 
> > > Then what if condition 1 is true now?
> > 
> > We can see in original code, even condition 1 is true, we
> > still will use value3 if condition3 is true, like this:
> > 
> > original:
> > 
> > condition1      condition3      result
> > true            true            value3
> > true            false           value1
> > 
> > That means if condition3 is true, we don't care whether
> > condition1 is true or not because we will finally use value3.
> 
> Right, so from the original 8 possible states we used to evaluate 3*8 =
> 24 conditionals. The new code will reduce this to 1*4 + 2*2 + 2*3 = 14.
> 
> Now I guess the question is if it matters for the modal or average
> state.
> 
> I've applied the patch since it can't be worse, but I've no idea if it
> matters or not in practice.

A before/after kernel/sched.o size comparison on 64-bit 
defconfig typically gives a pretty good indication whether it's 
a step forward or not.

Thanks,

	Ingo
