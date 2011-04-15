Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1DOINV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:13:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47165 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1DOINS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:13:18 -0400
Date: Fri, 15 Apr 2011 09:12:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, Ramesh Gupta <grgupta@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2
	cache
Message-ID: <20110415081253.GA18952@n2100.arm.linux.org.uk>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <20110414223036.GA7335@n2100.arm.linux.org.uk> <BANLkTikfXbtsqaw5ZuP_BbDCtsxXOHZs_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikfXbtsqaw5ZuP_BbDCtsxXOHZs_w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:24:16AM +0900, KyongHo Cho wrote:
> That means we need to translate logical to physical address and it is
> sometimes not trivial.

What do you mean "sometimes not trivial" ?  The DMA does nothing more
than virt_to_phys(virt) to get the physical address.  It's _that_ simple.

If virt_to_phys(virt) is likely to fail, there's protection in the DMA API
to BUG_ON() in that case.

> Finally, the kernel will contain many similar routines that do same thing.

So when we get coherent DMA, you won't care that the DMA API functions
start doing nothing with caches?
