Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab2F2UpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:45:07 -0400
Received: from hulk.biessmann.org ([62.75.166.25]:37339 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2F2UpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:45:06 -0400
Message-ID: <4FEE13C0.10505@biessmann.de>
Date: Fri, 29 Jun 2012 22:44:48 +0200
From: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: David Howells <dhowells@redhat.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm:gemini: fix irq.c
References: <1338981778-19938-1-git-send-email-andreas@biessmann.de>
In-Reply-To: <1338981778-19938-1-git-send-email-andreas@biessmann.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 82fd85f0510922526535d974951389e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.12 13:22, Andreas Bießmann wrote:
> Commit 9f97da78bf018206fb623cd351d454af2f105fe0 moved disable_hlt() from
> arch/arm/include/asm/system.h to arch/arm/include/asm/system_misc.h but missed
> to change arch/arm/mach-gemini/irq.c.
> 
> This patch fixes following error:
> 
> ---8<---
> arch/arm/mach-gemini/irq.c: In function 'gemini_init_irq':
> arch/arm/mach-gemini/irq.c:79:2: error: implicit declaration of function 'disable_hlt' [-Werror=implicit-function-declaration]
> --->8---
> 
> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
> cc: Hans Ulli Kroll <ulli.kroll@googlemail.com> 
> cc: Russell King <linux@arm.linux.org.uk>
> cc: linux-arm-kernel@lists.infradead.org
> ---
> Note: this is broken since 3.4 release, 3.3 is sane.

ping

> 
>  arch/arm/mach-gemini/irq.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
> index ca70e5f..020852d 100644
> --- a/arch/arm/mach-gemini/irq.c
> +++ b/arch/arm/mach-gemini/irq.c
> @@ -17,6 +17,7 @@
>  #include <linux/sched.h>
>  #include <asm/irq.h>
>  #include <asm/mach/irq.h>
> +#include <asm/system_misc.h>
>  #include <mach/hardware.h>
>  
>  #define IRQ_SOURCE(base_addr)	(base_addr + 0x00)
> 

