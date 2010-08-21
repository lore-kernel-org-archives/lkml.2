Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab0HUN3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:29:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55148 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0HUN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:29:21 -0400
Message-ID: <4C6FD450.6040405@ru.mvista.com>
Date: Sat, 21 Aug 2010 17:27:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Maxim Osipov <maxim.osipov@gmail.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
In-Reply-To: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Maxim Osipov wrote:

> Please find attached patch for
> https://bugzilla.kernel.org/show_bug.cgi?id=16023 problem.

    It's preferrable that the patahces areposted inline.

> Kind regards,
> Maxim

> From 43568dec4f387da4562d5bc81557c642a468b685 Mon Sep 17 00:00:00 2001
> From: Maxim Osipov <maxim.osipov@gmail.com>
> Date: Thu, 19 Aug 2010 07:25:28 +0400
> Subject: [PATCH] USB: Fix kernel oops with g_ether and Windows

> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
[...]
> diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
> index 5c0d06c..1043da1 100644
> --- a/drivers/usb/gadget/rndis.c
> +++ b/drivers/usb/gadget/rndis.c
> @@ -292,9 +292,13 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
>  	/* mandatory */
>  	case OID_GEN_VENDOR_DESCRIPTION:
>  		pr_debug("%s: OID_GEN_VENDOR_DESCRIPTION\n", __func__);
> -		length = strlen (rndis_per_dev_params [configNr].vendorDescr);
> -		memcpy (outbuf,
> -			rndis_per_dev_params [configNr].vendorDescr, length);
> +		if ( rndis_per_dev_params [configNr].vendorDescr ) {

    There should be not space after ( and before ). Run your patches thru 
scripts/checkpatch.pl before submitting please.

> +			length = strlen (rndis_per_dev_params [configNr].vendorDescr);
> +			memcpy (outbuf,
> +				rndis_per_dev_params [configNr].vendorDescr, length);

    Should be no space before ( either and before [ too.

WBR, Sergei

