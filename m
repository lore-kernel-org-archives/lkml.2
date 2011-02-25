Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1BYLAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:00:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab1BYLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:00:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AsLZtMQWyaiaXErAzKGkVI2qgEqZGImslZqk8Ymrnhvb+UpaGh21g2Mj3dnCopalm1
         F2xZht4rW+kat67H43NfxVaT0v3JGCdfXhKcOy/8ZHwa+I5WOeK6kvDtQRJSxP9HpsMh
         8mjOQuj1ETwDmWsnAIep1US7xQ0JA/EA9YAFg=
Subject: Re: [PATCH 1/1] omap3: nand: report corrected ecc errors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: John Ogness <john.ogness@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87oc64qr5b.fsf@vostro.fn.ogness.net>
References: <87oc64qr5b.fsf@vostro.fn.ogness.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 12:59:09 +0200
Message-ID: <1298631549.2798.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 11:50 +0100, John Ogness wrote:
> From: John Ogness <john.ogness@linutronix.de>
> 
> The number of corrected ECC errors should be reported since other MTD
> systems make use of this information (such as UBI data scrubbing).
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Hi, could you please CC the OMAP mailing List
(linux-omap@vger.kernel.org) and probably TI people who seem to take
care about the NAND driver nowadays, like "Sukumar Ghorai
<s-ghorai@ti.com>"


> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index 4e33972..a58465c 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -773,7 +773,7 @@ static int omap_compare_ecc(u8 *ecc_data1,	/* read from NAND memory */
>  
>  		page_data[find_byte] ^= (1 << find_bit);
>  
> -		return 0;
> +		return 1;

Could you please also improve the comment of this function and document
the error codes - it was obvious when the codes were 0 and -1, and
becomes less obvious when they are -1, 0, and 1.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

