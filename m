Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab1H0L5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 07:57:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49658 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1H0L5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 07:57:00 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.14.64]
In-Reply-To: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 27 Aug 2011 14:56:39 +0300
Message-ID: <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 4:20 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Remove most of the stub functions because they are only
> allowed to use when CONFIG_IOMMU_API is set anyway. This
> will catch missing 'select' entries in kconfig at compile
> time already.

I'm not sure we want this; think about a generic framework/driver that
uses the IOMMU API only if the underlying hardware has an IOMMU and
otherwise will skip calling the IOMMU API altogether (e.g. this is
where remoteproc is headed).

With this patch, such generic code will have to "select IOMMU_API"
unconditionally, or it won't build when the hardware doesn't have an
IOMMU (e.g. the DSP in at least several of the DaVinci SoC isn't
behind an IOMMU). But doing so is a bit wasteful if there's no IOMMU
hardware...
