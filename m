Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0JaRZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:25:15 -0400
Received: from void.printf.net ([89.145.121.20]:50539 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213Ab0JaRZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:25:14 -0400
Date: Sun, 31 Oct 2010 17:25:12 +0000
From: Chris Ball <cjb@laptop.org>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error
	-16
Message-ID: <20101031172512.GA20710@void.printf.net>
References: <4CCDA454.708@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCDA454.708@arndnet.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Oct 31, 2010 at 06:16:04PM +0100, Arnd Hannemann wrote:
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

We've been discussing this on the linux-mmc@ list:

   http://thread.gmane.org/gmane.linux.kernel.mmc/4342

Until we have a fix, you should be able to get SDIO working again by 
reverting all nine commits between 1978fda85d..ed2a978594.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
