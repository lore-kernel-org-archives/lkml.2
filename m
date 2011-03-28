Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1C1QQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:16:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46103 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1C1QQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:16:26 -0400
Message-ID: <4D90B3ED.8080608@ru.mvista.com>
Date: Mon, 28 Mar 2011 20:14:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] ata: pata_at91.c bugfix for initial_timing initialisation
References: <1301316975-27761-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1301316975-27761-1-git-send-email-plyatov@gmail.com>
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
>  drivers/ata/pata_at91.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)

> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index 0da0dcc..0267d54 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -49,8 +49,18 @@ struct at91_ide_info {
>  	void __iomem *alt_addr;
>  };
>  
> -static const struct ata_timing initial_timing =
> -	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
> +static const struct ata_timing initial_timing = {
> +	.mode		= XFER_PIO_0,
> +	.setup		= 70,
> +	.act8b		= 290,
> +	.rec8b		= 240,
> +	.cyc8b		= 600,
> +	.active		= 165,
> +	.recover	= 150,
> +	.dmack_hold	= 0,
> +	.cycle		= 600,
> +	.udma		= 0
> +};

   There's no need to explicitly initialize to 0.

MBR, Sergei

