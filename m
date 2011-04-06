Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1DFPpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:45:46 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30745 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1DFPpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:45:46 -0400
Message-ID: <4D9C8A9D.9070008@atmel.com>
Date: Wed, 06 Apr 2011 17:45:33 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dmaengine: at_hdmac: add cyclic DMA operation support
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>	 <426a1091ec74342f259f76ce404472b189730269.1301678094.git.nicolas.ferre@atmel.com>	 <1302084507.27103.0.camel@vkoul-udesk3>  <4D9C618A.9020708@atmel.com> <1302098555.27103.10.camel@vkoul-udesk3>
In-Reply-To: <1302098555.27103.10.camel@vkoul-udesk3>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/04/2011 16:02, Koul, Vinod :
> On Wed, 2011-04-06 at 14:50 +0200, Nicolas Ferre wrote:
>> Le 06/04/2011 12:08, Koul, Vinod :
>>> On Fri, 2011-04-01 at 19:19 +0200, Nicolas Ferre wrote:
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> ---
>>>>  drivers/dma/at_hdmac.c      |  188 +++++++++++++++++++++++++++++++++++++++---
>>>>  drivers/dma/at_hdmac_regs.h |   14 +++-
>>>>  2 files changed, 186 insertions(+), 16 deletions(-)
>>>>
>>>> +static void atc_handle_cyclic(struct at_dma_chan *atchan)
>>>> +{
>>>> +	struct at_desc			*first = atc_first_active(atchan);
>>>> +	struct dma_async_tx_descriptor	*txd = &first->txd;
>>>> +	dma_async_tx_callback		callback = txd->callback;
>>>> +	void				*param = txd->callback_param;
>>>> +
>>>> +	dev_vdbg(chan2dev(&atchan->chan_common),
>>>> +			"new cyclic period llp 0x%08x\n",
>>>> +			channel_readl(atchan, DSCR));
>>>> +
>>>> +	if (callback)
>>>> +		callback(param);
>>>> +}
>>> You dont seem to be doing much expect calling callback, so doesn't it
>>> make sense to write so much code for just calling callback? 
>>
>> I do not totally follow you here: you mean that I should reduce the
>> amount of variables in this function or is it a more global comment
>> about my way of handling cyclic operations?
> Well, in handling of cyclic operation you are only calling the callback
> if set. If you plan to add more functionality to this function in future
> then okay, otherwise you may reconsider this and avoid the function as
> you are not doing much here, if it reduces code size. This is okay this
> way also.
> I had no comment on variables as I understand first two are unavoidable

As far as code size and execution path is concerned, this function is
expanded by the compiler as an inline one and I checked that it only
takes a few lines of assembly (without function call) if the debug trace
is not requested (~7 lines into atc_tasklet() with one call to
atc_first_active() which is needed anyway).

I would prefer to keep this simple "pseudo-inline" function just for a
matter of code clarity.

Best regards,
-- 
Nicolas Ferre

