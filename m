Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1FAPuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:50:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52078 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1FAPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:50:48 -0400
Date: Wed, 1 Jun 2011 16:50:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Samuel Ortiz <samuel@sortiz.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: IrDA driver fails on PXA255
Message-ID: <20110601155016.GM3660@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com> <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com> <20110529215656.GA5576@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105302202510.18793@chino.kir.corp.google.com> <20110531072650.GC21382@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105311253510.5646@chino.kir.corp.google.com> <20110531210027.GA3660@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105311501570.16259@chino.kir.corp.google.com> <20110601075420.GB3660@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601075420.GB3660@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 08:54:20AM +0100, Russell King - ARM Linux wrote:
> On Tue, May 31, 2011 at 03:11:40PM -0700, David Rientjes wrote:
> > The restriction isn't new: GFP_DMA only makes sense with CONFIG_ZONE_DMA.  
> > The fact that the page allocator completely ignored GFP_DMA in the past 
> > for CONFIG_ZONE_DMA=n doesn't change that.  That's obviously error prone 
> > since it will return memory from anywhere simply because of the fact that 
> > it is an invalid configuration.
> 
> Your approach to this is wrong.  Make it warn for one release.  Give
> people a chance to fix things before they become a regression.  Then
> make it a hard failure.

And to prove that its not just this driver, I've now received a report
that it fails with the CF PATA driver on Zaurus.  Should we make the
PATA subsystem select CONFIG_ZONE_DMA too, or should we give people
some grace period to fix the drivers as _everyone_ except you is
suggesting.

Please do the sensible thing.  Make it warn for a release like everyone
is telling you to.
