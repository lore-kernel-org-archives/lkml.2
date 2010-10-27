Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0J0J5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:57:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0J0J5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:57:43 -0400
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, tj@kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@elte.hu
In-Reply-To: <1288159670.2652.181.camel@edumazet-laptop>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Oct 2010 11:57:22 +0200
Message-ID: <1288173442.15336.1490.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 08:07 +0200, Eric Dumazet wrote:
> > -     irqctx = &per_cpu(hardirq_stack, cpu);
> > +     irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
> 
> Hmm, then we lose NUMA affinity for stacks. 

I guess we could use:

  alloc_pages_node(cpu_to_node(cpu), THREAD_FLAGS, THREAD_ORDER);


