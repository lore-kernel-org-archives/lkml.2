Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab2CHXgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:36:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:35248 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab2CHXgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:36:14 -0500
Message-ID: <1331249746.3105.40.camel@pasglop>
Subject: Re: linux-next: manual merge of the powerpc tree with the arm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Russell King <rmk@arm.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Date: Fri, 09 Mar 2012 10:35:46 +1100
In-Reply-To: <1331185951.3105.29.camel@pasglop>
References: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>
	 <25744.1331174036@neuling.org>
	 <20120308145131.fad50bbc79c36f0b0b12d101@canb.auug.org.au>
	 <1331185951.3105.29.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:52 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2012-03-08 at 14:51 +1100, Stephen Rothwell wrote:
> > Hi Mikey,
> > 
> > On Thu, 08 Mar 2012 13:33:56 +1100 Michael Neuling <mikey@neuling.org> wrote:
> > >
> > > Surely we only need SPARSE_IRQ now and not MAY_HAVE_SPARSE_IRQ.  
> > > 
> > > In fact, keeping MAY_HAVE_SPARSE_IRQ seems to make SPARSE_IRQ user
> > > selectable, which we don't want anymore since ad5b7f1350c2.
> > 
> > Yes, indeed. I will fix up the merge resolution for tomorrow.
> 
> This is my fault. Grant's patch had a collision and I manually fixed it
> up. While doing that, I put back MAY_HAVE_SPARSE_IRQ which the patch
> originally took out.

Actually, I didn't keep MAY_HAVE_SPARSE_IRQ, I kept HAVE_SPARSE_IRQ. If
I remove it, then I get Kconfig warnings:

warning: (PPC) selects SPARSE_IRQ which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS && HAVE_SPARSE_IRQ)

Cheers,
Ben.


