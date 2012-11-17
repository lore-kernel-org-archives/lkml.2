Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2KQMtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:49:22 -0500
Received: from 8bytes.org ([85.214.48.195]:55143 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2KQMtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:49:21 -0500
Date: Sat, 17 Nov 2012 13:49:18 +0100
From: "'Joerg Roedel'" <joro@8bytes.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH 4/4] iommu/exynos: enhancements of System MMU driver with
 DT
Message-ID: <20121117124918.GC11220@8bytes.org>
References: <002401cdc245$32dbf3e0$9893dba0$%cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002401cdc245$32dbf3e0$9893dba0$%cho@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Nov 17 13:49:20 2012
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50a787d022972063596161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 05:51:12PM +0900, Cho KyongHo wrote:
> This commit enhances power management of System MMU and its client
> devices with the following changes:
>  - Each System MMU device becomes the parent device of its client
>    device while probe(). Thus, exynos-iommu driver must be initialized
>    before client devices.
>  - System MMU driver does not pm_runtime_get/put() by itself and runtime
>    power gating is performed by client devices.
>  - System is safe when suspend/resume without any care by client device
>    drivers.
> 
> In addition, System MMUs can be seperate into several groups that are
> belongs to a single client device like FIMC-IS block. If such blocks are
> controlled by a single device descriptor, all System MMUs in the blocks
> must be enabled/disabled by a single device descriptor. The problem is
> that clock gating and power gating may be not the same among all System
> MMUs in the blocks. Thus, System MMUs are grouped by clock gating and
> power gating and they are chained by parent-child relationships.
> 
> exynos-iommu driver now also supports debugfs to identify the state of
> each System MMU.
> 
> The last big change is to support DT. The desription of the properties
> of DT nodes are described in the source file.
> 
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> ---
>  drivers/iommu/Kconfig        |   17 +-
>  drivers/iommu/exynos-iommu.c | 1420 +++++++++++++++++++++++++++++++-----------
>  2 files changed, 1077 insertions(+), 360 deletions(-)

This patch does multiple things and is quite large. Please split it down
into reasonable chunks and resubmit.

Patches 1-3 look good to me and I do not mind taking them for 3.8.
Please let me know if you prefer these patches standalone in 3.8 or
together with this patch split up.


	Joerg


