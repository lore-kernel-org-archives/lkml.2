Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab0GUAMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:12:43 -0400
Received: from tex.lwn.net ([70.33.254.29]:37102 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab0GUAMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:12:42 -0400
Date: Tue, 20 Jul 2010 18:12:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
Message-ID: <20100720181239.5a1fd090@bike.lwn.net>
In-Reply-To: <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
	<d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
	<adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One other thing occurred to me as I was thinking about this...

> +    There are four calls provided by the CMA framework to devices.  To
> +    allocate a chunk of memory cma_alloc() function needs to be used:
> +
> +            unsigned long cma_alloc(const struct device *dev,
> +                                    const char *kind,
> +                                    unsigned long size,
> +                                    unsigned long alignment);

The purpose behind this interface, I believe, is pretty much always
going to be to allocate memory for DMA buffers.  Given that, might it
make more sense to integrate the API with the current DMA mapping API?
Then the allocation function could stop messing around with long values
and, instead, just hand back a void * kernel-space pointer and a
dma_addr_t to hand to the device.  That would make life a little easier
in driverland...

jon
