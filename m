Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2HFVnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:43:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62767 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2HFVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:43:43 -0400
Date: Mon, 6 Aug 2012 14:43:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 1/2] hid: Blacklist new eBeam classic device
Message-ID: <20120806214340.GA30355@kroah.com>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
 <1344288104-20731-2-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344288104-20731-2-git-send-email-yann.cantin@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:21:43PM +0200, Yann Cantin wrote:
> 
> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> ---
>  drivers/hid/hid-core.c |    3 +++
>  drivers/hid/hid-ids.h  |    3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 60ea284..b1ed8ee 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1908,6 +1908,9 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
> +#if defined(CONFIG_INPUT_EBEAM_USB)
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_CLASSIC) },
> +#endif

Why is this #if in here?  Just always do it, how could it not be
defined?

greg k-h
