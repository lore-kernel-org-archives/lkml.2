Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab2EXRzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:55:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28876 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2EXRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:55:03 -0400
Date: Thu, 24 May 2012 13:47:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] swiotlb: add "dma_attrs" argument to alloc and free, to
 match dma_map_ops
Message-ID: <20120524174741.GG24934@phenom.dumpdata.com>
References: <20120524114422.GA25950@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524114422.GA25950@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:44:22PM +0200, Alessandro Rubini wrote:
> The alloc and free pointers within "struct dma_map_ops" receive a
> pointer to dma_attrs that was not present in the generic swiotlb
> functions.  For this reason, a few files had a local wrapper for the
> free function that just removes the attrs argument before calling the
> generic function.
> 
> This patch adds the extra argument to generic functions and removes
> such wrappers when they are no more needed.  This also fixes a
> compiler warning for sta2x11-fixup.c, that would have required yet
> another wrapper.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/ia64/kernel/pci-swiotlb.c       |   11 ++---------
>  arch/mips/cavium-octeon/dma-octeon.c |    4 ++--
>  arch/unicore32/mm/dma-swiotlb.c      |   22 ++--------------------
>  arch/x86/kernel/pci-swiotlb.c        |   11 ++---------
>  arch/x86/pci/sta2x11-fixup.c         |    3 ++-
>  include/linux/swiotlb.h              |    7 ++++---
>  lib/swiotlb.c                        |    5 +++--

So .. what is this based on? I see in mainline  alloc_coherent and free_coherent
which are obviously changed here.

Don't you also need to change these two files:

 arch/x86/xen/pci-swiotlb-xen.c
 drivers/xen/swiotlb-xen.c
