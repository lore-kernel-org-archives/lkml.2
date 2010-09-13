Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0IMM2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:28:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51475 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab0IMM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:28:13 -0400
Message-ID: <4C8E18AD.8000502@ru.mvista.com>
Date: Mon, 13 Sep 2010 16:27:25 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: tom.leiming@gmail.com
CC: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <balbi@ti.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com> <1283873014-32511-6-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1283873014-32511-6-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>

> Complete the current request only if the data transfer is over.

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Felipe Balbi <me@felipebalbi.com>
> Cc: Anand Gadiyar <gadiyar@ti.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> ---
>  drivers/usb/musb/musb_gadget.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)

> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index f3ee04f..fa826f9 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -501,14 +501,14 @@ void musb_g_tx(struct musb *musb, u8 epnum)
>  				request->zero = 0;
>  			}
>  
> -			/* ... or if not, then complete it. */
> -			musb_g_giveback(musb_ep, request, 0);
> -
> -			request = musb_ep->desc ? next_request(musb_ep) : NULL;
> -			if (!request) {
> -				DBG(4, "%s idle now\n",
> -					musb_ep->end_point.name);
> -				return;
> +			if (request->actual == request->length) {

    But why not modify the conditional above all that code, just excluding 
'is_dma' from it. This conditional already includes (request->actual == 
request->length) check. Please recast this patch.

> +				musb_g_giveback(musb_ep, request, 0);
> +				request = musb_ep->desc ? next_request(musb_ep) : NULL;
> +				if (!request) {
> +					DBG(4, "%s idle now\n",
> +						musb_ep->end_point.name);
> +					return;
> +				}
>  			}
>  		}
>  

WBR, Sergei
