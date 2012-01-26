Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2AZEbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 23:31:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53404 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2AZEbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 23:31:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_jdGfpC9kcYht=qnfaTPwE+YEx1fo89GkpRyWcN6igig@mail.gmail.com>
References: <002701ccd728$edab9350$c902b9f0$%jun@samsung.com>
	<CAKLKtzddDXhbT6o8XUsMxad9+_a_StJCQz+eBnfQ+q+xLuJQKg@mail.gmail.com>
	<CAKYAXd8A70X1gb-NFHVDMXd-aSG6+Y3PWvRTZDMT3-Ze3aF5Yw@mail.gmail.com>
	<002501ccdb20$c98b2e80$5ca18b80$%jun@samsung.com>
	<CAKYAXd_jdGfpC9kcYht=qnfaTPwE+YEx1fo89GkpRyWcN6igig@mail.gmail.com>
Date: Thu, 26 Jan 2012 13:31:42 +0900
Message-ID: <CAKYAXd-pCS4kRsg0PJp98YRqz_P0CtTKWEWiQJarE_iHqiesYQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mmc: core: Support packed command for eMMC4.5 device
From: Namjae Jeon <linkinjeon@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Saugata Das <saugata.das@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/25 Namjae Jeon <linkinjeon@gmail.com>:
>>> >> +
>>> >> +static int mmc_blk_issue_packed_rd(struct mmc_queue *mq,
>>> >> +               struct mmc_queue_req *mq_rq)
>>> >> +{
>>> >> +       struct mmc_blk_data *md = mq->data;
>>> >> +       struct mmc_card *card = md->queue.card;
>>> >> +       int status, ret = -EIO, retry = 2;
> Hi. Seungwon.
> First Thansk for your reply.
> There is one more my review comment.
> I think that EIO of ret is not needed. there is no case to be skipped
> if/ese condition in do while loop.

Hi. Seungwon.

  if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) ||
+                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR)) {

it seems more better that upper if condition is changed like the below.

if (!mmc_host_is_spi(card->host) && ((rq_data_dir(req) != READ) ||
+                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR))) {


+++ b/drivers/mmc/core/host.c
@@ -346,6 +346,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct
device *dev)
       host->max_blk_size = 512;
       host->max_blk_count = PAGE_CACHE_SIZE / 512;

+       host->packed_min = 2;
+
       return host;

if packed_min is fixed value without increasing/decreasing,  it seems
more better to use macro.
Thanks.
