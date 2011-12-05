Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1LEP6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:58:35 -0500
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:45713 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932411Ab1LEP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:58:33 -0500
X-Greylist: delayed 1737 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 10:58:32 EST
Date: Mon, 5 Dec 2011 16:53:59 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        keguang.zhang@gmail.com, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        zhao zhang <zhzhl555@gmail.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [rtc-linux] [PATCH] MIPS: Add RTC support for loongson1B
Message-ID: <20111205155359.GF9192@game.jcrosoft.org>
References: <1322729078-6141-1-git-send-email-zhzhl555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322729078-6141-1-git-send-email-zhzhl555@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16856128980892036017
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredvnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredvnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepne
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:44 Thu 01 Dec     , zhzhl555@gmail.com wrote:
> From: zhao zhang <zhzhl555@gmail.com>
> 
> V2: use new module_platform_driver macro.
> thanks for Wolfram's advice.
> 
> This patch adds RTC support(TOY counter0) for loongson1B.
> Signed-off-by: zhao zhang <zhzhl555@gmail.com>
> ---
>  drivers/rtc/Kconfig    |   10 ++
>  drivers/rtc/Makefile   |    1 +
>  drivers/rtc/rtc-ls1x.c |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 225 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-ls1x.c
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 5a538fc..6f8c2d7 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1070,4 +1070,14 @@ config RTC_DRV_PUV3
>  	  This drive can also be built as a module. If so, the module
>  	  will be called rtc-puv3.
>  
> +config RTC_DRV_LOONGSON1
> +	tristate "loongson1 RTC support"
> +	depends on MACH_LOONGSON1
> +	help
> +	  This is a driver for the loongson1 on-chip Counter0 (Time-Of-Year
> +	  counter) to be used as a RTC.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called rtc-ls1x.
> +
>  endif # RTC_CLASS
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 6e69823..48153fe 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -109,3 +109,4 @@ obj-$(CONFIG_RTC_DRV_VT8500)	+= rtc-vt8500.o
>  obj-$(CONFIG_RTC_DRV_WM831X)	+= rtc-wm831x.o
>  obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
>  obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
> +obj-$(CONFIG_RTC_DRV_LOONGSON1)	+= rtc-ls1x.o
keep it ordered


you have no alarm, irq on this hardware?

Best Regards,
J.
