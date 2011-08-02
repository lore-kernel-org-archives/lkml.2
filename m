Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1HBJ5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:57:37 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:40120 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab1HBJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:57:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAF/JN05tgyMH/2dsb2JhbABCp194gUABAQU6PxAIA0YUJQMhiAHBFw6GNASjYQ
Date: Tue, 2 Aug 2011 11:57:30 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC PATCH] watchdog: ep93xx: Use the WatchDog Timer Driver
	Core.
Message-ID: <20110802095729.GO4227@infomag.iguana.be>
References: <201108011357.24745.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108011357.24745.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H Hartley,

[...]
> @@ -210,43 +126,31 @@ static int __init ep93xx_wdt_init(void)
>  {
>  	int err;
>  
> -	err = misc_register(&ep93xx_wdt_miscdev);
> +	ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG);
> +	ep93xx_wdd.timeout = timeout;
> +
> +	err = watchdog_register_device(&ep93xx_wdd);
> +	if (err)
> +		return err;
>  
> -	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
> +	setup_timer(&timer, ep93xx_timer_ping, 1);

Shouldn't the bootstatus setting be:
ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
(or something similar with the WDIOF_OVERHEAT, ... flags).

Kind regards,
Wim.

