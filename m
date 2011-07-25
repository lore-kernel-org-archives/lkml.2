Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1GYVMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:12:37 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:39631 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1GYVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:12:35 -0400
Message-ID: <4E2DDC33.3020107@atmel.com>
Date: Mon, 25 Jul 2011 23:12:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vinod Koul <vkoul@infradead.org>
CC: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 3/3] dmaengine: at_hdmac: add slave config operation
References: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>	 <1151852b20789636633095406a180335364f4afb.1309259835.git.nicolas.ferre@atmel.com> <1310006025.20150.29.camel@psiaudioba-mobl1>
In-Reply-To: <1310006025.20150.29.camel@psiaudioba-mobl1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 04:33 AM, Vinod Koul wrote:
> On Tue, 2011-06-28 at 13:17 +0200, Nicolas Ferre wrote:
>> Only change source/destination peripheral register access width.
> How about a little more explainable change log
>
>>
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>> Signed-off-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
>> ---
>>   drivers/dma/at_hdmac.c |   29 +++++++++++++++++++++++++++++
>>   1 files changed, 29 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
>> index 7096adb..9cb8044 100644
>> --- a/drivers/dma/at_hdmac.c
>> +++ b/drivers/dma/at_hdmac.c
>> @@ -954,6 +954,35 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>>   		clear_bit(ATC_IS_PAUSED,&atchan->status);
>>
>>   		spin_unlock_irqrestore(&atchan->lock, flags);
>> +	} else if (cmd == DMA_SLAVE_CONFIG) {
>> +		struct dma_slave_config *dmaengine_cfg = (void *)arg;
>> +		struct at_dma_slave	*atslave = chan->private;
> This API was created to remove chan->private, so this doesn't make sense
> at all. If your intent is to have a channels internal data, then you
> should consider embedding dma_chan into this structure (the way other
> dma drivers do) rather than using private field.

Yes, I need to rework this slave config part of the driver (and its 
related calling drivers).

So please drop this 3/3 patch of the series.

Best regards,
-- 
Nicolas Ferre
