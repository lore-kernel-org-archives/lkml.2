Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2A0HJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:09:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2A0HJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:09:05 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <1327603257-17028-3-git-send-email-joerg.roedel@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com> <1327603257-17028-3-git-send-email-joerg.roedel@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 27 Jan 2012 09:08:44 +0200
Message-ID: <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
Subject: Re: [PATCH 2/6] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Thu, Jan 26, 2012 at 8:40 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Implement the attribute itself and add the code for the
> AMD IOMMU driver.

It's somewhat non-intuitive to have the generic attribute code bundled
with the AMD implementation in the same patch (took me some time to
find it here :).

Maybe split this to two patches ?

> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index ef54718..3d0b0bf 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -345,10 +345,23 @@ EXPORT_SYMBOL_GPL(iommu_device_group);
>  int iommu_domain_get_attr(struct iommu_domain *domain,
>                          enum iommu_attr attr, void *data)
>  {
> -       if (!domain->ops->domain_get_attr)
> -               return -EINVAL;
> +       struct iommu_domain_geometry *geometry;
> +       int ret = 0;
> +
> +       switch (attr) {
> +       case DOMAIN_ATTR_GEOMETRY:
> +               geometry  = data;
> +               *geometry = domain->geometry;

This is not type-safe and will surely bite someone some day.

Sure, we can't have type safety in a multi-purpose generic interface,
but I wonder whether this is the right interface for getting the
geometry ? I.e. why not have a dedicated API for this ?

Thanks,
Ohad.
