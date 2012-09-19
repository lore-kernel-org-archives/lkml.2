Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2ISX7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:59:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56644 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2ISX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:59:18 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-69-505a5c55493a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Daniel Kurtz'" <djkurtz@chromium.org>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>, olofj@chromium.org
References: <1346944864-12434-1-git-send-email-djkurtz@chromium.org>
 <CAD=FV=UTa4a8wewEdqu=ZnOKe-M5Brv-ex8ZGWfkTb6fqsRB_w@mail.gmail.com>
In-reply-to: <CAD=FV=UTa4a8wewEdqu=ZnOKe-M5Brv-ex8ZGWfkTb6fqsRB_w@mail.gmail.com>
Subject: RE: [PATCH] ARM: EXYNOS: no duplicate mask/unmask in eint0_15
Date: Thu, 20 Sep 2012 08:59:16 +0900
Message-id: <09aa01cd96c2$c6cedd00$546c9700$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2MRmfCvBinwOE7QNG0GEIUoZoZDAKfDalw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd3QmKgAg4t7OC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIWdnxiLnjLVdF2sIutgXEbRxcjJ4eEgIlE++pNzBC2
	mMSFe+vZuhi5OIQEFjFKPJrZwwzh/GWUaDv5gQ2kik1AQ+Lw+2fsILaIQIjE2udtLCA2s8At
	RomNE70hGroZJSY0/QVLcAoES7TvOssKYgsLuEncv7kDbB2LgKrEvFszweK8ArYST6/vZoaw
	BSV+TL4HNVRLYv3O40wQtrzE5jVvgWo4gE5Vl3j0VxfiBiOJK013mCFKRCT2vXjHOIFRaBaS
	SbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH9TOpHYwrGywOMQpw
	MCrx8HZIRAUIsSaWFVfmHmKU4GBWEuH9sTcyQIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv8KfA
	ACGB9MSS1OzU1ILUIpgsEwenVANj+V3VxoB/TMXZQXYpZ5rLwqZ3Zsyr+Xx0wQv1axsefLp4
	5f3OB8+MYi1X5Bk/tnLW9FNxq3O99IajrV431fTTZT6f/a/kln8QeVnlf4XZ7daPAO/Go98t
	+xmO+O/INVnkUy6kUs4/b9IxgVNias9+nu3STVzZ0PWwPb5yV830O35PD8bsEDyoxFKckWio
	xVxUnAgA5ttobWYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> On Thu, Sep 6, 2012 at 8:21 AM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > chained_irq_enter/exit() already mask&ack/unmask the chained interrupt.
> > There is no need to also explicitly do it in the handler.
> >
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  arch/arm/mach-exynos/common.c |    7 -------
> >  1 files changed, 0 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-
> exynos/common.c
> > index 4eb39cd..0a85aec 100644
> > --- a/arch/arm/mach-exynos/common.c
> > +++ b/arch/arm/mach-exynos/common.c
> > @@ -965,14 +965,7 @@ static void exynos_irq_eint0_15(unsigned int irq,
> struct irq_desc *desc)
> >         struct irq_chip *chip = irq_get_chip(irq);
> >
> >         chained_irq_enter(chip, desc);
> > -       chip->irq_mask(&desc->irq_data);
> > -
> > -       if (chip->irq_ack)
> > -               chip->irq_ack(&desc->irq_data);
> > -
> >         generic_handle_irq(*irq_data);
> > -
> > -       chip->irq_unmask(&desc->irq_data);
> >         chained_irq_exit(chip, desc);
> >  }
> >
> > --
> > 1.7.7.3
> >
> 
> Acked-by: Doug Anderson <dianders@chromium.org>

Yes, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

