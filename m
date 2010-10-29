Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983Ab0J2U6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:58:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64014 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0J2U6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G4CkBiY5R8LVZLUm0RL48V7NOLptbUy2IZHND+xwb/2MjWIpPJ5p8qROKH4olyNMC5
         Ytu1Ct752ZpywYkAGbPhcy+DOBqQcEV/0ZRQOVt5fJVhVNYz0qe2sPGr4zoiZDLtE1EO
         oRu2/Bpk6Nvh8dCkCaS65NlKVtVnSTLdelPf0=
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
 allocations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20101029202809.GB6130@lenovo>
References: <1288276854.2649.607.camel@edumazet-laptop>
	 <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org>
	 <1288377146.1988.0.camel@laptop>  <20101029202809.GB6130@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 22:58:03 +0200
Message-ID: <1288385883.2680.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 octobre 2010 à 00:28 +0400, Cyrill Gorcunov a écrit :
> On Fri, Oct 29, 2010 at 08:32:26PM +0200, Peter Zijlstra wrote:
> > On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> > > +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> > > +                                              THREAD_FLAGS,
> > > +                                              THREAD_ORDER)); 
> > 
> > Shouldn't we be checking for a NULL return from alloc_pages_node()
> > before calling page_address() on it?
> > --
> 
>  Something like below I guess, but probably we could try to allocate
> on appropriate NUMA node first and if it fails -- via old alloc_pages
> and if it fail in turn -- then we panic.

Maybe my commit message was not clear : 

There is no need to test return from alloc_pages_node() and do the
fallback. It already done properly.

If NULL is returned, then there is no memory at all on the machine.

I tested my patch on my machine with node 1 with HighMem only, and
alloc_pages_node(1, flags, order) gave me a page from node 0.



