Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab1COUhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:37:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1COUhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:37:45 -0400
Subject: Re: [PATCH 0/4 v3] smp_call_function_many issues from review
From: Peter Zijlstra <peterz@infradead.org>
To: Milton Miller <miltonm@bga.com>
Cc: akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, efault@gmx.de,
        Jan Beulich <JBeulich@novell.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Tony Luck <tony.luck@intel.com>, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <smp-call-function-intro-v3@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com> <ipi-list-reply@mdm.bga.com>
	 <smp-cfm-list-comment@mdm.bga.com>
	 <smp-call-function-list-race-fix-v2@mdm.bga.com>
	 <20110201220026.GD2142@linux.vnet.ibm.com> <ipi-paul-reply@mdm.bga.com>
	 <20110202041740.GB2129@linux.vnet.ibm.com>
	 <20110206235136.GA23658@linux.vnet.ibm.com>
	 <smp-call-function-intro-v3@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 21:39:29 +0100
Message-ID: <1300221569.2250.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 13:27 -0600, Milton Miller wrote:
> Picking up this thread from the beginning of Feburary,  I updated
> the comments in 3 and 4 based on Paul's review.  I have inserted
> my proposed alternative to Paul's additional patch as patch 2,
> and tweaked the changelog on 1.
> 
> [PATCH 1/4 v3] call_function_many: fix list delete vs add race
> [PATCH 2/4 v3] call_function_many: add missing ordering
> [PATCH 3/4 v3] smp_call_function_many: handle concurrent clearing of mask
> [PATCH 4/4 v3] smp_call_function_interrupt: use typedef and %pf
> 
> Peter Z acked a prior version of patch 1, and Mike Galbraith has
> done some stress testing on the combinaton of 1,3,4, and Paul's patch.
> 
> The prior posting of this series is available here:
> https://patchwork.kernel.org/patch/522021/
> https://patchwork.kernel.org/patch/522031/
> http://marc.info/?l=linux-kernel&m=129654439817236&w=2
> 
> And Paul's additional patch from review was here
> https://patchwork.kernel.org/patch/525891/
> 
> Looking forward, I would suggest 1 and 2 are required for stable, 3 may
> be suitable as it fixes races that otherwise requires cpumask copies
> as in 75c1c91cb92806f960fcd6e53d2a0c21f343081c ([IA64] eliminate race
> condition in smp_flush_tlb_mm).  By contrast 4 is just comments except
> for the %pS to %pf change.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Very interesting that patch #2.

