Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1IGBal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:30:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36837 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1IGBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <1314984756-4400-8-git-send-email-ohad@wizery.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
	<1314984756-4400-8-git-send-email-ohad@wizery.com>
Date: Wed, 7 Sep 2011 10:30:33 +0900
X-Google-Sender-Auth: iA3LUs0SxxJ_sYh6v6fzVM_DjEA
Message-ID: <CAHQjnOMT3UOFMi=JbSXf4-s_BbZ+fSGbOEjxwT7t7N-zd+9-zg@mail.gmail.com>
Subject: Re: [RFC 7/7] iommu/core: split mapping to page sizes as supported by
 the hardware
From: KyongHo Cho <pullip.cho@samsung.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Sep 3, 2011 at 2:32 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> When mapping a memory region, split it to page sizes as supported
> by the iommu hardware. Always prefer bigger pages, when possible,
> in order to reduce the TLB pressure.
>
True. It is important for the peripheral devices that works with IOMMU.

> This allows a more lenient granularity of mappings: traditionally the
> IOMMU API took 'order' (of a page) as a mapping size, and directly let
> the low level iommu drivers handle the mapping. Now that the IOMMU
> core can split arbitrary memory regions into pages, we can remove this
> limitation, so users don't have to split those regions by themselves.
>

Please find the following link that I submitted for our IOMMU.
https://lkml.org/lkml/2011/7/3/152

s5p_iommu_map/unmap accepts any order of physical address and iova
without support of your suggestion if the order is not less than PAGE_SHIFT

Of course, an IO virtual memory manager must be careful when it allocates
IO virtual memory to lead best performance.
But I think IOMMU API must not expect that the caller of iommu_map() knows
about the restriction of IOMMU API implementation.

Regards,
Cho KyongHo.
