Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2ETKyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 06:54:04 -0400
Received: from canardo.mork.no ([148.122.252.1]:53207 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab2ETKyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 06:54:01 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andrew Bird <ajb@spheresystems.co.uk>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] USB: qmi_wwan: Add ZTE (Vodafone) K3520-Z
Organization: m
References: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
	<1337502518-1444-3-git-send-email-ajb@spheresystems.co.uk>
Date: Sun, 20 May 2012 12:53:45 +0200
In-Reply-To: <1337502518-1444-3-git-send-email-ajb@spheresystems.co.uk>
	(Andrew Bird's message of "Sun, 20 May 2012 09:28:38 +0100")
Message-ID: <87y5ongm2u.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Bird <ajb@spheresystems.co.uk> writes:

> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>


Acked-by: Bjørn Mork <bjorn@mork.no>

>  /* ZTE suck at making USB descriptors */
> +static const struct driver_info	qmi_wwan_force_int1 = {
> +	.description	= "Qualcomm WWAN/QMI device",
> +	.flags		= FLAG_WWAN,
> +	.bind		= qmi_wwan_bind_shared,
> +	.unbind		= qmi_wwan_unbind_shared,
> +	.manage_power	= qmi_wwan_manage_power,
> +	.data		= BIT(1), /* interface whitelist bitmap */
> +};
> +
>  static const struct driver_info	qmi_wwan_force_int4 = {
>  	.description	= "Qualcomm WWAN/QMI device",
>  	.flags		= FLAG_WWAN,
> @@ -430,6 +439,15 @@ static const struct usb_device_id products[] = {
>  		.bInterfaceProtocol = 0xff,
>  		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
>  	},
> +	{	/* ZTE (Vodafone) K3520-Z */
> +		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
> +		.idVendor           = 0x19d2,
> +		.idProduct          = 0x0055,
> +		.bInterfaceClass    = 0xff,
> +		.bInterfaceSubClass = 0xff,
> +		.bInterfaceProtocol = 0xff,
> +		.driver_info        = (unsigned long)&qmi_wwan_force_int1,
> +	},
>  	{	/* ZTE (Vodafone) K3565-Z */
>  		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
>  		.idVendor           = 0x19d2,


Looking forward to changing all this to a single line device + interface
number macro in 3.6 :-)


Bjørn
