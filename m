Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1IZJVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:21:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38516 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1IZJVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=Wgbazwz9PRJSpZjopwxJ-PO88FtajmbXL=pVKDHOr1t61fQ@mail.gmail.com>
References: <15669786.49881316849426265.JavaMail.weblogic@epml24>
	<CAK=WgbYnGjPKs6_nmFRGfMnbh_7wDR-0QcptAGaqDKVOo-x3cg@mail.gmail.com>
	<CAHQjnOOtVHUS3KmBz7LdO88fLQyLA6f-w3ye9nAH0Bx+zh38XA@mail.gmail.com>
	<CAK=Wgbazwz9PRJSpZjopwxJ-PO88FtajmbXL=pVKDHOr1t61fQ@mail.gmail.com>
Date: Mon, 26 Sep 2011 18:21:32 +0900
X-Google-Sender-Auth: 8xJw_mlUrcPUNTIn_n_1s-vUWUs
Message-ID: <CAHQjnON7dksupFeAYLuYXX2PhgjX-GXEGJiy0dRTmpoBjbURVg@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 6:05 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Mon, Sep 26, 2011 at 11:58 AM, KyongHo Cho <pullip.cho@samsung.com> wrote:
>> As you've noticed, it is default behavior for iommu fault.
>
> Then why not add it to the IOMMU core ? it's quite generic and can be
> useful for others, too.
>
Every fault in IOMMU (System MMU) is an error logically
and must not happen in our multimedia device drivers
because, our device drivers always construct page table completely
before address translation in System MMU
and TLB loads translation information automatically when TLB miss.

I am not sure if the default behavior of MMU fault in our IOMMU driver
is also correct for other IOMMU drivers.

BTW,
I think we need more fault type than IOMMU_FAULT_READ and IOMMU_FAULT_WRITE.
We have page fault, access fault(read, write), security fault
and bus error (translated physical address is not available)

> Thanks,
> Ohad.

Thank you.
Cho KyongHo.
