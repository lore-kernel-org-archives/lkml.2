Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0EQJAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:00:35 -0400
Received: from www.tglx.de ([62.245.132.106]:47897 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0EQJAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:00:33 -0400
Date: Mon, 17 May 2010 11:00:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
       "Brown, Len" <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: unify current 3 similar ways of saving IRQ info
In-Reply-To: <20100517164244.3fc80d60@feng-i7>
Message-ID: <alpine.LFD.2.00.1005171059110.3368@localhost.localdomain>
References: <20100517153156.4439d62b@feng-i7> <alpine.LFD.2.00.1005171004500.3368@localhost.localdomain> <20100517162521.6fc93552@feng-i7> <alpine.LFD.2.00.1005171016150.3368@localhost.localdomain> <20100517164244.3fc80d60@feng-i7>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Feng Tang wrote:
> On Mon, 17 May 2010 16:16:40 +0800
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Mon, 17 May 2010, Feng Tang wrote:
> > 
> > > On Mon, 17 May 2010 16:07:05 +0800
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > On Mon, 17 May 2010, Feng Tang wrote:
> > > > 
> > > > >  {
> > > > >  	if (mp_irq->dstapic != m->dstapic)
> > > > > @@ -211,7 +211,8 @@ static int __init
> > > > > mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq, return 0;
> > > > >  }
> > > > >  
> > > > > -static void __init MP_intsrc_info(struct mpc_intsrc *m)
> > > > > +/* Will also be called in acpi/sfi related code */
> > > > > +void mp_save_irq(struct mpc_intsrc *m)
> > > > 
> > > >   Again, this code is called from __init context only and should
> > > > stay __init.
> > > 
> > > Hi Thomas,
> > > 
> > > The reason I removed the __init is it will be called by non __init
> > > functions from acpi/boot.c and mrst.c
> > 
> > Why should that happen ?
> 
> The place calling this API from mrst.c should be changed to __init, for acpi,
> it will be called by acpi_register_gsi(), which is exported out and used by
> several places in drivers/

Ok, missed the acpi_register_gsi() context.
 
Thanks,

	tglx
