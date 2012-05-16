Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2EPL4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:56:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56459 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2EPL4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
References: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
Date: Wed, 16 May 2012 19:56:33 +0800
Message-ID: <CACVXFVNzmq74BKYZN1SpXYULneV2ASmniMhs4LhevPm-XgSJpg@mail.gmail.com>
Subject: Re: [PATCH 1/1] smsc95xx: add FLAG_POINTTOPOINT flag for driver_info
From: Ming Lei <tom.leiming@gmail.com>
To: jgq516@gmail.com
Cc: steve.glendinning@smsc.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 4:01 PM,  <jgq516@gmail.com> wrote:
> From: Xiao Jiang <jgq516@gmail.com>
>
> commit c26134 introduced FLAG_POINTTOPOINT flag for USB ethernet devices
> which possibly use "usb%d" names, add this flag to make sure pandaboard
> can mount nfs with smsc95xx NIC.

Without the flag, I also can mount nfs successfully on my Pandaboard...

>
> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
> ---
>  drivers/net/usb/smsc95xx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 94ae669..e158288 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1192,7 +1192,8 @@ static const struct driver_info smsc95xx_info = {
>        .rx_fixup       = smsc95xx_rx_fixup,
>        .tx_fixup       = smsc95xx_tx_fixup,
>        .status         = smsc95xx_status,
> -       .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_LINK_INTR,
> +       .flags          = FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_SEND_ZLP |
> +                         FLAG_LINK_INTR,
>  };
>
>  static const struct usb_device_id products[] = {
> --
> 1.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Thanks,
-- 
Ming Lei
