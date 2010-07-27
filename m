Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0G0LXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:23:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42828 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0G0LXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:23:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 27 Jul 2010 13:22:50 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH + an old question] firewire: ohci: use memory barriers to
 order descriptor updates
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.21d3972644f46dc9@s5r6.in-berlin.de>
Message-ID: <tkrat.a624272002398548@s5r6.in-berlin.de>
References: <tkrat.21d3972644f46dc9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jul, Stefan Richter wrote:
> 2. a write memory barrier between branch_address update and wake-up of
>    the DMA unit by MMIO register write.
> 
> This patch adds only barrier 1.
> 
> Barrier 2 is implicit in writel() on most machines --- or at least I
> think it is.  See this from arch/alpha/include/asm/io.h:

Typo, arch/x86/include/asm/io.h was meant.

>     #define build_mmio_write(name, size, type, reg, barrier) \
>     static inline void name(type val, volatile void __iomem *addr) \
>     { asm volatile("mov" size " %0,%1": :reg (val), \
>     "m" (*(volatile type __force *)addr) barrier); }
> 
>     build_mmio_write(writel, "l", unsigned int, "r", :"memory")
> 
> Does this order the mmio write relative to previous memory writes?
-- 
Stefan Richter
-=====-==-=- -=== ==-==
http://arcgraph.de/sr/

