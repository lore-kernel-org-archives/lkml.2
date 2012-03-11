Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2CKNvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:51:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39874 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2CKNvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:51:49 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-usb@vger.kernel.org,
        =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs
 with CONFIG_USB_FUNCTIONFS_ETH
References: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
Date: Sun, 11 Mar 2012 14:51:46 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wa0d4ki73l0zgt@mpn-glaptop>
In-Reply-To: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 14:31:10 +0100, Lothar Waßmann <LW@karo-electronics.de> wrote:

> commit 28824b18ac4705e876a282a15ea0de8fc957551f:
> |Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
> |Date:   Wed May 5 12:53:13 2010 +0200
> |
> |    USB: gadget: __init and __exit tags removed
> |
> |    __init, __initdata and __exit tags have have been removed from
> |    various files to make it possible for gadgets that do not use
> |    the __init/__exit tags to use those.
> obviously missed (at least) this case leading to a section mismatch in
> g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.
>
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/f_subset.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
> index c154064..3974bc9 100644
> --- a/drivers/usb/gadget/f_subset.c
> +++ b/drivers/usb/gadget/f_subset.c
> @@ -404,7 +404,7 @@ geth_unbind(struct usb_configuration *c, struct usb_function *f)
>   * Caller must have called @gether_setup().  Caller is also responsible
>   * for calling @gether_cleanup() before module unload.
>   */
> -int __init geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
> +int geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
>  {
>  	struct f_gether	*geth;
>  	int		status;


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
