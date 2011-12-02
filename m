Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1LBJGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:06:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50943 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1LBJGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:06:34 -0500
X-AuditID: cbfee61b-b7bdbae000001970-2c-4ed895174a45
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: "'S, Venkatraman'" <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
References: <aad7cb35699550e89526a5fb083c520d.squirrel@www.codeaurora.org>
 <000201ccadab$1e57b8a0$5b0729e0$%jun@samsung.com>
 <5573ef5046779298ee1555838015e0e3.squirrel@www.codeaurora.org>
In-reply-to: <5573ef5046779298ee1555838015e0e3.squirrel@www.codeaurora.org>
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Fri, 02 Dec 2011 18:06:30 +0900
Message-id: <003201ccb0d1$ae9474c0$0bbd5e40$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcywMF/azt4PXjEJQZaBnW9MypfLygAnjRQQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez wrote:
> > Maya Erez wrote:
> >> >> >> On Wed, Nov 2, 2011 at 1:33 PM, Seungwon Jeon
> >> <tgih.jun@samsung.com>
> >> >> wrote:
> >> >> >> > @@ -980,12 +988,67 @@ static int mmc_blk_err_check(struct
> >> mmc_card
> >> >> *card,
> >> >> >> >        if (!brq->data.bytes_xfered)
> >> >> >> >                return MMC_BLK_RETRY;
> >> >> >> >
> >> >> >> > +       if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
> >> >> >> > +               if (unlikely(brq->data.blocks << 9 !=
> >> >> brq->data.bytes_xfered))
> >> >> >> > +                       return MMC_BLK_PARTIAL;
> >> >> >> > +               else
> >> >> >> > +                       return MMC_BLK_SUCCESS;
> >> >> >> > +       }
> >> >> >> > +
> >> >> >> >        if (blk_rq_bytes(req) != brq->data.bytes_xfered)
> >> >> >> >                return MMC_BLK_PARTIAL;
> >> >> >> >
> >> >> >> >        return MMC_BLK_SUCCESS;
> >> >> >> >  }
> >> >> >> >
> >> >> >> > +static int mmc_blk_packed_err_check(struct mmc_card *card, +
> >>                        struct mmc_async_req *areq)
> >> >> >> > +{
> >> >> >> > +       struct mmc_queue_req *mq_mrq = container_of(areq, struct
> >> >> mmc_queue_req,
> >> >> >> > +                                                   mmc_active);
> >> +
> >>       int err, check, status;
> >> >> >> > +       u8 ext_csd[512];
> >> >> >> > +
> >> >> >> > +       check = mmc_blk_err_check(card, areq);
> >> >> >> > +
> >> >> >> > +       if (check == MMC_BLK_SUCCESS)
> >> >> >> > +               return check;
> >> I think we need to check the status for all cases and not only in case
> >> of
> >> MMC_BLK_PARTIAL. For example, in cases where the header was traferred
> >> successfully but had logic errors (wrong number of sectors etc.)
> >> mmc_blk_err_check will return MMC_BLK_SUCCESS although the packed
> >> commands
> >> failed.
> > Similarly, Sahitya Tummala is already mentioned this.
> > Other error case will be checked in next version.
> > The case you suggested is about read or write?
> > Device may detect error and stop transferring the data.
> Sahitya suggested to also check other error cases that mmc_blk_err_check
> returns (such as MMC_BLK_CMD_ERR, MMC_BLK_ECC_ERR and MMC_BLK_DATA_ERR).
> I suggest to also check the exception bit in the status even if
> mmc_blk_err_check returned success, since mmc_blk_err_check might not
> catch all the packed commands failures. One example for such a failure is
> when the header of read packed commands will have logical error.
This part is modified in next version.

Thanks,
Seungwon Jeon.

> Thanks,
> Maya
> --
> Seny by a Consultant for Qualcomm innovation center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

