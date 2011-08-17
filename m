Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1HQUle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:41:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab1HQUjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 08/36] Hexagon: Add delay functions
Date: Wed, 17 Aug 2011 21:38:35 +0200
Message-ID: <101063053.zZmSHVMM0X@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.622136231@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.622136231@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FxlmYGMiYxmxUj80N/RGXnw9UrdVUm7hJU+eD4URvRd
 2qvBPDi0ZHwAswwvw410yvgQHv329RBtmIPE7fdoHHE3J6oy9/
 EHMP8WY+EiAd0ZEpPIgZeRvRUUaq3NlQQ3yS/OhINhd0JH7gP2
 ++G5F/HCSuKhptc0P8RSRhCcHZS5C8x6Anym3DmsHVBgrGH3rj
 8iDnj7fUZiAqpIzgbjy8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:05 Richard Kuo wrote:
> +#include <asm/param.h>
> +
> +extern void __udelay(unsigned long usecs);
> +
> +#define udelay(usecs) __udelay((usecs))
> +
> +extern void __delay(unsigned long loops);

If you have any kind of reliable timer register, it's better
to poll that than to rely on a delay loop that is especially
inaccurate when running under a hypervisor.

That also speeds up boot time because you no longer need to
calibrate the delay loop.

	Arnd
