Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab0E0Lmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:42:37 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36853 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759018Ab0E0Lm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:42:28 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
Date: Thu, 27 May 2010 13:42:25 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk> <20100527111136.GV3266@amd.com> <Pine.LNX.4.64.1005271317180.5422@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005271317180.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271342.25619.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010 13:17:58 Julia Lawall wrote:
> On Thu, 27 May 2010, Roedel, Joerg wrote:
> 
> > On Wed, May 26, 2010 at 11:55:59AM -0400, Julia Lawall wrote:
> > > The semantic match that finds this problem is as follows:
> > > (http://coccinelle.lip6.fr/)
> > > 
> > > // <smpl>
> > > @@
> > > expression E1;
> > > @@
> > > 
> > > * spin_lock(E1,...);
> > >   <+... when != E1
> > >   if (...) {
> > >     ... when != E1
> > > *   return ...;
> > >   }
> > >   ...+>
> > > * spin_unlock(E1,...);
> > > // </smpl>
> > 
> > Btw, I think it would be great to have a collection of these semantic
> > match scripts in the kernel repository together with a build target to
> > run these scripts over the kernel sources (like the cscope target).
> > Opinions?
> 
> We have submitted and received some feedback on an initial version of 
> this, but I'm not completely sure of the current status.

You can see the latest feedback we get at
http://lkml.org/lkml/2010/5/10/257

The initial submission and its comments are at
http://lkml.org/lkml/2010/4/26/269

> 
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
