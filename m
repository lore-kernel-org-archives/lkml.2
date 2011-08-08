Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HHBit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 21:38:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23793 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1HHBiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 21:38:46 -0400
X-AuditID: cbfee61b-b7c3dae000002cb8-13-4e3f3e244d06
Date: Mon, 08 Aug 2011 10:38:44 +0900
From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH] mmc: dw_mmc: Fix DDR mode support.
In-reply-to: <CAELcNGTNA83nD3kCh=-BJ6DxRqnNaRznn3mTd5PVY_fRArp+fA@mail.gmail.com>
To: "'Jae hoon Chung'" <jh80.chung@gmail.com>,
        "'Will Newton'" <will.newton@gmail.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org
Message-id: <009d01cc556b$e99cc9d0$bcd65d70$%jun@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcxTt5+tqAyD8PFVQbWtzlNQHsaFQwBsW46w
References: <1312515303-17169-1-git-send-email-tgih.jun@samsung.com>
 <CAFbHwiT3p3pSC1q4xQRYkLzSG7tPuGLXB4KKwC-8HWMmtF+fhA@mail.gmail.com>
 <CAELcNGTNA83nD3kCh=-BJ6DxRqnNaRznn3mTd5PVY_fRArp+fA@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon Chung wrote:
> 
> Hi Seungwon
> 
> This patch is looks fine to me..
> 
> Just ask to you...Don't you want to locate MMC_CAP_MMC_HIGHSPEED in
> platdata?

Thank you for your comment.
Of course, I have considered appropriate location for MMC_CAP_MMC_HIGHSPEED.
But it seems to be difficult to distinguish a difference between MMC_CAP_SD_HIGHSPEED and MMC_CAP_MMC_HIGHSPEED,
if DW_MCI_QUIRK_HIGHSPEED is defined.

Beset regards,
Seungwon Jeon.

> 
> Regards,
> Jaehoon Chung
> 
> 
> 2011/8/5 Will Newton <will.newton@gmail.com>:
> > On Fri, Aug 5, 2011 at 4:35 AM, Seungwon Jeon <tgih.jun@samsung.com>
> wrote:
> >> Host driver can't get a hint of DDR mode through ios->ddr flag anymore.
> >> ios->timing is currently used to inform DDR mode as a substitute.
> >> And capability of MMC_CAP_MMC_HIGHSPEED is added for DDR support.
> >>
> >> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> >> ---
> >>  drivers/mmc/host/dw_mmc.c |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> >> index d65511e..b412a1d 100644
> >> --- a/drivers/mmc/host/dw_mmc.c
> >> +++ b/drivers/mmc/host/dw_mmc.c
> >> @@ -699,7 +699,7 @@ static void dw_mci_set_ios(struct mmc_host *mmc,
> struct mmc_ios *ios)
> >>        }
> >>
> >>        /* DDR mode set */
> >> -       if (ios->ddr) {
> >> +       if (ios->timing == MMC_TIMING_UHS_DDR50) {
> >>                regs = mci_readl(slot->host, UHS_REG);
> >>                regs |= (0x1 << slot->id) << 16;
> >>                mci_writel(slot->host, UHS_REG, regs);
> >> @@ -1646,7 +1646,7 @@ static int __init dw_mci_init_slot(struct dw_mci
> *host, unsigned int id)
> >>                        mmc->caps |= MMC_CAP_4_BIT_DATA;
> >>
> >>        if (host->pdata->quirks & DW_MCI_QUIRK_HIGHSPEED)
> >> -               mmc->caps |= MMC_CAP_SD_HIGHSPEED;
> >> +               mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
> >>
> >>  #ifdef CONFIG_MMC_DW_IDMAC
> >>        mmc->max_segs = host->ring_size;
> >> --
> >> 1.7.0.4
> >
> > Acked-by: Will Newton <will.newton@imgtec.com>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

