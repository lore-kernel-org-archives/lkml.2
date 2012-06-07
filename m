Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab2FGOX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:23:27 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:24925
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760760Ab2FGOX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:23:26 -0400
X-IronPort-AV: E=Sophos;i="4.75,731,1330902000"; 
   d="scan'208";a="146922863"
Date: Thu, 7 Jun 2012 16:23:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Sergei Shtylyov <sshtylyov@mvista.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Felipe Balbi <balbi@ti.com>,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/7] drivers/usb/gadget/pch_udc.c: adjust suspicious bit
 operation
In-Reply-To: <4FD0A5F9.9050405@mvista.com>
Message-ID: <alpine.DEB.2.02.1206071622350.1807@hadrien>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr> <1339018901-28439-4-git-send-email-Julia.Lawall@lip6.fr> <4FD0A5F9.9050405@mvista.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2012, Sergei Shtylyov wrote:

> Hello.
>
> On 07-06-2012 1:41, Julia Lawall wrote:
>
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
>> PCH_UDC_DMA_LAST is 0x08000000 so a bit-or with this value always gives a
>> nonzero result.  The test is rewritten as done elsewhere in the same file.
>
>> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
>
>> Signed-off-by: Julia Lawall<julia@diku.dk>
>
>> ---
>>   drivers/usb/gadget/pch_udc.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
>> index 1cfcc9e..79f7a53 100644
>> --- a/drivers/usb/gadget/pch_udc.c
>> +++ b/drivers/usb/gadget/pch_udc.c
>> @@ -2208,7 +2208,8 @@ static void pch_udc_complete_receiver(struct 
>> pch_udc_ep *ep)
>>   			return;
>>   		}
>>   		if ((td->status&  PCH_UDC_BUFF_STS) == PCH_UDC_BS_DMA_DONE)
>> -			if (td->status | PCH_UDC_DMA_LAST) {
>> +			if ((td_data->status&  PCH_UDC_DMA_LAST)
>> +			    == PCH_UDC_DMA_LAST) {
>
>   But why not simply:
>
> 			if (td_data->status & PCH_UDC_DMA_LAST)
>
> if the constant is single bit anyway? And are you sure about s/td/td_data/?

Oops, thanks for noticing that.  I'll send a corrected version.

thanks,
julia
