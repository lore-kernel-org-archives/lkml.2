Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0IOHJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 03:09:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55786 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0IOHJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 03:09:55 -0400
Date: Wed, 15 Sep 2010 10:09:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 6/6] USB: musb-gadget: fix dma length in txstate
Message-ID: <20100915070936.GD3393@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
 <1283873014-32511-7-git-send-email-tom.leiming@gmail.com>
 <4C8FB43D.5020604@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4C8FB43D.5020604@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 12:43:25PM -0500, Sergei Shtylyov wrote:
>Hello.
>
>tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>
>> DMA length should not go beyond the availabe space of request buffer,
>> so fix it.
>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> Cc: David Brownell <dbrownell@users.sourceforge.net>
>> Cc: Felipe Balbi <me@felipebalbi.com>
>> Cc: Anand Gadiyar <gadiyar@ti.com>
>> Cc: Mike Frysinger <vapier@gentoo.org>
>> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>
>[...]
>
>> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
>> index fa826f9..cacae96 100644
>> --- a/drivers/usb/musb/musb_gadget.c
>> +++ b/drivers/usb/musb/musb_gadget.c
>> @@ -300,6 +300,11 @@ static void txstate(struct musb *musb, struct musb_request *req)
>>  #ifndef	CONFIG_MUSB_PIO_ONLY
>>  	if (is_dma_capable() && musb_ep->dma) {
>>  		struct dma_controller	*c = musb->dma_controller;
>> +		size_t request_size;
>> +
>> +		/* setup DMA, then program endpoint CSR */
>> +		request_size = min_t(size_t, request->length - request->actual,
>> +					musb_ep->dma->max_len);
>
>    Er, you're moving this from under #ifdef CONFIG_USB_INVENTRA_DMA to the
>common code, right? Do you know that not all DMA drivers initialize max_len? For
>example CPPI driver doesn't, so it's left at zero. You're going to break DMA for
>CPPI. Please extend your patch, adding cppi_dma.c to it.

yes, please set some value on cppi_dma.c max_len field.

-- 
balbi
