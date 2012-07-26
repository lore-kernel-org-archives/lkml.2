Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2GZQr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:47:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30840 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2GZQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:47:28 -0400
Date: Thu, 26 Jul 2012 12:37:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Ian.Campbell@citrix.com, arnd@arndb.de,
        catalin.marinas@arm.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH 04/24] xen/arm: sync_bitops
Message-ID: <20120726163759.GE9222@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:33:46PM +0100, Stefano Stabellini wrote:
> sync_bitops functions are equivalent to the SMP implementation of the
> original functions, independently from CONFIG_SMP being defined.

So why can't the code be changed to use that? Is it that
the _set_bit, _clear_bit, etc are not available with !CONFIG_SMP?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/sync_bitops.h |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/include/asm/sync_bitops.h
> 
> diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
> new file mode 100644
> index 0000000..d975092903
> --- /dev/null
> +++ b/arch/arm/include/asm/sync_bitops.h
> @@ -0,0 +1,17 @@
> +#ifndef __ASM_SYNC_BITOPS_H__
> +#define __ASM_SYNC_BITOPS_H__
> +
> +#include <asm/bitops.h>
> +#include <asm/system.h>
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
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
