Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1JJP2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:28:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44698 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751213Ab1JJP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:28:06 -0400
Date: Mon, 10 Oct 2011 11:28:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Harro Haan <hrhaan@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix ehci alignment error
In-Reply-To: <20111010124154.464239811@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110101127240.18069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Harro Haan wrote:

> The Kirkwood gave an unaligned memory access error on
> line 742 of drivers/usb/host/echi-hcd.c:
> "ehci->last_periodic_enable = ktime_get_real();"
> 
> Signed-off-by: Harro Haan <hrhaan@gmail.com>
> ---
>  include/linux/usb/hcd.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
> index 0097136..c0ecc5a 100644
> --- a/include/linux/usb/hcd.h
> +++ b/include/linux/usb/hcd.h
> @@ -178,7 +178,7 @@ struct usb_hcd {
>  	 * this structure.
>  	 */
>  	unsigned long hcd_priv[0]
> -			__attribute__ ((aligned(sizeof(unsigned long))));
> +			__attribute__ ((aligned(sizeof(s64))));
>  };
>  
>  /* 2.4 does this a bit differently ... */

Acked-by: Alan Stern <stern@rowland.harvard.edu>

