Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0JaRfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:35:24 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:51906 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756219Ab0JaRfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:35:20 -0400
Message-ID: <4CCDA8D6.7030905@arndnet.de>
Date: Sun, 31 Oct 2010 18:35:18 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error
 -16
References: <4CCDA454.708@arndnet.de>
In-Reply-To: <4CCDA454.708@arndnet.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 31.10.2010 18:16, schrieb Arnd Hannemann:

> on todays Linus' git (v2.6.36-9871-g3985c7c) b43 sdio stopped working.
> It was working on (v2.6.36-6794-g12ba8d1).
> 
> b43-sdio: probe of mmc0:0001:1 failed with error -16
> 
> The error seems to originate from the following code in drivers/mmc/core/sdio_bus.c:sdio_bus_probe()
> 
> 135         ret = pm_runtime_get_sync(dev);
> 136         if (ret < 0)
> 137                 goto out;
> 
> so I suspect this has something to do with the following commit: 
> 
> commit 40bba0c1ca83a370f749c8bc9afda71cf79ebd91
> Author: Ohad Ben-Cohen <ohad@wizery.com>
> Date:   Sat Oct 2 13:54:11 2010 +0200
> 
>     mmc: sdio: enable runtime PM for SDIO functions
> 
> However, simply reverting 40bba0c1ca83a370f749c8bc9afda71cf79ebd91 does not work because then
> modprobe hangs.
> 
> Tested on AP4EVB (arm) with tmio_mmc. Any ideas?

FYI:

disabling CONFIG_PM_RUNTIME in my config seems to fix the issue for me.

Best regards,
Arnd
