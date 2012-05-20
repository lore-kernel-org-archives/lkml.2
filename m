Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2ETKvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 06:51:11 -0400
Received: from canardo.mork.no ([148.122.252.1]:53180 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2ETKvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 06:51:09 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andrew Bird <ajb@spheresystems.co.uk>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] USB: qmi_wwan: Make forced int 4 whitelist generic
Organization: m
References: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
Date: Sun, 20 May 2012 12:50:56 +0200
In-Reply-To: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
	(Andrew Bird's message of "Sun, 20 May 2012 09:28:36 +0100")
Message-ID: <877gw7i0rz.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Bird <ajb@spheresystems.co.uk> writes:

> Change the forced interface 4 whitelist to use the generic shared
> binder instead of the Gobi specific one. Certain ZTE devices
> (K3520-Z & K3765-Z) don't work with the Gobi version, but function
> quite happily with the generic. This has been tested with the following
> devices:
> K3520-Z
> K3565-Z
> K3765-Z
> K4505-Z
> It hasn't been tested with the ZTE MF820D, which is the only other
> device that uses this whitelist at present. Although Bjorn doesn't
> expect any problems, any testing with that device would be appreciated.
>
> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
> ---
>  drivers/net/usb/qmi_wwan.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index d316503b..62a1a43 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -357,9 +357,9 @@ static const struct driver_info	qmi_wwan_gobi = {
>  
>  /* ZTE suck at making USB descriptors */
>  static const struct driver_info	qmi_wwan_force_int4 = {
> -	.description	= "Qualcomm Gobi wwan/QMI device",
> +	.description	= "Qualcomm WWAN/QMI device",
>  	.flags		= FLAG_WWAN,
> -	.bind		= qmi_wwan_bind_gobi,
> +	.bind		= qmi_wwan_bind_shared,
>  	.unbind		= qmi_wwan_unbind_shared,
>  	.manage_power	= qmi_wwan_manage_power,
>  	.data		= BIT(4), /* interface whitelist bitmap */

Acked-by: Bjørn Mork <bjorn@mork.no>

This fixes a logical error in the code.  Minidriver constructs with an
interface whitelist should not use qmi_wwan_bind_gobi.  It was made to
prevent binding to the serial interfaces on Gobi devices, and serves no
useful purpose when used with a whitelist.  The change is a no-op for
the ZTE MF820D, but is important for new devices.

Thanks for fixing this.


Bjør
