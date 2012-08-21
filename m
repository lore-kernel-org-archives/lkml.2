Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2HUNAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:00:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9444 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2HUNAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:00:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Aug 2012 05:59:51 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>
Date: Tue, 21 Aug 2012 14:59:45 +0200
Subject: Re: [PATCHv6 2/2] ARM: dma-mapping: remove custom consistent dma
 region
Thread-Topic: [PATCHv6 2/2] ARM: dma-mapping: remove custom consistent dma
 region
Thread-Index: Ac1/nNbl9qDffmnVSIKMD6Aa0McjAg==
Message-ID: <20120821.155945.1711711797763144039.hdoyu@nvidia.com>
References: <1343636899-19508-3-git-send-email-m.szyprowski@samsung.com><20120821142235.97984abc9ad98d01015a3338@nvidia.com><20120821123451.GV18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120821123451.GV18957@n2100.arm.linux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote @ Tue, 21 Aug 2012 14:34:51 +0200:

> On Tue, Aug 21, 2012 at 02:22:35PM +0300, Hiroshi Doyu wrote:
> > The following "__get_vm_area_node()" can take gfp_mask, it means that
> > this function is expected to be called from atomic context, but why
> > it's _NOT_ allowed _ONLY_ from interrupt context?
> 
> One reason is it takes read/write locks without using the IRQ safe
> versions for starters (vmap_area_lock and vmlist_lock).  I don't see
> any other reasons in that bit of code though.

IIRC, if *_{irqsave,irqrestore} versions were introduced to protect
from IRQ context, could we remove this BUG_ON(in_interrupt()) in
__get_vm_area_node() at least? Or is it not encouraged from
performance POV?

It seems that the solution to allow IOMMU'able device driver to
allocate from ISR are:
(1) To provide the pre-allocate area like arm_dma_alloc() does,
or
(2) __get_vm_area_node() can be called from ISR.
