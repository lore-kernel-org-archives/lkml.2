Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0DECTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 22:19:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:52524 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab0DECTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 22:19:30 -0400
Date: Mon, 5 Apr 2010 11:12:54 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH] swiotlb v0.6: seperation of physical/virtual address
	translation
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100405110317R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 05 Apr 2010 11:13:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 11:04:17 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> Fujita-san et al.
> 
> Attached is a set of patches that separate the address translation
> (virt_to_phys, virt_to_bus, etc) from the SWIOTLB library.
> 
> Since the last posting I've:
>  - Made the exported functions/variables have the 'swiotlb_bk' prefix instead
>    of the 'do_[map|unmap]*' and 'io_tlb_*' combination.

Why can't we use more simpler names such as 'swiotlb_tbl_index'?

Why do we need to add the prefix to static things like
'swiotlb_bk_list', 'swiotlb_bk_index', etc? Please let them alone.


>  - dropped the checkpatches/other reworks patches.
> 
> I had not addressed the question of removing the 'overflow' buffer. There are over
> ~300 instances of the the DMA operations not being checked which plan on addressing
> in a seperate set of patches that will slowly roll out the checks and then
> finally the removal of the 'overflow' buffer.

Except for swiotlb, no IOMMU implementations has the mechanism of
overflow buffer. So drivers that don't check a DMA mapping error are
broken anyway. Also the size of the overflow is 32K by default. We
often see larger request than that. Even with the overflow mechanism,
we see data corruption anyway.
