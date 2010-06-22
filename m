Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab0FVRO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:14:56 -0400
Received: from complete.lackof.org ([198.49.126.79]:32960 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0FVROy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:14:54 -0400
Date: Tue, 22 Jun 2010 11:14:45 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: lethal@linux-sh.org, davem@davemloft.net, mchan@broadcom.com,
       vapier@gentoo.org, JBottomley@novell.com, netdev@vger.kernel.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bnx2 fails to compile on parisc because of missing
	get_dma_ops()
Message-ID: <20100622171445.GB8644@lackof.org>
References: <20100617.073653.193708702.davem@davemloft.net> <20100617234520S.fujita.tomonori@lab.ntt.co.jp> <20100617153051.GB8964@linux-sh.org> <20100622152823R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622152823R.fujita.tomonori@lab.ntt.co.jp>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 03:30:08PM +0900, FUJITA Tomonori wrote:
...
> > I don't see any harm in letting drivers know whether we can support
> > consistent DMA allocs for a given struct device or not though, even if
> > the micro-optimization is marginal at best.
> 
> I'm happier with exporting less DMA APIs to drivers because looks like
> new original ways to use the APIs wrongly can be always invented.

Agree.

...
> There are architectures that need to turn off the CPU cache for
> coherent memory, I can't find none of them that see if an address is
> coherent or not in dma_is_consistent().

parisc "knows" primarily based on chipset and then checks CPU model.
We hook in the correct dma_ops early in boot before any device drivers
are probed.

hth,
grant
