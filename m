Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2FQUvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:51:08 -0400
Received: from canardo.mork.no ([148.122.252.1]:58935 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab2FQUvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:51:05 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Thomas =?utf-8?B?U2Now4PigqxmZXI=?= <tschaefer@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 46/69] USB: cdc-wdm: Add Vodafone/Huawei K5005 support
Organization: m
References: <20120617175947.875700790@decadent.org.uk>
Date: Sun, 17 Jun 2012 22:50:39 +0200
In-Reply-To: <20120617175947.875700790@decadent.org.uk> (Ben Hutchings's
	message of "Sun, 17 Jun 2012 19:00:27 +0100")
Message-ID: <871uldslwg.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Bjørn Mork <bjorn@mork.no>
>
> commit de102ef41f24a4c251c4a3838796bb27557d4d93 upstream.
>
> Tested-by: Thomas Schäfer <tschaefer@t-online.de>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/class/cdc-wdm.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
> index ea8b304..8fd398d 100644
> --- a/drivers/usb/class/cdc-wdm.c
> +++ b/drivers/usb/class/cdc-wdm.c
> @@ -55,6 +55,15 @@ static const struct usb_device_id wdm_ids[] = {
>  		.bInterfaceSubClass = 1,
>  		.bInterfaceProtocol = 9, /* NOTE: CDC ECM control interface! */
>  	},
> +	{
> +		 /* Vodafone/Huawei K5005 (12d1:14c8) and similar modems */
> +		.match_flags        = USB_DEVICE_ID_MATCH_VENDOR |
> +				      USB_DEVICE_ID_MATCH_INT_INFO,
> +		.idVendor           = HUAWEI_VENDOR_ID,
> +		.bInterfaceClass    = USB_CLASS_VENDOR_SPEC,
> +		.bInterfaceSubClass = 1,
> +		.bInterfaceProtocol = 57, /* NOTE: CDC ECM control interface! */
> +	},
>  	{ }
>  };


This interface is half of a control+data interface set being handled by
the cdc-wdm and qmi_wwan drivers in cooperation.  The qmi_wwan driver
was first included in 3.4. 

Adding only half of the set to cdc-wdm in older stable versions does not
make much sense. I believe this patch should only be applied to 3.4.x
and later.  Sorry for not thinking about this earlier and making it
clear in the patch submission.



Bjørn
