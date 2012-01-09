Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab2AIAkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:40:11 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65492 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033Ab2AIAju convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:39:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120105125326.GT11810@n2100.arm.linux.org.uk>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com>
	<20120105091718.3fb378b2a1d390f9dd63c396@nvidia.com>
	<20120105125326.GT11810@n2100.arm.linux.org.uk>
Date: Mon, 9 Jan 2012 09:39:48 +0900
X-Google-Sender-Auth: HCdOFjeFhFDQbIhV_LqFoajlVzY
Message-ID: <CAHQjnONDAmH+zpSmmOCCs9aYxT+LJGso98=exf+_WFYKT=fE3A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU driver
From: KyongHo Cho <pullip.cho@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 9:53 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jan 05, 2012 at 09:17:18AM +0200, Hiroshi Doyu wrote:
>> Just for DMA mapping test from MPU side, the following one is used.
>
> This patch is buggy.
>
>> +static void dmaapi_test_map_page(struct device *dev)
>> +{
>> +     struct page *page;
>> +     dma_addr_t dma_addr;
>> +     void *cpu_addr;
>> +
>> +     page = alloc_page(GFP_KERNEL);
>> +     BUG_ON(!page);
>> +
>> +     dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_TO_DEVICE);
>> +     BUG_ON(!dma_addr);
>> +
>> +     cpu_addr = kmap(page);
>> +     BUG_ON(!cpu_addr);
>> +     memset(cpu_addr, 0xa5, PAGE_SIZE);
>> +     kunmap(cpu_addr);
>
> The DMA API works like this:
>
> - The CPU owns the page or buffer and can access it.
> - You map the page or buffer.
> - The device owns the page or buffer; the CPU must explicitly access it.

I don't understand what  "CPU must __explicitly__ access it" means.

Do you mean that CPU must access the mapped buffer when
it __explicitly__ knows that the access does not cause any side effect?


> - You unmap the page or buffer.
> - The CPU again owns the page/buffer and can access it.
>
> Please respect the DMA API rules.
>
> So.  Once dma_map_page() has returned, you must not kmap() or otherwise
> access the data contained in that page until after you have unmapped it.
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
