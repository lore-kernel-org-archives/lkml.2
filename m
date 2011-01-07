Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1AGMH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:07:58 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:44752 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1AGMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:07:57 -0500
Message-ID: <4D270213.7000104@t-online.de>
Date: Fri, 07 Jan 2011 13:07:47 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sergey Vlasov <vsu@altlinux.ru>, Greg KH <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [PATCH v2] USB: usb-storage: unusual_devs update for TrekStor
 DataStation maxi g.u external hard drive enclosure
References: <4D11FD18.6090100@t-online.de>
In-Reply-To: <4D11FD18.6090100@t-online.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: bdn0HOZbghVxNn9WwhgTjASPJq1f0AiE++AH7H1rnbpTlWpl0tzCRMR6dHd1viWZvk
X-TOI-MSGID: a315fa83-b73a-41ae-b3cf-04007359430d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The TrekStor DataStation maxi g.u external hard drive enclosure uses a
> JMicron USB to SATA chip which needs the US_FL_IGNORE_RESIDUE flag to work
> properly.
>
> Signed-off-by: Richard Schütz <r.schtz@t-online.de>
> ---
>
> Applies to 2.6.37-rc7 now.
>
> --- a/drivers/usb/storage/unusual_devs.h 2010-12-21 20:26:40.000000000 +0100
> +++ b/drivers/usb/storage/unusual_devs.h 2010-12-22 13:37:58.438818902 +0100
> @@ -1872,6 +1872,15 @@ UNUSUAL_DEV( 0x1908, 0x3335, 0x0200, 0x0
> USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> US_FL_NO_READ_DISC_INFO ),
>
> +/* Patch by Richard Schütz <r.schtz@t-online.de>
> + * This external hard drive enclosure uses a JMicron chip which
> + * needs the US_FL_IGNORE_RESIDUE flag to work properly. */
> +UNUSUAL_DEV( 0x1e68, 0x001b, 0x0000, 0x0000,
> + "TrekStor GmbH & Co. KG",
> + "DataStation maxi g.u",
> + USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> + US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
> +
> UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
> "ST",
> "2A",
>

Why was this simple patch not accepted (yet)? Is something wrong with it?

Discussion was here:
http://thread.gmane.org/gmane.linux.usb.general/40545
http://thread.gmane.org/gmane.linux.usb.general/40550

-- 
Richard Schütz
