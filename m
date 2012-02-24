Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab2BXQIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:08:39 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36860 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757035Ab2BXQIh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:08:37 -0500
MIME-Version: 1.0
In-Reply-To: <014601ccf2fa$a25c8560$e7159020$%szyprowski@samsung.com>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
	<014601ccf2fa$a25c8560$e7159020$%szyprowski@samsung.com>
Date: Sat, 25 Feb 2012 01:08:36 +0900
X-Google-Sender-Auth: UZlIL18baW2Fa-MNAZ42jffGU4M
Message-ID: <CAHQjnOPE5X=dn+8D348OruLqoYNGZwZk3eLtLRSERce-eTzXDg@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: KyongHo Cho <pullip.cho@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek.

On Fri, Feb 24, 2012 at 10:45 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hi,
>
> On Thursday, December 29, 2011 1:24 PM KyongHo Cho wrote:
>
>> Changes since v7:
>> - Rebased with the recent commits of the following git branches
>>   * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
>>   * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
>> - Changed magic numbers into macros
>> - Setting owner of a System MMU in 'iommu' field of dev_archdata
>> - Verbose message in the default fault handler
>> - Some bug fixes.
>
> (snipped)
>
> The time is flying away and v3.4 merge windows will open soon. Do you plan to
> send an updated version of the SYSMMU driver anytime soon? It will be really
> nice to have it finally merged to v3.4.
>

Thank you for asking.

I prepared a new patchset and it is ready for submitting.
It includes several bugfixes and Exynos5 support.

The last patche submitted has a bug when the following situation:
   1. Allocating a 2nd level page table to map 4KB or 64KB on a virtual region
   2. Unmapped all entries in the 2nd level page table.
   3. Mapping to the same region with 1MB page.
   Then iommu_map() will return -EADDRINUSE due to incorrect counting
   free entries in 2nd level page table.

The next patch will be submitted by 2/28.

BTW Marek, I want to know why MFC driver defines separate platform devices
for left and right buses.
The next IOMMU driver defines just one platform device for a H/W device.
Thus, it defines just one SYSMMU_MFC platform device, for example.
(the previous one defines 2 platform devices for SYSMMU_MFC)
However, it is easy to separate the single platform device to multiple
platform devices.

Regards,

Cho KyongHo.
