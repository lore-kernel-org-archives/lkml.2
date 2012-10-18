Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2JRV3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab2JRV3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:29:17 -0400
Message-ID: <1350595750.2112.438.camel@bling.home>
Subject: Re: [RFC PATCH 0/5] amd_iommu: Refactor IOMMU group and support
 virtual aliases
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg.Roedel@amd.com
Cc: florian@dazinger.net, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 15:29:10 -0600
In-Reply-To: <20121009044057.16302.44577.stgit@bling.home>
References: <20121009044057.16302.44577.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

I think this series is good-to-go, modulo any testing you may be able to
do on it.  I'm going to be offline for a couple weeks so feel free to
incorporate this RFC directly or I can re-spin something when I'm back.
Thanks,

Alex

On Mon, 2012-10-08 at 22:49 -0600, Alex Williamson wrote:
> This series is meant to refactor IOMMU group support in amd_iommu
> to properly support virtual aliases.  If multiple devices alias to
> the same virtual alias, they should be grouped together.  This code
> also verifies whether the alias should be the root of the group vs
> devices above the alias.
> 
> This seems to do the right thing on my system, but that's not saying
> a lot since it doesn't do anything interesting with aliases.  I'd
> appreciate if Joerg and Florian could test this on their systems.
> Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (5):
>       amd_iommu: Properly account for virtual aliases in IOMMU groups
>       amd_iommu: Split IOMMU group allocation and attach
>       amd_iommu: Split upstream bus device lookup
>       amd_iommu: Split IOMMU Group topology walk
>       amd_iommu: Split IOMMU group initialization
> 
> 
>  drivers/iommu/amd_iommu.c       |  184 ++++++++++++++++++++++++++++++---------
>  drivers/iommu/amd_iommu_types.h |    1 
>  2 files changed, 142 insertions(+), 43 deletions(-)
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu



