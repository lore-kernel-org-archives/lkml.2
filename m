Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1FGOkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:40:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:56868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1FGOkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:40:51 -0400
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	 <1307454439.2322.260.camel@twins>
	 <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
	 <1307456680.2322.270.camel@twins>
	 <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 16:40:46 +0200
Message-ID: <1307457646.2322.273.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 22:36 +0800, Hillf Danton wrote:

> If you are right, the following comment also in __mutex_lock_common()
> 
> 	for (;;) {
> 		struct task_struct *owner;
> 
> 		/*
> 		 * If there's an owner, wait for it to either
> 		 * release the lock or go to sleep.
> 		 */
> 		owner = ACCESS_ONCE(lock->owner);
> 		if (owner && !mutex_spin_on_owner(lock, owner))
> 			break;
> 
> looks misleading too, but if owner is on this CPU, for what does we wait?

huh, wtf!? it cannot be on this cpu, if it was we wouldn't be running
the above code but whatever owner was doing.

So my argument was, it cannot be on this cpu, therefore, by checking it
is on a cpu, we check its on a different cpu.

And I really don't see how any of that is related to the above.
