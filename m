Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0CWVbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:31:33 -0400
Received: from ozlabs.org ([203.10.76.45]:37550 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0CWVbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:31:31 -0400
Date: Wed, 24 Mar 2010 08:31:26 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp_call_function_many SMP race
Message-ID: <20100323213126.GA5594@kryten>
References: <20100323111556.GK24064@kryten>
 <1269347203.5279.1650.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269347203.5279.1650.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Peter,

> A rather simple question since my brain isn't quite ready processing the
> content here..

After working my way through that bug my brain wasn't in good shape
either because:

> Isn't reverting that one patch a simpler solution than adding all that
> extra logic? If not, then the above statement seems false and we had a
> bug even with that preempt_enable/disable() pair.

I screwed up the explanation :( The commit message that causes it is
54fdade1c3332391948ec43530c02c4794a38172 (generic-ipi: make struct
call_function_data lockless), and backing it out fixes the issue.

Anton
