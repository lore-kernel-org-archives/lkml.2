Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab1D2KTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 06:19:04 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:48589 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab1D2KTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 06:19:02 -0400
Message-ID: <4DBA9082.6040907@st.com>
Date: Fri, 29 Apr 2011 15:48:42 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 2/7] dmaengine/dw_dmac: Replace spin_lock* with	irqsave
 variants
References: <cover.1303896566.git.viresh.kumar@st.com> <50dc2f47f2c9f94fce78583568830a66af49307d.1303896567.git.viresh.kumar@st.com> <20110428171020.GB17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110428171020.GB17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 10:40 PM, Russell King - ARM Linux wrote:
> On Wed, Apr 27, 2011 at 03:06:44PM +0530, Viresh Kumar wrote:
>> @@ -407,6 +410,8 @@ EXPORT_SYMBOL(dw_dma_get_dst_addr);
>>  static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
>>  		u32 status_block, u32 status_err, u32 status_xfer)
>>  {
>> +	unsigned long flags;
>> +
>>  	if (status_block & dwc->mask) {
>>  		void (*callback)(void *param);
>>  		void *callback_param;
>> @@ -418,9 +423,9 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
>>  		callback = dwc->cdesc->period_callback;
>>  		callback_param = dwc->cdesc->period_callback_param;
>>  		if (callback) {
>> -			spin_unlock(&dwc->lock);
>> +			spin_unlock_irqrestore(&dwc->lock, flags);
>>  			callback(callback_param);
>> -			spin_lock(&dwc->lock);
>> +			spin_lock_irqsave(&dwc->lock, flags);
> 
> I'm really not convinced that this is anywhere near correct.  I'm
> surprised this doesn't spit out a compiler warning.
> 

Sorry, this is done by mistake.

-- 
viresh
