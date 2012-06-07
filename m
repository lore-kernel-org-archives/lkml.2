Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab2FGNB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:01:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33950 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843Ab2FGNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:01:26 -0400
Message-ID: <4FD0A5F9.9050405@mvista.com>
Date: Thu, 07 Jun 2012 17:00:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/7] drivers/usb/gadget/pch_udc.c: adjust suspicious bit
 operation
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr> <1339018901-28439-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1339018901-28439-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-06-2012 1:41, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> PCH_UDC_DMA_LAST is 0x08000000 so a bit-or with this value always gives a
> nonzero result.  The test is rewritten as done elsewhere in the same file.

> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

> Signed-off-by: Julia Lawall<julia@diku.dk>

> ---
>   drivers/usb/gadget/pch_udc.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index 1cfcc9e..79f7a53 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -2208,7 +2208,8 @@ static void pch_udc_complete_receiver(struct pch_udc_ep *ep)
>   			return;
>   		}
>   		if ((td->status&  PCH_UDC_BUFF_STS) == PCH_UDC_BS_DMA_DONE)
> -			if (td->status | PCH_UDC_DMA_LAST) {
> +			if ((td_data->status&  PCH_UDC_DMA_LAST)
> +			    == PCH_UDC_DMA_LAST) {

    But why not simply:

			if (td_data->status & PCH_UDC_DMA_LAST)

if the constant is single bit anyway? And are you sure about s/td/td_data/?

WBR, Sergei
