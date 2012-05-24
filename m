Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2EXPPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:15:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44797 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2EXPPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:15:21 -0400
Message-ID: <4FBE5085.2090904@gmail.com>
Date: Thu, 24 May 2012 08:15:17 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] swiotlb: add "dma_attrs" argument to alloc and free,
 to match dma_map_ops
References: <20120524114422.GA25950@mail.gnudd.com>
In-Reply-To: <20120524114422.GA25950@mail.gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 04:44 AM, Alessandro Rubini wrote:
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
> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>
> Cc: Tony Luck<tony.luck@intel.com>
> Cc: Fenghua Yu<fenghua.yu@intel.com>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> Cc: Guan Xuetao<gxt@mprc.pku.edu.cn>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Kyungmin Park<kyungmin.park@samsung.com>
> Cc: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> ---
>   arch/ia64/kernel/pci-swiotlb.c       |   11 ++---------
>   arch/mips/cavium-octeon/dma-octeon.c |    4 ++--
>   arch/unicore32/mm/dma-swiotlb.c      |   22 ++--------------------
>   arch/x86/kernel/pci-swiotlb.c        |   11 ++---------
>   arch/x86/pci/sta2x11-fixup.c         |    3 ++-
>   include/linux/swiotlb.h              |    7 ++++---
>   lib/swiotlb.c                        |    5 +++--
>   7 files changed, 17 insertions(+), 46 deletions(-)
>

This looks sane (although I haven't tested it).  For the OCTEON bits:

Acked-by: David Daney <david.daney@cavium.com>


