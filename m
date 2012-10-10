Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2JJOCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:02:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49443 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2JJOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:02:50 -0400
Date: Wed, 10 Oct 2012 16:02:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Ivo Sieben <meltedpianoman@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST] RFC: sched: Prevent wakeup to enter critical section needlessly
Message-ID: <20121010140249.GX16230@one.firstfloor.org>
References: <1348491997-30898-1-git-send-email-meltedpianoman@gmail.com> <1349782235-8896-1-git-send-email-meltedpianoman@gmail.com> <m2r4p7u5pk.fsf@firstfloor.org> <1349792104.7880.41.camel@twins> <20121009151729.GA3521@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009151729.GA3521@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> wait_event:
> 
> 	prepare_to_wait(wq)	// takes wq->lock
> 
> 	if (!CONDITION)
> 		schedule();
> 
> Now,
> 
> 	CONDITION = 1;
> 	wake_up(wq);
> 
> at least need the full mb() before lits_empty().

You're right, but it would probably only matter for inlining with LTO
(if the LTO compiler ever decides to do that)

Without that a call should be always enough barrier in practice.

So yes I would add the mb, but most likely it will not make much
difference. Just make sure to comment it.

-Andi
