Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1HaNua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:50:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1HaNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:50:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 17/35] Hexagon: Add interrupts
Date: Wed, 31 Aug 2011 15:50:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190801.353140948@codeaurora.org>
In-Reply-To: <20110830190801.353140948@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311550.23240.arnd@arndb.de>
X-Provags-ID: V02:K0:7/lVmxozXYPAYcq/xgkUynQ7UusZ+i/c5JhSOrhcofJ
 Lghm7dKMc5jT7hIgtA80mOvc7ntHxxR8ye40Zf18IF81Cza0Vx
 BTaceLIW46SQZtJS57ID90Rou/XdbSGfgCfos7Oyn+wWXv1xUa
 J3b+yI3FYEwLnE+T8R1bAgcrHGO/BwfqCu5gVRtWDsAADMpE1B
 rf5zxJGoJWeR+4JWxkn+dw+0loIp2FbO6kL7dD7eVyDk5i1LMA
 b3noIQfVO6suUhk7tSEpiMmpAxZuj+LBZUGRGZsag8xCXOrVDJ
 c1SJlfS//2AmXjTrm3SO+qla12zU94DcjLbNjZu+wL7sbqXbq4
 JPbFAWz1QzozNbuxztfE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> +
> +/* Number of first-level interrupts associated with the CPU core. */
> +#define HEXAGON_CPUINTS 32
> +
> +/*
> + * XXX TODO FIXME this should be pulled from a platform file!
> + * Must define NR_IRQS before including <asm-generic/irq.h>
> + * 64 == the two SIRC's, 176 == the two gpio's
> + */
> +#define NR_IRQS (HEXAGON_CPUINTS + 64 + 176)

I disagree with that comment: NR_IRQS is a constant and should
not be platform specific. There should be no compile-time settings
that are strictly specific to one platform, otherwise you are not
able to run the same kernel on multiple platforms, which is very
valuable for testing purposes.

Just make the constant large enough to always fit. Use sparse IRQs
if necessary.

> +#include <asm-generic/irq.h>
> +
> +extern void __init hexagon_cpu_irq_init(void);
> +

I don't think you actually need to declare hexagon_cpu_irq_init(), just
rename that function to init_IRQ() and remove the wrapper.

	Arnd
