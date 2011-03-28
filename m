Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1C1MKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:10:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55281 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1C1MKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:10:30 -0400
Message-ID: <4D906C40.6040104@ru.mvista.com>
Date: Mon, 28 Mar 2011 15:08:48 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_at91.c bugfix for initial_timing initialisation
References: <1301313545-22730-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1301313545-22730-1-git-send-email-plyatov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Igor Plyatov wrote:

> The "struct ata_timing" must contain 10 members, but ".dmack_hold" member was
> forgotten for "initial_timing" initialisation. This patch fixes such a problem.

> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---
>  drivers/ata/pata_at91.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index 0da0dcc..d1aaeb5 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -49,8 +49,9 @@ struct at91_ide_info {
>  	void __iomem *alt_addr;
>  };
>  
> -static const struct ata_timing initial_timing =
> -	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
> +static const struct ata_timing initial_timing = {
> +	XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0
> +};

    Frankly, I don't see any difference.

WBR, Sergei
