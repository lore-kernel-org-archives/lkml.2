Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1LNPEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:04:13 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38966 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204Ab1LNPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:04:09 -0500
X-Sasl-enc: ALxR8BclGRBa/LunYFD2AY9vK8KnEZ9Wu1Mx2fFfAUB9 1323875048
Date: Wed, 14 Dec 2011 07:03:59 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20111214150359.GA840@kroah.com>
References: <20111214154844.3ad4e1d685c7987cba0820a0@canb.auug.org.au>
 <1323854697.28489.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323854697.28489.7.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:24:57AM +0100, Peter Zijlstra wrote:
> On Wed, 2011-12-14 at 15:48 +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the driver-core tree, today's linux-next build
> > (powerpc_ppc64_defconfig) failed like this:
> > 
> > In file included from include/linux/slab.h:185:0,
> >                  from include/linux/kref.h:19,
> >                  from include/linux/kobject.h:24,
> >                  from include/linux/sysdev.h:24,
> >                  from include/linux/node.h:17,
> >                  from include/linux/swap.h:10,
> >                  from include/linux/suspend.h:4,
> >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > include/linux/slub_def.h:100:17: error: field 'kobj' has incomplete type
> > 
> > Caused by commit 4af679cd7cbb ("kref: Inline all functions") ... we now
> > have kref.h -> slab.h -> slub_def.h -> kobject.h -> kref.h when
> > CONFIG_SLUB is set.
> 
> Egads, that's nasty.. 
> 
> The nicest thing I can come up with is something like the below, but its
> not all that nice at all :/

I'll remove the use of kfree in the WARN_ON(), which should solve this
problem.

greg k-h
