Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2J3I5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:57:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2J3I5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:57:09 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-05-508f96632c2b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 2/4] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of
 Exynos4210 SOC
Date: Tue, 30 Oct 2012 09:56:22 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, jassisinghbrar@gmail.com,
        vinod.koul@intel.com, rob.herring@calxeda.com, dinguyen@altera.com,
        pawel.moll@arm.com, t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <1351504796-24788-3-git-send-email-b.zolnierkie@samsung.com>
 <508EBBB6.2090006@samsung.com>
In-reply-to: <508EBBB6.2090006@samsung.com>
MIME-version: 1.0
Message-id: <201210300956.23102.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAd3kaf0BBh9miVpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcWTSBveAkX8WDxiNMDYy3ubsYOTkkBEwkms9eYIew
	xSQu3FvPBmILCSxilFhxh7mLkQvIbmGS2DzhDFiCTcBKYmL7KkYQW0RATaJn8VYwW1ggQmLZ
	rgksIDaLgKrEsaX/weKiAg4SnVMnsIEMYhaYwCSxYvV5FoipKxglln05ANbBKaAtMW3LF7Az
	eAUEJX5MvscCYVtK7O7bwgxiMwtoSTS/2cQIYctLbF7zlnkCo8AsJC2zkJTNQlK2gJF5FaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZwOD6T2sG4ssHiEKMAB6MSD++GNX0BQqyJZcWVuYcY
	JTiYlUR4Z0/qDxDiTUmsrEotyo8vKs1JLT7EKM3BoiTO2+yREiAkkJ5YkpqdmlqQWgSTZeLg
	lGpg5HqxboU2j8GOmJAwft6Cpovp5upsWtZqGp1s8yew3fc9Z6DpaKqhEfNgzWLpdNZNyWdS
	zL5pdybdkvu4ZeufYwzM9rYHd5xiZVlw70aqYISmKVfI86cLtt1tl971VJhhneEqZzHVxRob
	dVLWrPr7Y+Vmkz7HRL2cy/vPeHcxTPM6GfRfw3GjEktxRqKhFnNRcSIAIYeY+UMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 29 October 2012 18:24:06 Kukjin Kim wrote:
> On 10/29/12 10:59, Bartlomiej Zolnierkiewicz wrote:
> > Commit 8214513 ("ARM: EXYNOS: fix address for EXYNOS4 MDMA1")
> > changed EXYNOS specific setup of PL330 DMA engine to use 'non-secure'
> > mdma1 address instead of 'secure' one (from 0x12840000 to 0x12850000)
> > to fix issue with some Exynos4212 SOCs.  Unfortunately it brakes
> > PL330 setup for revision 0 of Exynos4210 SOC (mdma1 device cannot
> > be found at 'non-secure' address):
> >
> > [    0.566245] dma-pl330 dma-pl330.2: PERIPH_ID 0x0, PCELL_ID 0x0 !
> > [    0.566278] dma-pl330: probe of dma-pl330.2 failed with error -22
> >
> > Fix it by using 'secure' mdma1 address on Exynos4210 revision 0 SOC.
> >
> > Cc: Tomasz Figa<t.figa@samsung.com>
> > Cc: Kukjin Kim<kgene.kim@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> > ---
> >   arch/arm/mach-exynos/dma.c              | 5 ++++-
> >   arch/arm/mach-exynos/include/mach/map.h | 3 ++-
> >   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> [...]
> 
> > +		if (samsung_rev() == EXYNOS4210_REV_0)
> > +			exynos_mdma1_device.res.start = EXYNOS4_PA_S_MDMA1;
> 
> Hi Bart,
> 
> Hmm...above change and adding definition of EXYNOS_PA_S_MDMA1 address 
> can fix the problem you commented on EXYNOS4210 Rev0 without others?...

The problem is affecting only EXYNOS4210 Rev0 and the fix is applied only
for case when soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_0,
or did you mean something else?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center

> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
