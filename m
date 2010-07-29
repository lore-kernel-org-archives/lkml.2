Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab0G2Q0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:26:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0G2Q0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:26:53 -0400
Message-ID: <4C51AB6A.4030105@oracle.com>
Date: Thu, 29 Jul 2010 09:25:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Jarod Wilson <jarod@wilsonet.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        lirc-list@lists.sourceforge.net, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for July 28 (lirc #2)
References: <20100728162855.4968e561.sfr@canb.auug.org.au> <20100728102417.be60049a.randy.dunlap@oracle.com> <20100728220454.GK8564@aniel.lan> <4C50AC26.1080100@oracle.com> <AANLkTi=DLHOnzgXmpzNE3PQXp-xSkm8vLdxBBf1mcFuO@mail.gmail.com> <AANLkTimTbZ6Vjqe5rqNVtNwPV=qoo=BOsOwG_6fS1SZU@mail.gmail.com> <20100729123941.GL8564@aniel.lan>
In-Reply-To: <20100729123941.GL8564@aniel.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C51ABB3.013B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/10 05:39, Janne Grunau wrote:
> On Thu, Jul 29, 2010 at 12:27:01AM -0400, Jarod Wilson wrote:
>> On Wed, Jul 28, 2010 at 6:27 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>>> On Wed, Jul 28, 2010 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>> On 07/28/10 15:04, Janne Grunau wrote:
>>>>> On Wed, Jul 28, 2010 at 10:24:17AM -0700, Randy Dunlap wrote:
>>>>>> On Wed, 28 Jul 2010 16:28:55 +1000 Stephen Rothwell wrote:
>>>>>>
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Changes since 20100727:
>>>>>>
>>>>>>
>>>>>> When USB_SUPPORT is not enabled and MEDIA_SUPPORT is not enabled:
>>>>>>
>>>>>
>>>>> following patch should fix it
>>>>>
>>>>> Janne
>>>>
>>>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>> Thanks.
>>>
>>> Acked-by: Jarod Wilson <jarod@redhat.com>
>>>
>>> Indeed, thanks much, Janne!
>>
>> D'oh, I should have looked a bit closer... What if instead of making
>> all the drivers depend on both LIRC && LIRC_STAGING, LIRC_STAGING just
>> depends on LIRC?
> 
> I started adding LIRC to each driver by one. Adding LIRC as LIRC_STAGING
> dependency is simpler. See updated patch.
> 
>> And there are a few depends lines with duplicate
>> USB's in them and LIRC_IMON should have USB added to it (technically,
> 
> D'oh, I've must have stopped reading after LIRC_STAG...
> 
> fixed and added additional dependencies
> 
> Janne

Yes, this one works also.  Thanks for the update.

> 
> From 45d384de90e3709a986700db14888eff77bb7e1f Mon Sep 17 00:00:00 2001
> From: Janne Grunau <j@jannau.net>
> Date: Wed, 28 Jul 2010 23:53:35 +0200
> Subject: [PATCH 1/2] V4L/DVB: staging/lirc: fix Kconfig dependencies
> 
> Signed-off-by: Janne Grunau <j@jannau.net>
> ---
>  drivers/staging/lirc/Kconfig |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/lirc/Kconfig
> index 968c2ade..ab30a09 100644
> --- a/drivers/staging/lirc/Kconfig
> +++ b/drivers/staging/lirc/Kconfig
> @@ -3,6 +3,7 @@
>  #
>  menuconfig LIRC_STAGING
>  	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
> +	depends on LIRC
>  	help
>  	  Say Y here, and all supported Linux Infrared Remote Control IR and
>  	  RF receiver and transmitter drivers will be displayed. When paired
> @@ -13,13 +14,13 @@ if LIRC_STAGING
>  
>  config LIRC_BT829
>          tristate "BT829 based hardware"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && PCI
>  	help
>  	  Driver for the IR interface on BT829-based hardware
>  
>  config LIRC_ENE0100
>  	tristate "ENE KB3924/ENE0100 CIR Port Reciever"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && PNP
>  	help
>  	  This is a driver for CIR port handled by ENE KB3924 embedded
>  	  controller found on some notebooks.
> @@ -27,7 +28,7 @@ config LIRC_ENE0100
>  
>  config LIRC_I2C
>  	tristate "I2C Based IR Receivers"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && I2C
>  	help
>  	  Driver for I2C-based IR receivers, such as those commonly
>  	  found onboard Hauppauge PVR-150/250/350 video capture cards
> @@ -40,7 +41,7 @@ config LIRC_IGORPLUGUSB
>  
>  config LIRC_IMON
>  	tristate "Legacy SoundGraph iMON Receiver and Display"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && USB
>  	help
>  	  Driver for the original SoundGraph iMON IR Receiver and Display
>  
> @@ -48,7 +49,7 @@ config LIRC_IMON
>  
>  config LIRC_IT87
>  	tristate "ITE IT87XX CIR Port Receiver"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && PNP
>  	help
>  	  Driver for the ITE IT87xx IR Receiver
>  
> @@ -60,13 +61,13 @@ config LIRC_ITE8709
>  
>  config LIRC_PARALLEL
>  	tristate "Homebrew Parallel Port Receiver"
> -	depends on LIRC_STAGING && !SMP
> +	depends on LIRC_STAGING && PARPORT && !SMP
>  	help
>  	  Driver for Homebrew Parallel Port Receivers
>  
>  config LIRC_SASEM
>  	tristate "Sasem USB IR Remote"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && USB
>  	help
>  	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
>  
> @@ -91,7 +92,7 @@ config LIRC_SIR
>  
>  config LIRC_STREAMZAP
>  	tristate "Streamzap PC Receiver"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && USB
>  	help
>  	  Driver for the Streamzap PC Receiver
>  
> @@ -103,7 +104,7 @@ config LIRC_TTUSBIR
>  
>  config LIRC_ZILOG
>  	tristate "Zilog/Hauppauge IR Transmitter"
> -	depends on LIRC_STAGING
> +	depends on LIRC_STAGING && I2C
>  	help
>  	  Driver for the Zilog/Hauppauge IR Transmitter, found on
>  	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
