Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0LLNuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:50:24 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:61140 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0LLNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:50:21 -0500
Message-ID: <4D04D2E2.20100@ru.mvista.com>
Date: Sun, 12 Dec 2010 16:49:22 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: sshtylyov@mvista.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, geomatsi@gmail.com,
        nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v2] ata: pata_at91.c bugfix for high master clock
References: <1292099846-24528-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1292099846-24528-1-git-send-email-plyatov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-12-2010 23:37, Igor Plyatov wrote:

> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
> does not detect ATA device.

> Signed-off-by: Igor Plyatov<plyatov@gmail.com>
[...]

> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index 0da0dcc..a462405 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
[...]
> @@ -50,7 +52,7 @@ struct at91_ide_info {
>   };
>
>   static const struct ata_timing initial_timing =
> -	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
> +	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 0, 600, 0};

    BTW, you haven't described this in the changelog...

WBR, Sergei
