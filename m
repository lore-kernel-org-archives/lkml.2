Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0G1WRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:17:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24212 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab0G1WRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:17:36 -0400
Message-ID: <4C50AC26.1080100@oracle.com>
Date: Wed, 28 Jul 2010 15:16:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, lirc-list@lists.sourceforge.net,
        Jarod Wilson <jarod@wilsonet.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for July 28 (lirc #2)
References: <20100728162855.4968e561.sfr@canb.auug.org.au> <20100728102417.be60049a.randy.dunlap@oracle.com> <20100728220454.GK8564@aniel.lan>
In-Reply-To: <20100728220454.GK8564@aniel.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C50AC68.0023:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/10 15:04, Janne Grunau wrote:
> On Wed, Jul 28, 2010 at 10:24:17AM -0700, Randy Dunlap wrote:
>> On Wed, 28 Jul 2010 16:28:55 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20100727:
>>
>>
>> When USB_SUPPORT is not enabled and MEDIA_SUPPORT is not enabled:
>>
> 
> following patch should fix it
> 
> Janne

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


> 
> From 7d1cc98c19a6c27dd74a28f04dfe4248a0b335ce Mon Sep 17 00:00:00 2001
> From: Janne Grunau <j@jannau.net>
> Date: Wed, 28 Jul 2010 23:53:35 +0200
> Subject: [PATCH 1/2] staging/lirc: fix Kconfig dependencies
> 
> Signed-off-by: Janne Grunau <j@jannau.net>
> ---
>  drivers/staging/lirc/Kconfig |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/lirc/Kconfig
> index 968c2ade..3981a4a 100644
> --- a/drivers/staging/lirc/Kconfig
> +++ b/drivers/staging/lirc/Kconfig
> @@ -13,13 +13,13 @@ if LIRC_STAGING
>  
>  config LIRC_BT829
>          tristate "BT829 based hardware"
> -	depends on LIRC_STAGING
> +	depends on LIRC && LIRC_STAGING
>  	help
>  	  Driver for the IR interface on BT829-based hardware
>  
>  config LIRC_ENE0100
>  	tristate "ENE KB3924/ENE0100 CIR Port Reciever"
> -	depends on LIRC_STAGING
> +	depends on LIRC && LIRC_STAGING
>  	help
>  	  This is a driver for CIR port handled by ENE KB3924 embedded
>  	  controller found on some notebooks.
> @@ -27,20 +27,20 @@ config LIRC_ENE0100
>  
>  config LIRC_I2C
>  	tristate "I2C Based IR Receivers"
> -	depends on LIRC_STAGING
> +	depends on I2C && LIRC && LIRC_STAGING
>  	help
>  	  Driver for I2C-based IR receivers, such as those commonly
>  	  found onboard Hauppauge PVR-150/250/350 video capture cards
>  
>  config LIRC_IGORPLUGUSB
>  	tristate "Igor Cesko's USB IR Receiver"
> -	depends on LIRC_STAGING && USB
> +	depends on USB && LIRC && LIRC_STAGING && USB
>  	help
>  	  Driver for Igor Cesko's USB IR Receiver
>  
>  config LIRC_IMON
>  	tristate "Legacy SoundGraph iMON Receiver and Display"
> -	depends on LIRC_STAGING
> +	depends on LIRC && LIRC_STAGING
>  	help
>  	  Driver for the original SoundGraph iMON IR Receiver and Display
>  
> @@ -48,31 +48,31 @@ config LIRC_IMON
>  
>  config LIRC_IT87
>  	tristate "ITE IT87XX CIR Port Receiver"
> -	depends on LIRC_STAGING
> +	depends on LIRC && LIRC_STAGING
>  	help
>  	  Driver for the ITE IT87xx IR Receiver
>  
>  config LIRC_ITE8709
>  	tristate "ITE8709 CIR Port Receiver"
> -	depends on LIRC_STAGING && PNP
> +	depends on LIRC && LIRC_STAGING && PNP
>  	help
>  	  Driver for the ITE8709 IR Receiver
>  
>  config LIRC_PARALLEL
>  	tristate "Homebrew Parallel Port Receiver"
> -	depends on LIRC_STAGING && !SMP
> +	depends on LIRC && LIRC_STAGING && !SMP
>  	help
>  	  Driver for Homebrew Parallel Port Receivers
>  
>  config LIRC_SASEM
>  	tristate "Sasem USB IR Remote"
> -	depends on LIRC_STAGING
> +	depends on USB && LIRC && LIRC_STAGING
>  	help
>  	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
>  
>  config LIRC_SERIAL
>  	tristate "Homebrew Serial Port Receiver"
> -	depends on LIRC_STAGING
> +	depends on LIRC && LIRC_STAGING
>  	help
>  	  Driver for Homebrew Serial Port Receivers
>  
> @@ -85,25 +85,25 @@ config LIRC_SERIAL_TRANSMITTER
>  
>  config LIRC_SIR
>  	tristate "Built-in SIR IrDA port"
> -	depends on LIRC_STAGING
> +	depends on LIRC && LIRC_STAGING
>  	help
>  	  Driver for the SIR IrDA port
>  
>  config LIRC_STREAMZAP
>  	tristate "Streamzap PC Receiver"
> -	depends on LIRC_STAGING
> +	depends on USB && LIRC && LIRC_STAGING
>  	help
>  	  Driver for the Streamzap PC Receiver
>  
>  config LIRC_TTUSBIR
>  	tristate "Technotrend USB IR Receiver"
> -	depends on LIRC_STAGING && USB
> +	depends on USB && LIRC && LIRC_STAGING && USB
>  	help
>  	  Driver for the Technotrend USB IR Receiver
>  
>  config LIRC_ZILOG
>  	tristate "Zilog/Hauppauge IR Transmitter"
> -	depends on LIRC_STAGING
> +	depends on I2C && LIRC && LIRC_STAGING
>  	help
>  	  Driver for the Zilog/Hauppauge IR Transmitter, found on
>  	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
