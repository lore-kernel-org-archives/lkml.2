Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1BPQ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:26:09 -0500
Received: from www.tglx.de ([62.245.132.106]:35153 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1BPQ0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:26:07 -0500
Date: Wed, 16 Feb 2011 17:25:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
cc: xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Xen and incorporating event channels in to nr_irqs
In-Reply-To: <1297872739.16356.261.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.00.1102161722290.2701@localhost6.localdomain6>
References: <1297868399.16356.180.camel@zakaz.uk.xensource.com>  <alpine.LFD.2.00.1102161638320.2701@localhost6.localdomain6> <1297872739.16356.261.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Ian Campbell wrote:

> On Wed, 2011-02-16 at 15:56 +0000, Thomas Gleixner wrote:
> > I'm about to remove the nr_irqs NR_IRQS limitation. It's silly when we
> > deal with sparse irqs. So the idea is to have the initial nr_irqs set
> > in early boot to have a sensible size for allocating stuff. Later on
> > we can expand nr_irqs when the need arises.
> 
> > It's not only Xen which wants to eliminate the limitation. Think about
> > irq expanders which are detected late in the boot. We have no sensible
> > way to reserve enough numbers for them at early boot as we dont know
> > whether that hardware is there or not.
> > 
> > So my plan for .39 is to ignore the NR_IRQS limitation in the sparse
> > case and make nr_irqs expandable of course with a sensible upper limit
> > in the core code itself. It's basically the allocation bitmap which
> > limits it, but I doubt we'll hit 1 Million irq numbers in the
> > forseeable future.
> 
> That sounds ideal, thanks! 
> 
> I was hoping to get rid of the workaround in Xen events.c in the 2.6.39
> timeframe too.
> 
> If you let me know when you have something I can test I'll combine with
> the Xen side and give it a spin.
> 
> On a vaguely related note, what is the future of non-sparse IRQs (on x86
> and/or generally)?

In general I want to switch everything over to SPARSE_IRQ. When the
open coded access to irq_desc[] is gone, which should be mostly the
case in .39 then switching everything over should be a smooth
thing. For those archs which do not want to adjust the numbers
dynamically we simple allocate NR_IRQS in early_irq_init(). So they
wont even notice.

Thanks,

	tglx
