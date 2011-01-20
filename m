Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1ATKrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:47:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57132 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1ATKrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:47:23 -0500
Subject: Re: percpu related boot crash on x86
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D37F2C9.8000906@kernel.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119120200.GA1057@elte.hu> <1295441307.28776.15.camel@laptop>
	 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
	 <20110119131329.GB14096@mtj.dyndns.org> <20110119205353.GA14810@elte.hu>
	 <20110119231116.GA3896@elte.hu>  <4D37F2C9.8000906@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 Jan 2011 11:47:47 +0100
Message-ID: <1295520467.28776.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 10:31 +0200, Pekka Enberg wrote:
>    if (!irqs_disabled())
> 
> guard around the debugging code to make vfree() always work with IRQs 
> disabled. 

That won't be sufficient, __purge_vmap_area_lazy() needs to call
flush_tlb_kernel_range() occasionally.

There really is a good reason vmalloc()/vfree() don't work with
interrupts disabled.


