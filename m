Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2CGGWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:22:37 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47917 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2CGGWf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:22:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAAQKjZNJHeApuiyh467w8wGaY8VFb_PqLrvHGUxmE8-+a4yRTA@mail.gmail.com>
References: <002201ccfb73$93311520$b9933f60$%cho@samsung.com>
	<CAAQKjZNJHeApuiyh467w8wGaY8VFb_PqLrvHGUxmE8-+a4yRTA@mail.gmail.com>
Date: Wed, 7 Mar 2012 15:22:33 +0900
X-Google-Sender-Auth: ILCzRWWhSS5gOVu27ozNsOcN8YM
Message-ID: <CAHQjnOOQKS1EU-3zWDDq2sLxPucY9CRZyrnaT5cyyrSa9-k9Nw@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 2:28 PM, InKi Dae <daeinki@gmail.com> wrote:
>> +static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>> +{
>> +       /* SYSMMU is in blocked when interrupt occurred. */
>> +       struct sysmmu_drvdata *data = dev_id;
>> +       struct resource *irqres;
>> +       struct platform_device *pdev;
>> +       enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype;
>
> how about to change EXYNOS_SYSMMU_INTERRUPT_TYPE to small letter? just
> for code clean.
>
I will. please refer to the my reply to Kyungmin Park.

>> +       unsigned long addr = -1;
>> +
>> +       int i, ret = -ENOSYS;
>> +
>> +       read_lock(&data->lock);
>> +
>> +       WARN_ON(!is_sysmmu_active(data));
>> +
>> +       pdev = to_platform_device(data->sysmmu);
>> +       for (i = 0; i < pdev->num_resources; i++) {
>> +               irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
>> +               if (irqres && ((int)irqres->start == irq))
>> +                       break;
>> +       }
>
> is there any reason that it should get irq resources in interrupt
> handler? if not so then how about to move it into probe()?
>
The platform device of ISP has a lot of IRQ sources.
The above for clause determines which IRQ source (System MMU)
generated the interrupt.

>> +
>> +       if (i == pdev->num_resources) {
>> +               itype = SYSMMU_FAULT_UNKNOWN;
>> +       } else {
>> +               i /= 2;
>> +
>> +               itype = (enum EXYNOS_SYSMMU_INTERRUPT_TYPE)
>
> ditto.
>

Thank you.

Cho KyongHo.
