Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930Ab0J2UJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:09:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54733 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761870Ab0J2UJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hk7hkq4WdQ2I/i+gQ/BXQHV1wJKkNSqitS4PDZdio/LzX14bIA2rTFNY4saZqpPspD
         iX90QZW3OzC+C6inc21NT0ox2KOYsXK99YkaeKvAiGgChTGRe+qanSFWV5t0uVkANWXG
         vqAkcqHbX6/xW9NSmNTJONgRA7dOvlHvlVV0Y=
Date: Sat, 30 Oct 2010 00:09:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
	allocations
Message-ID: <20101029200859.GA6130@lenovo>
References: <1288276854.2649.607.camel@edumazet-laptop> <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org> <1288377146.1988.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288377146.1988.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 08:32:26PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> > +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> > +                                              THREAD_FLAGS,
> > +                                              THREAD_ORDER)); 
> 
> Shouldn't we be checking for a NULL return from alloc_pages_node()
> before calling page_address() on it?

 It seems at this stage it's a panic() or BUG_ON candidate. (Which
reminds me GFP_PANIC flag proposal back in 2009 ;)

  Cyrill
