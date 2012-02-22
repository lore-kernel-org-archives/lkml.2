Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2BVOwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:52:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2BVOwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:52:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2 12/19] ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
Date: Wed, 22 Feb 2012 14:50:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rmallon@gmail.com,
        linux@arm.linux.org.uk
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <bcf67fab836268c6f3a5b5618d44e3fdf3525af0.1329903206.git.nicolas.ferre@atmel.com>
In-Reply-To: <bcf67fab836268c6f3a5b5618d44e3fdf3525af0.1329903206.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221450.04390.arnd@arndb.de>
X-Provags-ID: V02:K0:fq4EbBq1JG8tbQHGFFV0dC0EfGdgNql1ox1FZWpf2uy
 V1KSg7GbHgE2Mn7/j8Akpb/L77EdlGAkD/xcTSDM3SuWj7bFlh
 cypSlmGDJeSqOQG66V6fj7uTb+AjKG8J1g/xTvjNmAm7oooarA
 U5B+zDQ/EvY291nt5XQzC0x18bzwG3IqcfoKOozJb/xV8ac66B
 8NUF8ElT/2cdpElxcCtPJmR6XwSQpDcoxvjwLk8Do/G5Yyg3+k
 F8hrJvXfrVUVwQczx5YD5PwteBjyyX4ficS0PlDeHJ5jJBpnM0
 2Q4Hvlsle/Bvjizroo6TIM1KcdInIrYIzP84QJ7SX4QwmavGe+
 y3bIFKO+JrjU8qIRgf5Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 February 2012, Nicolas Ferre wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> For the RTT as RTC driver rtc-at91sam9, the platform_device structure
> is filled during SoC initialization. This will allow to convert this
> RTC driver as a standard platform driver.

Can you make this more elaborate? I don't see from this or the code why
you don't just always register the RTT as "rtc-at91sam9". There seems to
be no driver for the "at91_rtt" in tree, so I don't know if there is
an out of tree driver binding to it.

Would it be possible to remove the compile time #if and the resetting
of the device name if both drivers bind to the rtc name and the other
rtt driver binds to both names?
 
>  static int __init at91_rtc_init(void)
>  {
> -	int status;
> -	struct device *rtc;
> -
> -	status = platform_driver_register(&at91_rtc_driver);
> -	if (status)
> -		return status;
> -	rtc = bus_find_device(&platform_bus_type, NULL,
> -			NULL, at91_rtc_match);
> -	if (!rtc)
> -		platform_driver_unregister(&at91_rtc_driver);
> -	return rtc ? 0 : -ENODEV;
> +	return platform_driver_register(&at91_rtc_driver);
>  }
>  module_init(at91_rtc_init);

This can become module_platform_driver().

	Arnd
