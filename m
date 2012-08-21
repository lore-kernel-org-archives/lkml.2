Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2HUMfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:35:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41989 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab2HUMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:35:18 -0400
Date: Tue, 21 Aug 2012 13:34:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Subash Patel <subashrp@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCHv6 2/2] ARM: dma-mapping: remove custom consistent dma
	region
Message-ID: <20120821123451.GV18957@n2100.arm.linux.org.uk>
References: <1343636899-19508-1-git-send-email-m.szyprowski@samsung.com> <1343636899-19508-3-git-send-email-m.szyprowski@samsung.com> <20120821142235.97984abc9ad98d01015a3338@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821142235.97984abc9ad98d01015a3338@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:22:35PM +0300, Hiroshi Doyu wrote:
> The following "__get_vm_area_node()" can take gfp_mask, it means that
> this function is expected to be called from atomic context, but why
> it's _NOT_ allowed _ONLY_ from interrupt context?

One reason is it takes read/write locks without using the IRQ safe
versions for starters (vmap_area_lock and vmlist_lock).  I don't see
any other reasons in that bit of code though.
