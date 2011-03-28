Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1C1MJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:09:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1C1MJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VYYJZsXF6vIkctnb8CpIt5SHxSNlMv286HCSSrX1xovMUtJfXB7In9D96c0Q5/MLA9
         cUlcGEdiT4RaDwvUSLy8ThvlakyDy98Mc17cxbh7XMtJtL89jvQ/ALEVgkz9mcmwrQZu
         ZyuxN/BI/jr6ObkVLCDu1QvO3gosM2RfDPeDk=
Subject: Re: [PATCH] ata: pata_at91.c bugfix for initial_timing
 initialisation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1301313545-22730-1-git-send-email-plyatov@gmail.com>
References: <1301313545-22730-1-git-send-email-plyatov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 14:09:30 +0200
Message-ID: <1301314170.3182.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 mars 2011 à 15:59 +0400, Igor Plyatov a écrit :
> The "struct ata_timing" must contain 10 members, but ".dmack_hold" member was
> forgotten for "initial_timing" initialisation. This patch fixes such a problem.
> 
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---
>  drivers/ata/pata_at91.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
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

Oh well.

	XFER_PIO_0, 70, 290, 240, 600, 165, 150, 0, 600, 0

Or even better, use C99 initializer ?


