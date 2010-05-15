Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0EOUCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 16:02:09 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36339 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0EOUCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 16:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=pJP81UB0wrcqKpugC1Mq16TPjCpyJV5IBbUKtGoAp9poy0LOHFjZOWyWObEDRRoTmN
         VkbnL651Tqcq6G9+Sbe0AuzDFrH+LjcjBV8HYBnPtIqck/6j/6l0f4pbA3NpI07WnBma
         WJCgHIabpYPxocgUba/rDruKHUK1/S+y+Xy2M=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] MFD: prevent null pointer dereference in mfd_add_device
Date: Sat, 15 May 2010 22:01:58 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-2-686; KDE/4.3.4; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <201005152157.13121.florian@openwrt.org>
In-Reply-To: <201005152157.13121.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005152201.59885.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I just saw that your for-next branch contains the proper fix, this patch can be 
discarded.

Le samedi 15 mai 2010 21:57:10, Florian Fainelli a écrit :
> If a driver calls mfd_add_device with a NULL argument for the mem_base
>  resource we will end up dereferencing it without checking for its validity
>  here: res[r].start = mem_base->start cell->resources[r].start; (line 53 of
>  mfd-core.c)
> 
> This patch adds the checking on the mem_base argument and bails out
>  accordingly if it is NULL.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> CC: stable@kernel.org
> ---
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 8ffbb7a..f890b27 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -49,6 +49,8 @@ static int mfd_add_device(struct device *parent, int id,
> 
>  		/* Find out base to use */
>  		if (cell->resources[r].flags & IORESOURCE_MEM) {
> +			if (!mem_base)
> +				goto fail_res;
>  			res[r].parent = mem_base;
>  			res[r].start = mem_base->start +
>  				cell->resources[r].start;
> 

