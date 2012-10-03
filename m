Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2JCAiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:38:06 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53485 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2JCAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:38:03 -0400
Date: Wed, 3 Oct 2012 09:37:59 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Message-ID: <20121003003759.GD31207@verge.net.au>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <1349195816-2225-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349195816-2225-2-git-send-email-arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:36:40PM +0200, Arnd Bergmann wrote:
> The CONFIG_MEMORY_SIZE value is interpreted as a 32 bit integer, which
> makes sense on a system without PAE. I'm assuming 0x10000000 (256 MB)
> is the correct size, because that is used on most other shmobile
> boards.
> 
> Without this patch, building kota2_defconfig results in:

Hi Arnd,

I looked through my fines and found a config that I believe
worked with a derivative of 2.6.35.7.

It has CONFIG_MEMORY_SIZE=0x1e800000.

So what I suspect has happened is that an extra zero has crept into
arch/arm/configs/kota2_defconfig and the intended value is:

CONFIG_MEMORY_SIZE=0x1e000000

Unfortunately I do not have access to a board to test this,
nor am I aware of anyone who does.

> /home/arnd/linux-arm/arch/arm/kernel/setup.c:790:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: linux-sh@vger.kernel.org
> Cc: Simon Horman <horms@verge.net.au>
> ---
>  arch/arm/configs/kota2_defconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/kota2_defconfig b/arch/arm/configs/kota2_defconfig
> index b7735d6..0ea4c90 100644
> --- a/arch/arm/configs/kota2_defconfig
> +++ b/arch/arm/configs/kota2_defconfig
> @@ -21,7 +21,7 @@ CONFIG_ARCH_SHMOBILE=y
>  CONFIG_KEYBOARD_GPIO_POLLED=y
>  CONFIG_ARCH_SH73A0=y
>  CONFIG_MACH_KOTA2=y
> -CONFIG_MEMORY_SIZE=0x1e0000000
> +CONFIG_MEMORY_SIZE=0x10000000
>  # CONFIG_SH_TIMER_TMU is not set
>  # CONFIG_SWP_EMULATE is not set
>  CONFIG_CPU_BPREDICT_DISABLE=y
> -- 
> 1.7.10
> 
