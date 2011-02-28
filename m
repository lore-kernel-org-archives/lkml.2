Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1B1PEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:04:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42308 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1B1PEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HAAdeBgVJwK5dpsMc5ZvpStwLNMly6gFci01EIKzi+DKAJ6NplW3XclOWJt7LzfkMP
         JMbFZXcHNAUGbCJAzrAfq5w66WzQ+ZrEQUyqsDnivT+GDTC0mv9IqZEm7k/kmAWOu1Kv
         ZT1JSjJF8vgTOaAjLmGUyeSP8bmwConWMX5Bc=
MIME-Version: 1.0
In-Reply-To: <4D6B8F84.40905@ru.mvista.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
	<82027aa0c6446df3f7fb8e3c5fbdc28f60ea33b7.1298889267.git.viresh.kumar@st.com>
	<4D6B8F84.40905@ru.mvista.com>
Date: Mon, 28 Feb 2011 20:34:02 +0530
Message-ID: <AANLkTimhKCxD=9-+gGL41vo+FkaKUFwi6jvgEcGz_VQw@mail.gmail.com>
Subject: Re: [PATCH 6/8 resend] dw_dmac: Mark all tx_descriptors with
 DMA_CRTL_ACK after xfer finish
From: viresh kumar <viresh.linux@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linus.walleij@stericsson.com,
        shiraz.hashim@st.com, amit.goel@st.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/11, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 28-02-2011 13:41, Viresh Kumar wrote:
>
>> dwc_desc_get checks all descriptors for DMA_CTRL_ACK before allocating
>> them for
>> transfers. And descriptors are not marked with DMA_CRTL_ACK after transfer
>> finishes. Thus descriptor once used is not usable again. This patch marks
>> descriptors with DMA_CRTL_ACK after dma xfer finishes
>
>> Signed-off-by: Viresh Kumar<viresh.kumar@st.com>
>> ---
>>   drivers/dma/dw_dmac.c |    7 +++++++
>>   1 files changed, 7 insertions(+), 0 deletions(-)
>
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index c40b89f..01f783d 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -196,6 +196,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc,
>> struct dw_desc *desc)
>>   	dma_async_tx_callback		callback;
>>   	void				*param;
>>   	struct dma_async_tx_descriptor	*txd =&desc->txd;
>> +	struct dw_desc	*child;
>
>     Shouldn't this varaible name be aligned with the above variable names?
>

Should be. Will take care of this while resending this patch series,
after getting all
review comments.

--
viresh
