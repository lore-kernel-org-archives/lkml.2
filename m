Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab0GNU5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:57:45 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:58128 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757338Ab0GNU5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:57:44 -0400
Message-ID: <4C3E24DE.7050208@bluewatersys.com>
Date: Thu, 15 Jul 2010 08:58:06 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
CC: Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/3] usb/host || arch/arm: Remove dead CONFIG_ARCH_KARO
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de> <9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
In-Reply-To: <9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:32 PM, Christian Dietrich wrote:
> CONFIG_ARCH_KARO doesn't exist in Kconfig and is never defined anywhere
> else, therefore removing all references for it from the source code.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  arch/arm/tools/mach-types  |    1 -
>  drivers/usb/host/isp1362.h |   24 +-----------------------
>  2 files changed, 1 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
> index 8f10d24..3d86318 100644
> --- a/arch/arm/tools/mach-types
> +++ b/arch/arm/tools/mach-types
> @@ -204,7 +204,6 @@ omaha			ARCH_OMAHA		OMAHA			186
>  ta7			ARCH_TA7		TA7			187
>  nova			SA1100_NOVA		NOVA			188
>  hmk			ARCH_HMK		HMK			189
> -karo			ARCH_KARO		KARO			190
>  fester			SA1100_FESTER		FESTER			191
>  gpi			ARCH_GPI		GPI			192
>  smdk2410		ARCH_SMDK2410		SMDK2410		193

Don't post patches for the mach-types file. It is generated
automatically from here the ARM machine registry:
http://www.arm.linux.org.uk/developer/machines/.

It is perfectly fine to have a machine type defined in mach-types which
is not supported in the mainline kernel. This allows developers to have
a stable machine id even if their board is not yet supported in the
mainline kernel.

> diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
> index d995351..0f97820 100644
> --- a/drivers/usb/host/isp1362.h
> +++ b/drivers/usb/host/isp1362.h
> @@ -8,29 +8,7 @@
>  /*
>   * Platform specific compile time options
>   */
> -#if defined(CONFIG_ARCH_KARO)
> -#include <asm/arch/hardware.h>
> -#include <asm/arch/pxa-regs.h>
> -#include <asm/arch/karo.h>
> -
> -#define USE_32BIT		1
> -
> -
> -/* These options are mutually eclusive */
> -#define USE_PLATFORM_DELAY	1
> -#define USE_NDELAY		0
> -/*
> - * MAX_ROOT_PORTS: Number of downstream ports
> - *
> - * The chip has two USB ports, one of which can be configured as
> - * an USB device port, so the value of this constant is implementation
> - * specific.
> - */
> -#define MAX_ROOT_PORTS		2
> -#define DUMMY_DELAY_ACCESS do {} while (0)
> -
> -/* insert platform specific definitions for other machines here */
> -#elif defined(CONFIG_BLACKFIN)
> +#if defined(CONFIG_BLACKFIN)
>  
>  #include <linux/io.h>
>  #define USE_32BIT		0

The rest of this patch looks fine. It appears the Karo stuff was added
when the ISP1362 driver was first committed. Probably some left over
development stuff that got missed.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
