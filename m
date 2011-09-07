Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1IGGBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:01:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63863 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab1IGGBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:01:47 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <CAHQjnOMT3UOFMi=JbSXf4-s_BbZ+fSGbOEjxwT7t7N-zd+9-zg@mail.gmail.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
 <1314984756-4400-8-git-send-email-ohad@wizery.com> <CAHQjnOMT3UOFMi=JbSXf4-s_BbZ+fSGbOEjxwT7t7N-zd+9-zg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 7 Sep 2011 09:01:26 +0300
Message-ID: <CAK=WgbZPFryzCFLa5AhAYDmH1S8c3x-OsSTyxYeq0WLAe8VyTg@mail.gmail.com>
Subject: Re: [RFC 7/7] iommu/core: split mapping to page sizes as supported by
 the hardware
To: KyongHo Cho <pullip.cho@samsung.com>
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

Hi Cho,

On Wed, Sep 7, 2011 at 4:30 AM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> Please find the following link that I submitted for our IOMMU.
> https://lkml.org/lkml/2011/7/3/152
>
> s5p_iommu_map/unmap accepts any order of physical address and iova
> without support of your suggestion if the order is not less than PAGE_SHIFT

That's exactly what I'm trying to prevent; there's no reason to
duplicate the exact same logic in every iommu driver.

As a result, your map function is quite big (it even duplicates the
same logic for every page size it tries).

Try to rebase your patch on the "iommu/core: split mapping to page
sizes as supported by the hardware" patch I've just sent, and see how
significantly simpler your code becomes.

Relying on a single implementation, provided by the IOMMU core, means
less code to maintain (and debug) and a consistent behavior (across
all supported hardware) exposed to users of the IOMMU API.

> But I think IOMMU API must not expect that the caller of iommu_map() knows
> about the restriction of IOMMU API implementation.

Right. But I don't think there's any disagreement here ?

If any, then I think that s5p_iommu_map() is more limited than what I
propose: if it is given a 64KB region aligned only to a 4KB address,
it will BUG_ON() it. While not ideal, I don't think there's any reason
not to map it using 4KB pages (which is exactly what the new
iommu_map() I propose will do).

Thanks,
Ohad.
