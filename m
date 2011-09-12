Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1ILOaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:30:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:33880 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab1ILOai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:30:38 -0400
Date: Mon, 12 Sep 2011 16:30:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Salter <msalter@redhat.com>
cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: [PATCH 11/24] C6X: interrupt handling
In-Reply-To: <1315837623.11280.14.camel@deneb.redhat.com>
Message-ID: <alpine.LFD.2.02.1109121629450.2723@ionos>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>  <1314826019-22330-12-git-send-email-msalter@redhat.com>  <alpine.LFD.2.02.1109091619350.2723@ionos> <1315837623.11280.14.camel@deneb.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011, Mark Salter wrote:

> On Fri, 2011-09-09 at 16:33 +0200, Thomas Gleixner wrote:
> > On Wed, 31 Aug 2011, Mark Salter wrote:
> > 
> > > + *
> > > + *  Large parts taken directly from powerpc.
> > 
> > Is it really necessary to copy that stuff instead of generalizing it ?
> > I guess that's mostly about the reverse map & Co.
> 
> I have a patch that takes the code out of powerpc and puts in kernel/irq
> where both powerpc and c6x can use it. That leaves us with two files in
> kernel/irq trying to manage hw <--> virt mappings. So, some merging of
> irqdomain.c and the former powerpc code is needed. I'm not sure how that
> should go. At the moment, irqdomain doesn't support dynamic allocation
> of irq_descs, so its not currently suitable for powerpc or c6x.

Grant was working on that as well. You should talk to him.
 
> 
> > > +/*
> > > + * IRQ controller and virtual interrupts
> > > + */
> > 
> > How different is this from PPC ? Looks fairly familiar to me :)
> 
> I had changed it in a few minor ways, but looking again, I probably
> didn't need to change it at all. In the patch to generalize it, I
> simply did s/NUM_ISA_INTERRUPTS/NR_IRQS_LEGACY/.

Thanks,

	tglx
