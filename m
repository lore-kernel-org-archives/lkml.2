Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2JXN6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:58:41 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43484 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111Ab2JXN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:58:39 -0400
Date: Wed, 24 Oct 2012 15:58:34 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121024135834.GA4368@breakpoint.cc>
References: <1349729943-28995-1-git-send-email-milinevskyy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349729943-28995-1-git-send-email-milinevskyy@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:59:03PM +0300, Dmytro Milinevskyy wrote:
> Convert USB descriptor's fields to CPU byte order before using locally in USB NCM gadget driver.
> Tested on MIPS32 big-endian device.
> 
> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
> ---
>  drivers/usb/gadget/f_ncm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
> index b651b52..fce45ab 100644
> --- a/drivers/usb/gadget/f_ncm.c
> +++ b/drivers/usb/gadget/f_ncm.c
> @@ -869,11 +869,11 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
>  	struct sk_buff	*skb2;
>  	int		ncb_len = 0;
>  	__le16		*tmp;
> -	int		div = ntb_parameters.wNdpInDivisor;
> -	int		rem = ntb_parameters.wNdpInPayloadRemainder;
> -	int		pad;
> -	int		ndp_align = ntb_parameters.wNdpInAlignment;
> -	int		ndp_pad;
> +	int	div = le16_to_cpu(ntb_parameters.wNdpInDivisor);
> +	int	rem = le16_to_cpu(ntb_parameters.wNdpInPayloadRemainder);
> +	int	pad;
> +	int	ndp_align = le16_to_cpu(ntb_parameters.wNdpInAlignment);
> +	int	ndp_pad;

It would be nice to keep the two tabs between int and variable. One question: 
In ntb_parameters the member wLength is 16bit and not using cpu_to_le16(). How
does it work? Is the test on host side not strict enough?

>  	unsigned	max_size = ncm->port.fixed_in_len;
>  	struct ndp_parser_opts *opts = ncm->parser_opts;
>  	unsigned	crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;

Sebastian
