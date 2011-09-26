Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1IZOuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:50:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56079 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1IZOuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbaOwe8Q19tpZMeHdvyCj8fcV194zA-oSD20tF7j7_MvpQ@mail.gmail.com>
References: <15669786.49881316849426265.JavaMail.weblogic@epml24>
	<CAK=WgbYnGjPKs6_nmFRGfMnbh_7wDR-0QcptAGaqDKVOo-x3cg@mail.gmail.com>
	<CAHQjnOOtVHUS3KmBz7LdO88fLQyLA6f-w3ye9nAH0Bx+zh38XA@mail.gmail.com>
	<CAK=Wgbazwz9PRJSpZjopwxJ-PO88FtajmbXL=pVKDHOr1t61fQ@mail.gmail.com>
	<CAHQjnON7dksupFeAYLuYXX2PhgjX-GXEGJiy0dRTmpoBjbURVg@mail.gmail.com>
	<CAK=WgbaOwe8Q19tpZMeHdvyCj8fcV194zA-oSD20tF7j7_MvpQ@mail.gmail.com>
Date: Mon, 26 Sep 2011 23:48:41 +0900
X-Google-Sender-Auth: jbCCYnOah0zSv-r-IyNHPoS8HBw
Message-ID: <CAHQjnOM_KTiqzYnePScMHQ3bg5X1wqa4zu6=1A1z7UWeDxVZvQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?UTF-8?B?7J207IOB7ZiE?= <sanghyun75.lee@samsung.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        =?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 6:36 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> It seems your default behavior just prints an error message with the
> details of the fault (addresses, flags, etc..). We can probably have
> this unified.
>
> In case you want to print exonys-specific info when the fault is not
> handled by upper layers, we can change report_iommu_fault() to return
> an error whenever a handler is not installed. This way
> exynos_sysmmu_irq() can easily tell whether to proceed with the
> default behavior or not, without installing a fault handler in the
> driver:
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 297893f..dc4b282 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -103,7 +103,7 @@ extern void iommu_set_fault_handler(struct iommu_domain *dom
>  static inline int report_iommu_fault(struct iommu_domain *domain,
>                struct device *dev, unsigned long iova, int flags)
>  {
> -       int ret = 0;
> +       int ret = -EFAULT;
>
That looks better for me :)
However, I think the irq handler need to identify if the return value
is an error
returned by a fault handler or a notice that no fault handler is installed.

I am sorry but I still think that
installing default fault handler is quite simple and straightforward.

Providing generic default behavior for all architectures is also good
if it is available for other architectures.
My intention with the default behavior for unrecoverable fault from IOMMU is
to show what the problem is, where the problem caused and
thus, providing a hint  to solve or catch the problem
for the device drivers and the developers.

>> BTW,
>> I think we need more fault type than IOMMU_FAULT_READ and IOMMU_FAULT_WRITE.
>> We have page fault, access fault(read, write), security fault
>> and bus error (translated physical address is not available)
>
> Initially we had a argument for the type of the fault, but dropped it
> because it was not used. Feel free to add it back if you need it.
>
OK. thanks.

> Thanks,
> Ohad.

Thank you.
Cho KyongHo.
