Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab1ETPxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:53:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60293 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab1ETPx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r3cIv+CAIXcPv3if8q0BO0KcNRoAQ1c/nPBQo/Xi07yNDlKViEmEbWfqryBuyyYRkW
         NeMXWFGx9ssQgjlDRne9f8B/38Gfbn9UNZK8KtZP3rLUq9x/ceHuXAiBAD9v0m4dpqR3
         0cpC/f0/cdMpDgWS7OVFzOOBACQh956e7/B2w=
Date: Fri, 20 May 2011 19:47:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] ds2760_battery: Fix rated capacity of the hx4700
 1800mAh battery
Message-ID: <20110520154724.GB18099@oksana.dev.rtsoft.ru>
References: <E1QEM6f-0000Db-K0@outmx05.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1QEM6f-0000Db-K0@outmx05.plus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 01:45:40PM +0000, Paul Parsons wrote:
> Fix rated capacity of the HP iPAQ hx4700 3.7V 1800mAh (359113-001) battery. For this battery the value of the rated capacity EEPROM register at 0x32 is 7; thus rated_capacities[7] = 1800.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>

Applied, thanks!

> ---
> --- clean-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-03-15 01:20:32.000000000 +0000
> +++ linux-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-04-25 13:06:29.344976841 +0100
> @@ -86,7 +86,11 @@ static int rated_capacities[] = {
>  	920,	/* NEC */
>  	1440,	/* Samsung */
>  	1440,	/* BYD */
> +#ifdef CONFIG_MACH_H4700

Note that this is OK as a temporary fix, but in general such fixups
should be done via platform data. So, it would be great if you could
prepare another patch on top of this one, which would do things in
a proper way.

> +	1800,	/* HP iPAQ hx4700 3.7V 1800mAh (359113-001) */
> +#else
>  	1440,	/* Lishen */
> +#endif
>  	1440,	/* NEC */
>  	2880,	/* Samsung */
>  	2880,	/* BYD */

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
