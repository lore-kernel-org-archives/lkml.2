Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab2JOOY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:24:59 -0400
Received: from antcom.de ([188.40.178.216]:55402 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab2JOOY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:24:58 -0400
Message-ID: <507C1CB4.7070203@antcom.de>
Date: Mon, 15 Oct 2012 16:24:52 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] usb: gadget: lpc32xx_udc: Fix compatibility with
 STOTG04
References: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 02:47 PM, Alexandre Pereira da Silva wrote:
> The STOTG04 is an replacement for ISP1301.
> 
> Most of the registers on STOTG04 are the same as on ISP1301, but the
> register ISP1301_I2C_OTG_CONTROL_2 (address 0x10) doesn't exist on the
> ST part.
> 
> This is a work around for this by using the interrupt source register that
> should behave the same on both parts and has the needed information.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Tested-by: Roland Stigge <stigge@antcom.de>

> ---
> 
> This patch is very important to LPC32xx users. IMHO this should go in for 3.7-rc2.
> 
>  drivers/usb/gadget/lpc32xx_udc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
> index f696fb9..21a9861 100644
> --- a/drivers/usb/gadget/lpc32xx_udc.c
> +++ b/drivers/usb/gadget/lpc32xx_udc.c
> @@ -2930,10 +2930,10 @@ static void vbus_work(struct work_struct *work)
>  
>  		/* Get the VBUS status from the transceiver */
>  		value = i2c_smbus_read_byte_data(udc->isp1301_i2c_client,
> -						 ISP1301_I2C_OTG_CONTROL_2);
> +						 ISP1301_I2C_INTERRUPT_SOURCE);
>  
>  		/* VBUS on or off? */
> -		if (value & OTG_B_SESS_VLD)
> +		if (value & INT_SESS_VLD)
>  			udc->vbus = 1;
>  		else
>  			udc->vbus = 0;

