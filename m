Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab0FQMVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:21:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:36465 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0FQMV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:21:29 -0400
Date: Thu, 17 Jun 2010 21:21:13 +0900
To: mchan@broadcom.com
Cc: davem@davemloft.net, lethal@linux-sh.org, vapier@gentoo.org,
       JBottomley@novell.com, netdev@vger.kernel.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <C27F8246C663564A84BB7AB3439772421B79CBCA1E@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <C27F8246C663564A84BB7AB3439772421B79CBCA1D@IRVEXCHCCR01.corp.ad.broadcom.com>
	<C27F8246C663564A84BB7AB3439772421B79CBCA1E@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100617211946A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 17 Jun 2010 21:21:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 23:24:44 -0700
"Michael Chan" <mchan@broadcom.com> wrote:

> Michael Chan wrote:
> >
> > Paul Mundt wrote:
> >
> > > If you want to have a micro-optimization for the consistent DMA
> > > case, you can check dma_is_consistent(), which is part of the API and
> > > will be variable on certain platform configurations (ie, some may be
> > > consistent with PCI but not on other busses, etc.)
> > >
> > >
> >
> > Thanks for the tip.  I didn't know about the dma_is_consistent() API.
> > I'll use this to fix it then.
> >
> 
> David, why is dma_is_consistent() always returning 1 on sparc?  The
> streaming DMA is not consistent.

I think that there are some confusion about dma_is_consistent(). Some
architectures think that dma_is_consistent() is supposed to return 1
if they can allocate coherent memory (note that some architectures
can't allocate coherent memory).
