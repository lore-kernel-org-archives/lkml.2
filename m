Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2BVHx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:53:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab2BVHxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:53:55 -0500
Date: Wed, 22 Feb 2012 08:53:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222075334.GA25053@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222073251.GB17291@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> But it is fundamentally mixing execution and *data type* and 
> it is not conveying the build time bias properly.
> 
> So the best high level naming would be something like:
> 
> 	struct static_condition static_flag = STATIC_COND_FALSE;
> 
> 
> 	if (very_unlikely(&static_flag)) {
> 		...
> 	}
> 
> 	...
> 
> 	static_cond_inc(&static_flag);
> 	...
> 	static_cond_dec(&static_flag);

Btw., I think the modification path could also carry the high 
cost of modification (stopping all cpus, modifying code, etc.).

This could be done via:

	static_cond_slow_inc(&static_flag);
	...
	static_cond_slow_dec(&static_flag);

And if a developer does not notice that 'slow' implies a 
performance cost, then he probably would have doubly missed this 
aspect of jump_label_inc()/jump_label_dec().

Thanks,

	Ingo
