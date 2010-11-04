Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0KDOfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:35:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46292 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0KDOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:35:45 -0400
Date: Thu, 4 Nov 2010 15:35:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] irq: better struct irqaction layout
Message-ID: <20101104143539.GE32383@basil.fritz.box>
References: <1288865628.2659.69.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288865628.2659.69.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:13:48AM +0100, Eric Dumazet wrote:
> We currently use kmalloc-96 slab for struct irqaction allocations on
> 64bit arches.
> 
> This is unfortunate because of possible false sharing and two cache
> lines accesses.
> 
> Move 'name' and 'dir' fields at the end of the structure, and force a
> suitable alignement.
> 
> Hot path fields now use one cache line on x86_64.

Looks good.  It would be nice if some of the fields could be merged (like
thread_flags and flags), but I assume it would be tought to get it back
to 64 bytes again.

Reviewed-by: Andi Kleen <ak@linux.intel.com>
-Andi
