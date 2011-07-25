Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1GYPD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:03:27 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:39189 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1GYPDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:03:25 -0400
MIME-Version: 1.0
In-Reply-To: <1311603872.8206.15.camel@vkoul-mobl4>
References: <1310518811-379-1-git-send-email-robherring2@gmail.com>
	<1311603872.8206.15.camel@vkoul-mobl4>
Date: Mon, 25 Jul 2011 20:33:23 +0530
Message-ID: <CABb+yY1mVHHLdmBh-3RJxc9zSNQkxQQrTiLsD6OJC1rSN3WW9w@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl330: make platform data optional
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Vinod Koul <vkoul@infradead.org>
Cc: Rob Herring <robherring2@gmail.com>, Jassi Brar <jassi.brar@samsung.com>,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 7:54 PM, Vinod Koul <vkoul@infradead.org> wrote:
> On Tue, 2011-07-12 at 20:00 -0500, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> The pl330 needs platform data for describing peripheral connections, but
>> some platforms may only support memory to memory dma channels. In this
>> case, we can probe for how many channels there are and don't need the
>> platform data.
>>
>> As memcpy requests don't need channel private data to hold peripheral
>> info, allow private data to be NULL in this case.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Jassi Brar <jassi.brar@samsung.com>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/dma/pl330.c |   64 ++++++++++++++++++++++++++++----------------------
>>  1 files changed, 36 insertions(+), 28 deletions(-)
> Applied, Thanks

Oops, sorry Rob. I failed to reply as I assured you. I have been just
too deep into other stuff.

>> @@ -717,27 +717,35 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>       INIT_LIST_HEAD(&pd->channels);
>>
>>       /* Initialize channel parameters */
>> -     for (i = 0; i < pdat->nr_valid_peri; i++) {
>> -             struct dma_pl330_peri *peri = &pdat->peri[i];
>> -             pch = &pdmac->peripherals[i];
>> +     num_chan = max(pdat->nr_valid_peri, (u8)pi->pcfg.num_chan);
Perhaps you need to check against NULL pointer on 'pdat' ?

Rest looks ok.

thnx
