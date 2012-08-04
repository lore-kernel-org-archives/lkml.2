Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2HDG53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:57:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47174 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2HDG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:57:28 -0400
Date: Sat, 4 Aug 2012 02:57:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 08/22] ARM: LPAE: use phys_addr_t for initrd location
 and size
In-Reply-To: <1343775898-28345-9-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040255100.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-9-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> From: Vitaly Andrianov <vitalya@ti.com>
> 
> This patch fixes the initrd setup code to use phys_addr_t instead of assuming
> 32-bit addressing.  Without this we cannot boot on systems where initrd is
> located above the 4G physical address limit.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> ---
>  arch/arm/mm/init.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 8252c31..51f3e92 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -36,12 +36,12 @@
>  
>  #include "mm.h"
>  
> -static unsigned long phys_initrd_start __initdata = 0;
> -static unsigned long phys_initrd_size __initdata = 0;
> +static phys_addr_t phys_initrd_start __initdata = 0;
> +static phys_addr_t phys_initrd_size __initdata = 0;

phys_addr_t for the initrd size is rather overkill, isn't it?


Nicolas
