Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab1KVPfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:35:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35727 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab1KVPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:35:41 -0500
Message-ID: <4ECCA102.4040501@gmail.com>
Date: Tue, 22 Nov 2011 23:30:10 -0800
From: cody <mail.kai.huang@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Alex Williamson <alex.williamson@redhat.com>, rajesh.sankaran@intel.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ddutile@redhat.com
Subject: Re: [PATCH] intel-iommu: Manage iommu_coherency globally
References: <20111116040752.11878.18642.stgit@bling.home> <1321617817.15493.33.camel@shinybook.infradead.org>
In-Reply-To: <1321617817.15493.33.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 04:03 AM, David Woodhouse wrote:
>
> Hm, it seems I lied to you about this. The non-coherent mode isn't just
> a historical mistake; it's configurable by the BIOS, and we actually
> encourage people to use the non-coherent mode because it makes the
> hardware page-walk faster — so reduces the latency for IOTLB misses.
>
>    
I have a question, Intel VT-d manual says the coherency bit is "RO", how 
can it be configurable by the BIOS? Or there's another way to configure 
the IOMMU to be coherent or non-coherent? (I didn't find such info in 
the manual. I missed it?)

-cody
> In addition to that, the IOMMU associated with the integrated graphics
> is so "special" that it doesn't support coherent mode either. So it *is*
> quite feasible that we'll see a machine where some IOMMUs support
> coherent mode, and some don't.
>
> And thus we do need to address the concern that just assuming
> non-coherent mode will cause unnecessary performance issues, for the
> case where a domain *doesn't* happen to include any of the non-coherent
> IOMMUs.
>
> However... for VM domains I don't think we care. Setting up the page
> tables *isn't* a fast path there (at least not until/unless we support
> exposing an emulated IOMMU to the guest).
>
> The case we care about is *native* DMA, where this cache flush will be
> happening for example in the fast path of network TX/RX. But in *that*
> case, there is only *one* IOMMU to worry about so it's simple enough to
> do the right thing, surely?
>
>
>    
