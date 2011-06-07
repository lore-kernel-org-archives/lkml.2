Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1FGNue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:50:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35863 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1FGNud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:50:33 -0400
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307454439.2322.260.camel@twins>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	 <1307454439.2322.260.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 15:50:24 +0200
Message-ID: <1307454624.2322.261.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:47 +0200, Peter Zijlstra wrote:
> Only if your above assumption holds, which it doesn't. It explicitly
> checks to see if _this_ cpu needs a resched while spinning, if so it
> bails the spinning and calls schedule in the lock slow path.
> 
> If the owner cpu reschedules, owner will leave the rq and

s/rq/cpu/

> owner_running() will return false, also breaking the loop. 
