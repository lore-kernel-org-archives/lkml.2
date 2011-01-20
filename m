Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1ATLMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:12:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46498 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1ATLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SExkOeXaavNaDVC6gVizj8/5zo7KD9nWRSFvZM4glUWi1hHdl3v0lZHz2HLB/+eSU1
         UBL7Wc/dEV+6wgbkmi22tRPihzg3ct90OIKZqKRUBirgoubLra+4YpjNGvF97BjANjEb
         +Sy19wSMCZXR1POiMNAlslancp09RbKlga4m8=
Subject: Re: percpu related boot crash on x86
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1295520467.28776.153.camel@laptop>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119120200.GA1057@elte.hu> <1295441307.28776.15.camel@laptop>
	 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
	 <20110119131329.GB14096@mtj.dyndns.org> <20110119205353.GA14810@elte.hu>
	 <20110119231116.GA3896@elte.hu>  <4D37F2C9.8000906@kernel.org>
	 <1295520467.28776.153.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 12:12:47 +0100
Message-ID: <1295521967.2825.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 janvier 2011 à 11:47 +0100, Peter Zijlstra a écrit :
> On Thu, 2011-01-20 at 10:31 +0200, Pekka Enberg wrote:
> >    if (!irqs_disabled())
> > 
> > guard around the debugging code to make vfree() always work with IRQs 
> > disabled. 
> 
> That won't be sufficient, __purge_vmap_area_lazy() needs to call
> flush_tlb_kernel_range() occasionally.
> 
> There really is a good reason vmalloc()/vfree() don't work with
> interrupts disabled.
> 

Hmm, I would try to increase PERCPU_DYNAMIC_RESERVE, or pcpu_mem_alloc()
could try to use kzalloc() even for allocations bigger than one PAGE,
and fallback to vzalloc().

We have more alloc_percpu() uses, we also should try to use first chunk
if possible.



