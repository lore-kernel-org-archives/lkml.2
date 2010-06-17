Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab0FQOuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:50:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:50176 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab0FQOut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:50:49 -0400
Date: Thu, 17 Jun 2010 23:50:35 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, mchan@broadcom.com, lethal@linux-sh.org,
       vapier@gentoo.org, JBottomley@novell.com, netdev@vger.kernel.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100617.073653.193708702.davem@davemloft.net>
References: <C27F8246C663564A84BB7AB3439772421B79CBCA1E@IRVEXCHCCR01.corp.ad.broadcom.com>
	<20100617211946A.fujita.tomonori@lab.ntt.co.jp>
	<20100617.073653.193708702.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100617234520S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 17 Jun 2010 23:50:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 07:36:53 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 17 Jun 2010 21:21:13 +0900
> 
> > On Wed, 16 Jun 2010 23:24:44 -0700
> > "Michael Chan" <mchan@broadcom.com> wrote:
> > 
> >> David, why is dma_is_consistent() always returning 1 on sparc?  The
> >> streaming DMA is not consistent.
> > 
> > I think that there are some confusion about dma_is_consistent(). Some
> > architectures think that dma_is_consistent() is supposed to return 1
> > if they can allocate coherent memory (note that some architectures
> > can't allocate coherent memory).
> 
> Right, and that's why it's defined this way.
> 
> If the desired meaning is different, just me know and I'll fix the
> sparc definition.

I think that there are some other architectures do the same. We need
to make sure that all the architectures define dma_is_consistent() in
the same meaning if drivers need it. However, I'm not sure we really
need dma_is_consistent(). There is only one user of it (and I think we
could remove it).

In the bnx2 case, we can simply prefetch on all the archs (or just
remove the optimization).
