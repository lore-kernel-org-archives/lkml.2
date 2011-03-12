Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1CLVAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:00:33 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:56138 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755485Ab1CLVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:00:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Z81cJAIbMWyso5IoMu9r8H33hi4/l93j9aQBVS6T+QUkxQyVDiuaw2IF3FYq7lRizpMv0n/JxYXAh2rB87g2vOq8+S6eCizUZCB5K5hRmZtTXfjvXVNBU0oMMSGrB0eH;
Date: Sat, 12 Mar 2011 13:00:28 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 05/13] i2c-designware: split of i2c-designware.c into
 core and bus specific parts
Message-Id: <20110312130028.8cf8973b.rdunlap@xenotime.net>
In-Reply-To: <1299961407-26852-6-git-send-email-dirk.brandewie@gmail.com>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
	<1299961407-26852-6-git-send-email-dirk.brandewie@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Mar 2011 12:23:19 -0800 dirk.brandewie@gmail.com wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch splits i2c-designware.c into three pieces:
>      i2c-designware-core.c, contains the code that interacts directly
>      with the core.
> 
>      i2c-designware-platdrv.c, contains the code specific to the
>      platform driver using the core.
> 
>      i2c-designware-core.h contains the definitions and declareations
>      shared by i2c-designware-core.c and i2c-designware-platdrv.c.
> 
> This patch is the first in a set to allow multiple instances of the
> designware I2C core in the system.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/i2c/busses/Kconfig                         |    6 +-
>  drivers/i2c/busses/Makefile                        |    3 +-
>  .../{i2c-designware.c => i2c-designware-core.c}    |  353 +-------------------
>  drivers/i2c/busses/i2c-designware-core.h           |  194 +++++++++++
>  drivers/i2c/busses/i2c-designware-platdrv.c        |  199 +++++++++++
>  5 files changed, 412 insertions(+), 343 deletions(-)
>  rename drivers/i2c/busses/{i2c-designware.c => i2c-designware-core.c} (60%)
>  create mode 100644 drivers/i2c/busses/i2c-designware-core.h
>  create mode 100644 drivers/i2c/busses/i2c-designware-platdrv.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 113505a..35b5e6b 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -347,15 +347,15 @@ config I2C_DAVINCI
>  	  devices such as DaVinci NIC.
>  	  For details please see http://www.ti.com/davinci
>  
> -config I2C_DESIGNWARE
> -	tristate "Synopsys DesignWare"
> +config I2C_DESIGNWARE_PLATFORM
> +	tristate "Synopsys DesignWare Platfrom"

	                              Platform

>  	depends on HAVE_CLK
>  	help
>  	  If you say yes to this option, support will be included for the
>  	  Synopsys DesignWare I2C adapter. Only master mode is supported.
>  
>  	  This driver can also be built as a module.  If so, the module
> -	  will be called i2c-designware.
> +	  will be called i2c-designware-platform.
>  
>  config I2C_GPIO
>  	tristate "GPIO-based bitbanging I2C"

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
