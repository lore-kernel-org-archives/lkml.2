Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1ATLTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:19:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57264 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1ATLTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TGcxcfW6W4lJlxkANhvf+AvNN8u8rKlWaVEXKodseWYTkzVsLA+1NwfDlrSDbgGNnE
         cNb8XD25j+lvs866oD0Eh6S1k+t82zoiCJk8xUlbghg9L9i61wLcb62e5nOtbUFhIzlG
         DS1wLQ+jHXKhGdLhYyZMlUabhNYApt6rTtR+w=
Date: Thu, 20 Jan 2011 12:19:27 +0100
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: percpu related boot crash on x86
Message-ID: <20110120111927.GE6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <1295441307.28776.15.camel@laptop>
 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
 <20110119131329.GB14096@mtj.dyndns.org>
 <20110119205353.GA14810@elte.hu>
 <20110119231116.GA3896@elte.hu>
 <4D37F2C9.8000906@kernel.org>
 <1295520467.28776.153.camel@laptop>
 <1295521967.2825.15.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295521967.2825.15.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 20, 2011 at 12:12:47PM +0100, Eric Dumazet wrote:
> Le jeudi 20 janvier 2011 à 11:47 +0100, Peter Zijlstra a écrit :
> > On Thu, 2011-01-20 at 10:31 +0200, Pekka Enberg wrote:
> > >    if (!irqs_disabled())
> > > 
> > > guard around the debugging code to make vfree() always work with IRQs 
> > > disabled. 
> > 
> > That won't be sufficient, __purge_vmap_area_lazy() needs to call
> > flush_tlb_kernel_range() occasionally.
> > 
> > There really is a good reason vmalloc()/vfree() don't work with
> > interrupts disabled.
> 
> Hmm, I would try to increase PERCPU_DYNAMIC_RESERVE, or pcpu_mem_alloc()
> could try to use kzalloc() even for allocations bigger than one PAGE,
> and fallback to vzalloc().

It already handles all those stuff.  As I wrote in the other message,
I don't think this problem has much to do with percpu allocator
itself.

> We have more alloc_percpu() uses, we also should try to use first chunk
> if possible.

Yeah, but that's true.  It's probably too small at this point.  Maybe
there should be a way to monitor percpu memory status, a proc entry or
something so that we can have more data on sizing.

Thanks.

-- 
tejun
