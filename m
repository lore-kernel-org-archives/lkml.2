Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab2AZHYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 02:24:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58475 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2AZHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 02:24:45 -0500
X-AuditID: cbfee61a-b7cd2ae000004fa5-f6-4f20ffbab9d9
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: "'Saugata Das'" <saugata.das@linaro.org>, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org
References: <002701ccd728$edab9350$c902b9f0$%jun@samsung.com>
 <CAKLKtzddDXhbT6o8XUsMxad9+_a_StJCQz+eBnfQ+q+xLuJQKg@mail.gmail.com>
 <CAKYAXd8A70X1gb-NFHVDMXd-aSG6+Y3PWvRTZDMT3-Ze3aF5Yw@mail.gmail.com>
 <002501ccdb20$c98b2e80$5ca18b80$%jun@samsung.com>
 <CAKYAXd_jdGfpC9kcYht=qnfaTPwE+YEx1fo89GkpRyWcN6igig@mail.gmail.com>
 <CAKYAXd-pCS4kRsg0PJp98YRqz_P0CtTKWEWiQJarE_iHqiesYQ@mail.gmail.com>
 <000c01ccdbf0$71fe58b0$55fb0a10$%jun@samsung.com>
 <CAKYAXd8zFf7AF5_X-divH51+B=Y2YC1ZjZF00D_=+R6eF8qe9g@mail.gmail.com>
In-reply-to: <CAKYAXd8zFf7AF5_X-divH51+B=Y2YC1ZjZF00D_=+R6eF8qe9g@mail.gmail.com>
Subject: RE: [PATCH v3 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Thu, 26 Jan 2012 16:24:42 +0900
Message-id: <000001ccdbfb$926d90b0$b748b210$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Aczb9bb23okNbr+ITDaI2CoyIz6sGAAA0nNA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com>:
> 2012/1/26 Seungwon Jeon <tgih.jun@samsung.com>:
> > Namjae Jeon <linkinjeon@gmail.com>:
> >> 2012/1/25 Namjae Jeon <linkinjeon@gmail.com>:
> >> >>> >> +
> >> >>> >> +static int mmc_blk_issue_packed_rd(struct mmc_queue *mq,
> >> >>> >> +               struct mmc_queue_req *mq_rq)
> >> >>> >> +{
> >> >>> >> +       struct mmc_blk_data *md = mq->data;
> >> >>> >> +       struct mmc_card *card = md->queue.card;
> >> >>> >> +       int status, ret = -EIO, retry = 2;
> >> > Hi. Seungwon.
> >> > First Thansk for your reply.
> >> > There is one more my review comment.
> >> > I think that EIO of ret is not needed. there is no case to be skipped
> >> > if/ese condition in do while loop.
> > Oh, no need practically.
> > Thank you for your inspection.
> >
> >>
> >> Hi. Seungwon.
> >>
> >>   if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) ||
> >> +                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR)) {
> >>
> >> it seems more better that upper if condition is changed like the below.
> > Do you have any reason for your comment?
> > Packed command(4.5 feature) is regardless of SPI.
> > SPI mode has been removed since version 4.3.
> >
> >>
> >> if (!mmc_host_is_spi(card->host) && ((rq_data_dir(req) != READ) ||
> >> +                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR))) {
> >>
> >>
> >> +++ b/drivers/mmc/core/host.c
> >> @@ -346,6 +346,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct
> >> device *dev)
> >>        host->max_blk_size = 512;
> >>        host->max_blk_count = PAGE_CACHE_SIZE / 512;
> >>
> >> +       host->packed_min = 2;
> >> +
> >>        return host;
> >>
> >> if packed_min is fixed value without increasing/decreasing,  it seems
> >> more better to use macro.
> >> Thanks.
> > packed_min is not fixed value.
> > Could you refer the following is changes log about v3?
> >
> > Changes in v3:
> >        - Add a variable member in mmc_host for minimum number of packed entries.
> >          This value can be overridden by host.
> Ah.. Okay~ I clearly understand about two queston.
> Totally, Looks good to me.
> Thanks for your reply.
> And I heard that packed cmd is not good while reading small chunk,
> If so, I want to use packed write cmd not read cmd.
> Can I use packed only packed write cmd by seperating
> MMC_CAP2_PACKED_READ_CMD and MMC_CAP2_PACKED_WRITE_CMD ?
Do you think this separate use is common?
Let me consider this more.

> >
> > Best regards,
> > Seungwon Jeon.
> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

