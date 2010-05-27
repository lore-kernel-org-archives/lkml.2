Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0E0LSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:18:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55374 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0E0LSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:18:06 -0400
Date: Thu, 27 May 2010 13:17:58 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       Nicolas Palix <npalix@diku.dk>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
In-Reply-To: <20100527111136.GV3266@amd.com>
Message-ID: <Pine.LNX.4.64.1005271317180.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
 <20100527111136.GV3266@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Roedel, Joerg wrote:

> On Wed, May 26, 2010 at 11:55:59AM -0400, Julia Lawall wrote:
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression E1;
> > @@
> > 
> > * spin_lock(E1,...);
> >   <+... when != E1
> >   if (...) {
> >     ... when != E1
> > *   return ...;
> >   }
> >   ...+>
> > * spin_unlock(E1,...);
> > // </smpl>
> 
> Btw, I think it would be great to have a collection of these semantic
> match scripts in the kernel repository together with a build target to
> run these scripts over the kernel sources (like the cscope target).
> Opinions?

We have submitted and received some feedback on an initial version of 
this, but I'm not completely sure of the current status.

julia
