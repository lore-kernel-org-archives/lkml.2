Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab1D1K1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:27:24 -0400
Received: from 8bytes.org ([88.198.83.132]:51752 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1D1K1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:27:22 -0400
Date: Thu, 28 Apr 2011 12:27:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428102720.GA13402@8bytes.org>
References: <201104212129.17013.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104212129.17013.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:29:16PM +0200, Arnd Bergmann wrote:
> 4. Implement an architecture independent version of dma_map_ops
>    based on the iommu.h API. As Joerg mentioned, this has been
>    missing for some time, and it would be better to do it once
>    than for each IOMMU separately. This is probably a lot of work.

Yes, thats missing for a long time. It will also need some changes to
the IOMMU-API but that should be doable. The best would be to extend the
IOMMU-API so that it also supports GART-like IOMMUs. This way every
dma_ops implementation on all the architectures providing such an IOMMU
could be covered with the architecture independent dma_ops
implementation. This would only leave the low-level hardware access in
the IOMMU drivers.
I think this also requires to change the current semantics of the
existing IOMMU-API implementations. I will prepare a write-up of my
ideas for discussion.

Regards,

	Joerg

