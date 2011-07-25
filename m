Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1GYTCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:02:46 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:4512 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666Ab1GYTCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:02:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACS8LU5tgzvr/2dsb2JhbAA0AQEEAUAgJQUMCQMOBz0UASoDKhenWHiIfALABw6GMQSbIYgx
Date: Mon, 25 Jul 2011 21:02:41 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, jorge@dti2.net,
        Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-watchdog@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] watchdog: fix it8712f_wdt build errors
Message-ID: <20110725190241.GZ3834@infomag.iguana.be>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au> <20110725091927.e154fd28.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725091927.e154fd28.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build errors by adding missing header file:
> 
> drivers/watchdog/it8712f_wdt.c:127: error: implicit declaration of function 'request_muxed_region'
> drivers/watchdog/it8712f_wdt.c:141: error: implicit declaration of function 'release_region'
> drivers/watchdog/it8712f_wdt.c:412: error: implicit declaration of function 'request_region'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/watchdog/it8712f_wdt.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20110725.orig/drivers/watchdog/it8712f_wdt.c
> +++ linux-next-20110725/drivers/watchdog/it8712f_wdt.c
> @@ -31,6 +31,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
> +#include <linux/ioport.h>
>  
>  #define NAME "it8712f_wdt"

I see what happened: The pci.h removal patch compiled ok and the patch that introduced the muxed_region code also compiled ok (with pci.h still included). However both patches together reveal the issue indeed (pci.h includes ioport.h).

Sorry about that. I have added your patch for it.

Thanks,
wim.

