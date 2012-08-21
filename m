Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab2HUNGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:06:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47776 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757638Ab2HUNGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:06:15 -0400
Date: Tue, 21 Aug 2012 14:05:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 14/31] arm64: DMA mapping API
Message-ID: <20120821130539.GD12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
 <20120815004006.GG19607@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815004006.GG19607@quad.lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:40:06AM +0100, Olof Johansson wrote:
> On Tue, Aug 14, 2012 at 06:52:15PM +0100, Catalin Marinas wrote:
> > +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> > +{
> > +	if (unlikely(!dev) || !dev->archdata.dma_ops)
> > +		return dma_ops;
> > +	else
> > +		return dev->archdata.dma_ops;
> > +}
> 
> Does it make sense to add the concept of a global dma ops on arm64,
> instead of requiring the dma ops pointer per device similar to how
> some other platforms do it (including powerpc)? For devices that lack
> archdata.dma_ops, dma_supported() should return 0 (and the other ops
> should return error).

If the device doesn't have archdata.dma_ops we return the default
implementation which is currently based on swiotlb. Do you mean that
this shouldn't be the case and just let the device always set
archdata.dma_ops?

-- 
Catalin
