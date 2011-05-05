Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1EEN62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:58:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:55403 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1EEN61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:58:27 -0400
Date: Thu, 5 May 2011 15:58:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Dave Kleikamp <dkleikamp@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
In-Reply-To: <alpine.LFD.2.02.1105050110440.3005@ionos>
Message-ID: <alpine.LFD.2.02.1105051556580.3005@ionos>
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org> <alpine.LFD.2.02.1105050023070.3005@ionos> <20110504230349.GC2925@one.firstfloor.org> <alpine.LFD.2.02.1105050110440.3005@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Thomas Gleixner wrote:
> On Thu, 5 May 2011, Andi Kleen wrote:
> > > No, it does not even need refcounting. We can access it outside of the
> > 
> > Ok.
> > 
> > > lock as this is atomic context called on the cpu which is about to go
> > > idle and therefor the device cannot go away. Easy and straightforward
> > > fix.
> > 
> > Ok. Patch appended. Looks good?
> 
> Mostly. See below.
>  
> > BTW why must the lock be irqsave?
> 
> Good question. Probably safety frist paranoia :)
> 
> Indeed that code should only be called from irq disabled regions, so
> we could avoid the irqsave there. Otherwise that needs to be irqsave
> for obvious reasons.

Just looked through all the call sites. Both intel_idle and
processor_idle notify ENTER with interrups disabled, but EXIT with
interrupts enabled. So when we want to remove irqsave from the
spinlock that needs to be fixed as well.

Thanks,

        tglx
