Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0ICB2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:28:49 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:61616 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751281Ab0ICB2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:28:47 -0400
Message-ID: <4C804F3A.8020001@snapgear.com>
Date: Fri, 3 Sep 2010 11:28:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix M68K irqflags
References: <19747.1283422807@redhat.com> <20100902102203.19806.39028.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100902102203.19806.39028.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 01:28:44.0938 (UTC) FILETIME=[598BCEA0:01CB4B07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

David Howells wrote:
> From: Greg Ungerer <gerg@snapgear.com>

Almost :-)


>  arch/m68k/include/asm/entry_no.h    |    2 -
>  arch/m68k/include/asm/irqflags.h    |   76 +++++++++++++++++++++++++++++++++++
>  arch/m68k/include/asm/system_mm.h   |   25 ------------
>  arch/m68k/include/asm/system_no.h   |   57 --------------------------
>  arch/m68knommu/kernel/asm-offsets.c |    2 -
>  include/asm-generic/hardirq.h       |    1 
>  6 files changed, 79 insertions(+), 84 deletions(-)
>  create mode 100644 arch/m68k/include/asm/irqflags.h
[snip]
>  #endif /* _M68KNOMMU_SYSTEM_H */
> diff --git a/arch/m68knommu/kernel/asm-offsets.c b/arch/m68knommu/kernel/asm-offsets.c
> index 9a8876f..2433502 100644
> --- a/arch/m68knommu/kernel/asm-offsets.c
> +++ b/arch/m68knommu/kernel/asm-offsets.c
> @@ -74,8 +74,6 @@ int main(void)
>  
>  	DEFINE(PT_PTRACED, PT_PTRACED);
>  
> -	DEFINE(THREAD_SIZE, THREAD_SIZE);
> -

This breaks final link due to missing THREAD_SIZE definition in head.S:

   LD      vmlinux
arch/m68knommu/platform/coldfire/head.o: In function `_clear_bss':
(.head.text+0xa4): undefined reference to `THREAD_SIZE'


Without that asm-offsets.c change it works on my ColdFire boards.
I am happy with it:

Acked-by:  Greg Ungerer <gerg@uclinux.org>

Thanks
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
