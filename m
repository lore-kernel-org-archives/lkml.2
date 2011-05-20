Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab1ETPsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:48:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37046 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab1ETPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=tTIITfxUMjTtsALGeIxHuifj2LKKArX2UvT0qYyRcJV76uoDdjWsMXdAE0rG9e5N7Q
         4Ib2ndZ1AaEnjBR2AkPIBFeh/5XEcNife+NfwaXkk7ZCXpwNvt7wEJPvPKlCSVWb1vt7
         eDbH96qw7CMkxQHrVfzgM9V8TU3YDWOdMLqno=
Date: Fri, 20 May 2011 19:48:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] ds2760_battery: Fix indexing of the 4 active full
 EEPROM registers
Message-ID: <20110520154810.GC18099@oksana.dev.rtsoft.ru>
References: <E1QEN0d-0007iM-LV@outmx04.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1QEN0d-0007iM-LV@outmx04.plus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 02:43:30PM +0000, Paul Parsons wrote:
> Fix indexing of the 4 active full EEPROM registers. The indexing was out by 1, accessing the EEPROM registers at 0x23 to 0x26 instead of 0x22 to 0x25.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>

Applied, thank you!

> ---
> --- clean-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-03-15 01:20:32.000000000 +0000
> +++ linux-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-04-25 13:06:29.344976841 +0100
> @@ -186,7 +190,7 @@ static int ds2760_battery_read_status(st
>  
>  	scale[0] = di->full_active_uAh;
>  	for (i = 1; i < 5; i++)
> -		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 2 + i];
> +		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 1 + i];
>  
>  	di->full_active_uAh = battery_interpolate(scale, di->temp_C / 10);
>  	di->full_active_uAh *= 1000; /* convert to ÂµAh */

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
