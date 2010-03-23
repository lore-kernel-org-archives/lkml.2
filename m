Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0CWM07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:26:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0CWM04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:26:56 -0400
Subject: Re: [PATCH] smp_call_function_many SMP race
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100323111556.GK24064@kryten>
References: <20100323111556.GK24064@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 13:26:43 +0100
Message-ID: <1269347203.5279.1650.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 22:15 +1100, Anton Blanchard wrote:
> 
> It turns out commit c0f68c2fab4898bcc4671a8fb941f428856b4ad5 (generic-ipi:
> cleanup for generic_smp_call_function_interrupt()) is at fault. It removes
> locking from smp_call_function_many and in doing so creates a rather
> complicated race. 

A rather simple question since my brain isn't quite ready processing the
content here..

Isn't reverting that one patch a simpler solution than adding all that
extra logic? If not, then the above statement seems false and we had a
bug even with that preempt_enable/disable() pair.

Just wondering.. :-)
