Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1FJJa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:30:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1FJJaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:30:55 -0400
Date: Fri, 10 Jun 2011 11:30:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-ID: <20110610093049.GG27280@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.493181962@chello.nl>
 <20110609130617.f8aca966.akpm@linux-foundation.org>
 <20110609202707.GA28951@elte.hu>
 <1307652883.2497.1028.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307652883.2497.1028.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> >   => only a 'there be dragons' mental marker
> 
> Right, my reply was that I couldn't convince myself unlock order 
> could make a difference, but clearly I can easily have missed 
> something subtle.
> 
> > and i have to say that when i found a boot lockup during testing 
> > i was not surprised very much :)
> 
> But you found a lockup on the second patch, not this one.

Yeah, it's not like my mental markers are overly precise! ;-)

> Also, this patch is important for #3, where we want to take 
> logbuf_lock under the semaphore internal lock, that too would 
> preclude us doing that up() in the old location.

Yeah. I'm not against it or anything (hey i suggested the whole 
thing), but i'll be testing this through carefully.

Thanks,

	Ingo
