Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027Ab0J2U7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:59:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58776 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab0J2U7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dpwOFAczwT9STe3acoBwbmEpp1L5xLQFmc4sxoTXDyga/cx/grMkm5rwa9X4a9xkD0
         hg2zmf9YTIDld5OdJkZCRwLJ02NVHUkpxKfKZ/6oImRlGsPiEPeqSqytVM/C24kaptN3
         NyNYec67JvQ73i8LQj2eLhv22FhrtBAQRliow=
Date: Sat, 30 Oct 2010 00:59:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
	allocations
Message-ID: <20101029205915.GC6130@lenovo>
References: <1288276854.2649.607.camel@edumazet-laptop> <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org> <1288377146.1988.0.camel@laptop> <20101029202809.GB6130@lenovo> <1288385587.2680.13.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288385587.2680.13.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 10:53:07PM +0200, Eric Dumazet wrote:
> Le samedi 30 octobre 2010 à 00:28 +0400, Cyrill Gorcunov a écrit :
> > On Fri, Oct 29, 2010 at 08:32:26PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> > > > +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> > > > +                                              THREAD_FLAGS,
> > > > +                                              THREAD_ORDER)); 
> > > 
> > > Shouldn't we be checking for a NULL return from alloc_pages_node()
> > > before calling page_address() on it?
> > > --
> > 
> 
> I didnt check for NULL because original code was not either.
> 
> If you cannot allocate memory for the IRQ stack, only choice is to crash
> anyway.
> 
> Adding BUG_ON() is not that helpful in this respect.
> 

 I believe it was a nit in first place, so the BUG_ON simply tells to code
readers that we knew the NULL can happen here but there is simply no way
to continue then.

 Cyrill
