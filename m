Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0KOGrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:47:01 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51579 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab0KOGrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:47:00 -0500
Date: Mon, 15 Nov 2010 15:46:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [v2,3/8] NUMA Hotplug emulator
Message-ID: <20101115064627.GG8489@linux-sh.org>
References: <20101113061519.GM32501@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113061519.GM32501@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 02:15:19PM +0800, Shaohui Zheng wrote:
> diff --git a/mm/Kconfig b/mm/Kconfig
> index f0fb912..a01a679 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -147,6 +147,21 @@ config MEMORY_HOTREMOVE
>  	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
>  	depends on MIGRATION
>  
> +config NUMA_HOTPLUG_EMU
> +	bool "NUMA hotplug emulator"
> +	depends on X86_64 && NUMA && MEMORY_HOTPLUG
> +
How about something like a dummy ARCH_ENABLE_NUMA_EMU instead? The
architecture bits here are quite minimal, and with some further
abstraction it should be trivially supportable by any platform with NUMA
and memblock support (and most (all?) of the NUMA capable platforms
support memblock now already).
