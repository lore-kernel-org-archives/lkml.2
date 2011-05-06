Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1EFWP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:15:57 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58588 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751949Ab1EFWPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:15:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FI3bkhhsRS6rxgRufJIO2N9GHh26CslugJcojkMjZGgzyZa1ay6Dg7FZn9ey1DP38cJmjR7AYHhQNQUCETmevqB4PdhqrX7olkMZ/FgxomTLsnCdNPE2v5RJZ9UrDesl;
Date: Fri, 6 May 2011 15:15:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: <akpm@linux-foundation.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <allen.kao@atheros.com>,
        <roman.gezikov@atheros.com>, <joonas.viskari@atheros.com>
Subject: Re: [RFC 1/2] misc: add Atheros ar1520 GPS support
Message-Id: <20110506151543.c96ece07.rdunlap@xenotime.net>
In-Reply-To: <1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
	<1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 15:09:39 -0700 Luis R. Rodriguez wrote:

> From: Allen Kao <allen.kao@atheros.com>
> 
> This adds support for the Atheros ar1520 GPS device.
> 
> Cc: Roman Gezikov <roman.gezikov@atheros.com>
> Cc: Joonas Viskari <joonas.viskari@atheros.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> Signed-off-by: Allen Kao <allen.kao@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/misc/Kconfig   |   10 ++
>  drivers/misc/Makefile  |    1 +
>  drivers/misc/ar1520.c  |  406 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ar1520.h |   49 ++++++
>  4 files changed, 466 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/ar1520.c
>  create mode 100644 include/linux/ar1520.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4e007c6..7108214 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -379,6 +379,16 @@ config HMC6352
>  	  This driver provides support for the Honeywell HMC6352 compass,
>  	  providing configuration and heading data via sysfs.
>  
> +config AR1520
> +	tristate "Atheros AR1520 support"
> +	depends on I2C

Looks like it also depends on GPIOLIB.

> +	help
> +	  If you say yes here you get support for the Atheros
> +	  AR1520 GPS chip.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ar1520. If unsure, say N here.
> +
>  config EP93XX_PWM
>  	tristate "EP93xx PWM support"
>  	depends on ARCH_EP93XX



+#define AR1520_IOCTL_MAGIC      0xc2

^^^^^ needs to be added to Documentation/ioctl/ioctl-number.txt, please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
