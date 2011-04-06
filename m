Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1DFMQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:16:09 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62660 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1DFMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AD0dLMbmPB08yISUbr128Fw83bA3pDh4TTXc+b0oEhG65LcSOJL7RsgaPzsv9JkaQ3
         4GyDlDlpqLlAeY580zLHAZ7afzVbWNkTgaJJ0Z0YCSFNOkdm9ZLRyHHDqBH+PFQ8ruGD
         78cFCuDaCG1/ZNjvgQvP906m/RST5FVO8T3Po=
Date: Wed, 6 Apr 2011 16:16:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 6/7] basic_mmio_gpio: support different
 input/output registers
Message-ID: <20110406121601.GA11329@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-7-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302088263-12714-7-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:11:02PM +0100, Jamie Iles wrote:
> Some controllers have separate input and output registers.  For these
> controllers, allow a register named "in" to be used for reading the
> value of a GPIO pin.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
[...]
> @@ -316,6 +340,8 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  	if (!bgc->reg_dat)
>  		return -ENOMEM;
>  
> +	spin_lock_init(&bgc->lock);
> +

Hm. This looks like a stray change, now bgpio_probe() calls spin_lock_init()
twice.

Other than that, the patch seems to be OK.

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
