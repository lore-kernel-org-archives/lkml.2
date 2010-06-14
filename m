Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0FNNeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:34:36 -0400
Received: from www.tglx.de ([62.245.132.106]:56870 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0FNNee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:34:34 -0400
Date: Mon, 14 Jun 2010 15:34:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [ANNOUNCE] 2.6.33.5-rt23
In-Reply-To: <1276185406.15867.390.camel@lexx>
Message-ID: <alpine.LFD.2.00.1006141534050.3026@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>  <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>  <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>  <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain> 
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>  <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>  <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>  <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain> 
 <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>  <1276119074.15867.311.camel@lexx>  <alpine.LFD.2.00.1006100800330.2933@localhost.localdomain> <1276185406.15867.390.camel@lexx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Will Schmidt wrote:

> On Thu, 2010-06-10 at 08:07 +0200, Thomas Gleixner wrote:
> > On Wed, 9 Jun 2010, Will Schmidt wrote:
> > 
> > > On Wed, 2010-06-09 at 18:44 +0200, Thomas Gleixner wrote:
> > > I'm still on 2.6.33.5-rt22 on powerpc, and have run into a couple
> > > "sleeping function called from invalid context..." BUGs.   The first was
> > > during system boot, second during a 'make'.
> > > 
> > > relevant code paths don't seem to have changed between -rt22 and -rt23,
> > > so I think still valid.. :-)  
> > > 
> > > This is on a POWER7 system, which may have opened up some timing
> > > windows, wrt previous runs on POWER6 systems.
> > > 
> > > 
> > > BUG: sleeping function called from invalid context at
> > > kernel/rtmutex.c:684
> > 
> > > [c000000078cf2cf0] [c000000000131a04] .irq_to_desc_alloc_node+0xdc/0x2b8
> > 
> > Grr. I thought I had the SPARSE_IRQ stuff disabled on -rt, but seems
> > it came back somehow. Can you disable that, or does you machine depend
> > on it ?
> 
> I'm not sure whether it is required by the architecture.  I do see that
> SPARSE_IRQ is disabled in arch/x86/Kconfig with a !PREEMPT_RT, but I
> don't see an equivalent 'disable' in arch/powerpc/Kconfig.  

Can you disable it ?

Thanks,

	tglx
