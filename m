Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0GVFiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:38:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:33827 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0GVFiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:38:11 -0400
Date: Thu, 22 Jul 2010 14:37:49 +0900
To: corbet@lwn.net
Cc: m.nazarewicz@samsung.com, linux-mm@kvack.org, m.szyprowski@samsung.com,
        p.osciak@samsung.com, xiaolin.zhang@intel.com, hvaibhav@ti.com,
        robert.fekete@stericsson.com, marcus.xm.lorentzon@stericsson.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100720181239.5a1fd090@bike.lwn.net>
References: <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
	<adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
	<20100720181239.5a1fd090@bike.lwn.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100722143652V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 22 Jul 2010 14:37:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 18:12:39 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> One other thing occurred to me as I was thinking about this...
> 
> > +    There are four calls provided by the CMA framework to devices.  To
> > +    allocate a chunk of memory cma_alloc() function needs to be used:
> > +
> > +            unsigned long cma_alloc(const struct device *dev,
> > +                                    const char *kind,
> > +                                    unsigned long size,
> > +                                    unsigned long alignment);
> 
> The purpose behind this interface, I believe, is pretty much always
> going to be to allocate memory for DMA buffers.  Given that, might it
> make more sense to integrate the API with the current DMA mapping
> API?

IMO, having separate APIs for allocating memory and doing DMA mapping
is much better. The DMA API covers the latter well. We could extend
the current API to allocate memory or create new one similar to the
current. 

I don't see any benefit of a new abstraction that does both magically.


About the framework, it looks too complicated than we actually need
(the command line stuff looks insane).

Why can't we have something simpler, like using memblock to reserve
contiguous memory at boot and using kinda mempool to share such memory
between devices?
