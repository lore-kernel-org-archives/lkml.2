Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab1CCDp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:45:27 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:47546 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757868Ab1CCDpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:45:25 -0500
Message-ID: <4D6F0EC6.7030102@st.com>
Date: Thu, 3 Mar 2011 09:15:10 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        amitgoel <amit.goel@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/8 resend] dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK
 after xfer finish
References: <cover.1298889267.git.viresh.kumar@st.com>	 <82027aa0c6446df3f7fb8e3c5fbdc28f60ea33b7.1298889267.git.viresh.kumar@st.com> <1299090855.6974.94.camel@vkoul-udesk3>
In-Reply-To: <1299090855.6974.94.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 12:04 AM, Koul, Vinod wrote:
> On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
>> dwc_desc_get checks all descriptors for DMA_CTRL_ACK before allocating them for
>> transfers. And descriptors are not marked with DMA_CRTL_ACK after transfer
>> finishes. Thus descriptor once used is not usable again. This patch marks
>> descriptors with DMA_CRTL_ACK after dma xfer finishes
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  drivers/dma/dw_dmac.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index c40b89f..01f783d 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -196,6 +196,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
>>  	dma_async_tx_callback		callback;
>>  	void				*param;
>>  	struct dma_async_tx_descriptor	*txd = &desc->txd;
>> +	struct dw_desc	*child;
> Please align this with previous ones....
> 

Will be done

-- 
viresh
