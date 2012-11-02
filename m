Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2KBLru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:47:50 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:35198 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2KBLrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:47:48 -0400
Message-ID: <5093B29B.8070000@mvista.com>
Date: Fri, 02 Nov 2012 15:46:35 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
References: <50929233.7030609@gmail.com>
In-Reply-To: <50929233.7030609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-11-2012 19:16, Dmytro Milinevskyy wrote:

> Convert USB descriptor's fields to CPU byte order before using locally in USB
> NCM gadget driver.
> Tested on MIPS32 big-endian device.

> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
> ---
>   drivers/usb/gadget/f_ncm.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
> index b651b52..a7cdd47 100644
> --- a/drivers/usb/gadget/f_ncm.c
> +++ b/drivers/usb/gadget/f_ncm.c
[...]
> @@ -869,15 +869,19 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
>       struct sk_buff    *skb2;
>       int        ncb_len = 0;
>       __le16        *tmp;
> -    int        div = ntb_parameters.wNdpInDivisor;
> -    int        rem = ntb_parameters.wNdpInPayloadRemainder;
> +    int        div;
> +    int        rem;
>       int        pad;
> -    int        ndp_align = ntb_parameters.wNdpInAlignment;
> +    int        ndp_align;
>       int        ndp_pad;
>       unsigned    max_size = ncm->port.fixed_in_len;
>       struct ndp_parser_opts *opts = ncm->parser_opts;
>       unsigned    crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
>   +    div = le16_to_cpu(ntb_parameters.wNdpInDivisor);

     Probably corrupt patch -- there shouldn't be spaces before '+'.

WBR, Sergei

