Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1HYHZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:25:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35300 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1HYHZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:25:09 -0400
Date: Thu, 25 Aug 2011 09:22:18 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 8/8] ARM: S5PV210: example of CMA private area for FIMC
 device on Goni board
In-reply-to: <CAKnK67RcMAt6j3CEi2Z7QTN42v07LDCfa_T38F9-5b97TJ0-hA@mail.gmail.com>
To: "'Aguirre, Sergio'" <saaguirre@ti.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Message-id: <01d801cc62f7$b9041b40$2b0c51c0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcxidFKxNC7dihlnRFyrEkY0L/YltQAgullw
References: <CAKnK67RcMAt6j3CEi2Z7QTN42v07LDCfa_T38F9-5b97TJ0-hA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, August 24, 2011 5:41 PM Aguirre, Sergio wrote:

> On Fri, Aug 19, 2011 at 04:27:44PM +0200, Marek Szyprowski wrote:
> > This patch is an example how device private CMA area can be activated.
> > It creates one CMA region and assigns it to the first s5p-fimc device on
> > Samsung Goni S5PC110 board.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/mach-s5pv210/mach-goni.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-
> goni.c
> > index 14578f5..f766c45 100644
> > --- a/arch/arm/mach-s5pv210/mach-goni.c
> > +++ b/arch/arm/mach-s5pv210/mach-goni.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/input.h>
> >  #include <linux/gpio.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/dma-contiguous.h>
> >
> >  #include <asm/mach/arch.h>
> >  #include <asm/mach/map.h>
> > @@ -857,6 +858,9 @@ static void __init goni_map_io(void)
> >  static void __init goni_reserve(void)
> >  {
> >  	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
> > +
> > +	/* Create private 16MiB contiguous memory area for s5p-fimc.0 device */
> > +	dma_declare_contiguous(&s5p_device_fimc0.dev, 16*SZ_1M, 0);
> 
> This is broken, since according to patch #0006, dma_declare_contiguous
requires
> a 4th param (limit) which you're not providing here.

You are definitely right, there should be one more parameter. This patch was
just
cherry-picked from older version just before posting to mailing lists. I'm
really
sorry for this trivial bug.
 
Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



