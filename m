Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2HGSXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:23:16 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31491 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2HGSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:23:12 -0400
Date: Tue, 7 Aug 2012 14:13:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 04/23] xen/arm: sync_bitops
Message-ID: <20120807181329.GH15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:07PM +0100, Stefano Stabellini wrote:
> sync_bitops functions are equivalent to the SMP implementation of the
> original functions, independently from CONFIG_SMP being defined.
> 
> We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
> under Xen you might be communicating with a completely external entity
> who might be on another CPU (e.g. two uniprocessor guests communicating
> via event channels and grant tables). So we need a variant of the bit
> ops which are SMP safe even on a UP kernel.

Ack from me.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/sync_bitops.h |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/include/asm/sync_bitops.h
> 
> diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
> new file mode 100644
> index 0000000..63479ee
> --- /dev/null
> +++ b/arch/arm/include/asm/sync_bitops.h
> @@ -0,0 +1,27 @@
> +#ifndef __ASM_SYNC_BITOPS_H__
> +#define __ASM_SYNC_BITOPS_H__
> +
> +#include <asm/bitops.h>
> +#include <asm/system.h>
> +
> +/* sync_bitops functions are equivalent to the SMP implementation of the
> + * original functions, independently from CONFIG_SMP being defined.
> + *
> + * We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
> + * under Xen you might be communicating with a completely external entity
> + * who might be on another CPU (e.g. two uniprocessor guests communicating
> + * via event channels and grant tables). So we need a variant of the bit
> + * ops which are SMP safe even on a UP kernel.
> + */
> +
> +#define sync_set_bit(nr, p)		_set_bit(nr, p)
> +#define sync_clear_bit(nr, p)		_clear_bit(nr, p)
> +#define sync_change_bit(nr, p)		_change_bit(nr, p)
> +#define sync_test_and_set_bit(nr, p)	_test_and_set_bit(nr, p)
> +#define sync_test_and_clear_bit(nr, p)	_test_and_clear_bit(nr, p)
> +#define sync_test_and_change_bit(nr, p)	_test_and_change_bit(nr, p)
> +#define sync_test_bit(nr, addr)		test_bit(nr, addr)
> +#define sync_cmpxchg			cmpxchg
> +
> +
> +#endif
> -- 
> 1.7.2.5
