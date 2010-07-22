Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab0GVNlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:41:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44522 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757995Ab0GVNlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:41:00 -0400
Date: Thu, 22 Jul 2010 14:40:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Xiaolin Zhang'" <xiaolin.zhang@intel.com>,
        "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'Robert Fekete'" <robert.fekete@stericsson.com>,
        "'Marcus Lorentzon'" <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
Message-ID: <20100722134056.GJ4737@rakim.wolfsonmicro.main>
References: <20100721135229.GC10930@sirena.org.uk>
 <op.vf66mxka7p4s8u@pikus>
 <20100721182457.GE10930@sirena.org.uk>
 <op.vf7h6ysh7p4s8u@pikus>
 <20100722090602.GF10930@sirena.org.uk>
 <000901cb297f$e28f2b10$a7ad8130$%szyprowski@samsung.com>
 <20100722105203.GD4737@rakim.wolfsonmicro.main>
 <op.vf8sxqro7p4s8u@pikus>
 <20100722124559.GH4737@rakim.wolfsonmicro.main>
 <op.vf8x60wi7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vf8x60wi7p4s8u@pikus>
X-Cookie: Sauron is alive in Argentina!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:24:26PM +0200, Michał Nazarewicz wrote:

> That's why command line is only intended as a way to overwrite the
> defaults which are provided by the platform.  In a final product,
> configuration should be specified in platform code and not on
> command line.

Yeah, agreed though I'm not convinced we can't do it via userspace
(initrd would give us a chance to do stuff early) or just kernel
rebuilds.

> >It sounds like apart from the way you're passing the configuration in
> >you're doing roughly what I'd suggest.  I'd expect that in a lot of
> >cases the map could be satisfied from the default region so there'd be
> >no need to explicitly set one up.

> Platform can specify something like:

> 	cma_defaults("reg=20M", "*/*=reg");

> which would make all the drivers share 20 MiB region by default.  I'm also
> thinking if something like:

Yes, exactly - probably you can even have a default region backed by
normal vmalloc() RAM which would at least be able to take a stab at
working by default.
