Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1JLIXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:23:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49157 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JLIXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:23:15 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <000501cc88b6$0dd17d00$29747700$%cho@samsung.com>
References: <000501cc88b6$0dd17d00$29747700$%cho@samsung.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 12 Oct 2011 10:22:54 +0200
Message-ID: <CAK=WgbZ4RjJXjCXeN-rg84OLv1KZiWAAXXTWXknn_Gt4eioqDA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
To: pullip.cho@samsung.com
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>, joerg.roedel@amd.com,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Wed, Oct 12, 2011 at 10:07 AM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> +static int exynos_iommu_unmap(struct iommu_domain *domain, unsigned long
> iova,
> +                          int gfp_order)
> +{
...
> +       return 0;
> +}

->unmap() should return the size of the unmapped region (in page order
atm); this is already expected by mainline users of the IOMMU API
today, and will also be used by the iommu core itself soon.

Ohad.
