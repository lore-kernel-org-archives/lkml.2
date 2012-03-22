Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038Ab2CVVvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:51:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2CVVvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:51:23 -0400
Date: Thu, 22 Mar 2012 14:51:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>
Subject: Re: [PATCH] backlight: Use id->driver_data to differentiate lp855x
 chips
Message-Id: <20120322145122.7d2f75e9.akpm@linux-foundation.org>
In-Reply-To: <1332324687.12310.2.camel@phoenix>
References: <1332324687.12310.2.camel@phoenix>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 18:11:27 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Current code has corresponding driver_data settings for different chip types.
> Use the driver_data to differentiate lp855x chips.
> 
> Also make lp855x_is_valid_rom_area() return bool instead of int.
> 
> -static int lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
> +static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
>  {
>
> ...
>
> -	return (addr >= start && addr <= end) ? 1 : 0;
> +	return (addr >= start && addr <= end) ? true : false;
>  }

This:

--- a/drivers/video/backlight/lp855x_bl.c~backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -82,7 +82,7 @@ static bool lp855x_is_valid_rom_area(str
 		return false;
 	}
 
-	return (addr >= start && addr <= end) ? true : false;
+	return (addr >= start && addr <= end);
 }
 
 static int lp855x_init_registers(struct lp855x *lp)
_

