Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2LMRK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:10:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2LMRK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:10:58 -0500
Message-ID: <1355418650.2229.11.camel@ul30vt.home>
Subject: Re: [PATCH]iommu: make return value consistence
From: Alex Williamson <alex.williamson@redhat.com>
To: Wang YanQing <udknight@gmail.com>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 10:10:50 -0700
In-Reply-To: <20121213165557.GB10948@udknight>
References: <20121213165557.GB10948@udknight>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 00:55 +0800, Wang YanQing wrote:
> if we don't define CONFIG_IOMMU_API the
> dummy functions alway return -ENODEV
> or -EINVAL except three function, so convert
> them to the same behavior to make consistence

But if we do define CONFIG_IOMMU_API the actual functions return NULL
instead of ERR_PTR, so any conversion needs to include the actual
functions and update the callers as well.  Thanks,

Alex

> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  include/linux/iommu.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index f4a49a6..16e84f6 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -210,7 +210,7 @@ static inline bool iommu_present(struct bus_type *bus)
>  
>  static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
>  {
> -	return NULL;
> +	return ERR_PTR(-ENODEV);
>  }
>  
>  static inline void iommu_domain_free(struct iommu_domain *domain)
> @@ -275,7 +275,7 @@ static inline struct iommu_group *iommu_group_alloc(void)
>  
>  static inline void *iommu_group_get_iommudata(struct iommu_group *group)
>  {
> -	return NULL;
> +	return ERR_PTR(-EINVAL);
>  }
>  
>  static inline void iommu_group_set_iommudata(struct iommu_group *group,
> @@ -309,7 +309,7 @@ static inline int iommu_group_for_each_dev(struct iommu_group *group,
>  
>  static inline struct iommu_group *iommu_group_get(struct device *dev)
>  {
> -	return NULL;
> +	return ERR_PTR(-ENODEV);
>  }
>  
>  static inline void iommu_group_put(struct iommu_group *group)



