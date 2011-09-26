Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab1IZHKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:10:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53365 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1IZHKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:10:19 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.133.94]
In-Reply-To: <1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com> <1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 26 Sep 2011 10:09:58 +0300
Message-ID: <CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of register_iommu
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 6:45 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> -       register_iommu(&omap_iommu_ops);
> +       bus_set_iommu(&platform_bus_type, &omap_iommu_ops);

I'm not sure it makes a lot of sense to bind the iommu ops to the platform bus.

Unlike the pci bus, the platform bus is not really a hardware bus:
it's some kind of a catch-all pseudo bus which is mostly used to to
describe a collection of autonomous peripherals on an SoC.

As a result, IOMMU users on an SoC might actually not belong to the
platform bus.

More specifically, I'm not sure how this would work out with the
upcoming generic IOMMU-based DMA API, which might be used by those
non-platform-bus users.

That said, the generic DMA API is not here yet, and nothing
immediately breaks for us by doing this change, so if this helps you
guys with the x86/pci iommu drivers than I'm ok with it: we can always
change/fix this later when real issues come up with this model.
