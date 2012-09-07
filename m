Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2IGTh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:37:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57787 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2IGThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:37:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 11/31] arm64: IRQ handling
Date: Fri, 7 Sep 2012 19:37:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-12-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-12-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071937.19156.arnd@arndb.de>
X-Provags-ID: V02:K0:SSymAhcnTrfc1Bez61DWCYeLiWew6CjYdbiuaxvaXWN
 W57y60axKqsC9TgYprUrBI6Gr5AFaqlBesgl6qYYn9YDXxFsNv
 Rc9fKNVttMMq4XujalNKd+BEkOI423kg93DyQXaKKDTn8jNZjI
 bATe7Uxmqadj1/K3j4pfujDFCW5VWxHNG2IQOLDvwF2zsF7sFQ
 7VqPim9WoXLy7xeCJWDgRE19mXMcfZeN3ECE+TEO7mDnqOBAnA
 RiNxaCIpAFr/u5Ouule+klR17KEnawNwVA7ZW2GeOwwufv54T9
 ZhmtiETIyBTf6Y5H9DN6d/T6JHdyUr97ILO0dwF4+L+8ShdZYk
 idEDrN1APUJPVuKVZA7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:

> +#define __inc_irq_stat(cpu, member)	__IRQ_STAT(cpu, member)++
> +#define __get_irq_stat(cpu, member)	__IRQ_STAT(cpu, member)

Isn't this something that the IRQ core code already keeps track of?

> +#endif /* __ASM_HARDIRQ_H */
> diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
> new file mode 100644
> index 0000000..a4e1cad
> --- /dev/null
> +++ b/arch/arm64/include/asm/irq.h
> @@ -0,0 +1,8 @@
> +#ifndef __ASM_IRQ_H
> +#define __ASM_IRQ_H
> +
> +#include <asm-generic/irq.h>
> +
> +extern void (*handle_arch_irq)(struct pt_regs *);
> +
> +#endif

Is this one still needed?

	Arnd
