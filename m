Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2IVUAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 16:00:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35079 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2IVUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 16:00:29 -0400
Date: Sat, 22 Sep 2012 16:00:27 -0400 (EDT)
Message-Id: <20120922.160027.1528491047223302539.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: sfr@canb.auug.org.au, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        mika.westerberg@linux.intel.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348264000.1132.63.camel@pasglop>
References: <1348179764.1132.35.camel@pasglop>
	<20120920.185315.576326460331670020.davem@davemloft.net>
	<1348264000.1132.63.camel@pasglop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sat, 22 Sep 2012 07:46:40 +1000

> Right, but on ppc, GFP_DMA is a nop (no separate ZONE_DMA, or rather all
> of memory is ZONE_DMA). It's always been like that afaik.
> 
> We could support ISA device limited addressability using the iommu but
> that would involve a map/unmap type API (which I remember we did support
> in the old days by passing NULL to pci_map_*, but we dropped that along
> the way).

I think I'm going to just end up restricting this driver to X86
as was originally suggested.

There seems to be no real consistent Kconfig protection for users
of isa_virt_to_bus() and friends.

We know that ISA_DMA_API doesn't do it, and ISA doesn't do it either
as powerpc also allows that to bet set for CHRP and friends.

Thanks.
