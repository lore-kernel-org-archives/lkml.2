Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2HEGjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 02:39:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45078 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2HEGjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 02:39:52 -0400
X-Auth-Info: X+T8ky+E0x+h6088fcsAUFM0Z6A1UYHa9//qpxv++1M=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Anton Blanchard <anton@au1.ibm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: Is iommu_num_pages() broken ?
References: <1344125816.24037.84.camel@pasglop>
X-Yow: Half a mind is a terrible thing to waste!
Date: Sun, 05 Aug 2012 08:39:39 +0200
In-Reply-To: <1344125816.24037.84.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Sun, 05 Aug 2012 10:16:56 +1000")
Message-ID: <m24nohsuz8.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> static inline unsigned long iommu_num_pages(unsigned long addr,
> 					    unsigned long len,
> 					    unsigned long io_page_size)
> {
> 	unsigned long size = (addr & (io_page_size - 1)) + len;
>
> 	return DIV_ROUND_UP(size, io_page_size);
> }
>  
>
> That doesn't look right to me...
>
> The powerpc iommu code at least uses that with an addr which may not be
> page aligned (ie, result of sg_virt() which include the offset).
>
> The above code will align the start before adding the len which is wrong

addr & (io_page_size - 1) computes the offset into the page pointed to
by addr.  Looks right to me.

addr & ~(io_page_size - 1) would round addr down to the start of the
page.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
