Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0KJMd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:33:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41097 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab0KJMdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:33:25 -0500
Subject: Re: [PATCH] Fix implicit declaration of 'in_irq' in linux/highmem.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101110113106.11019.13707.stgit@e102109-lin.cambridge.arm.com>
References: <20101110113106.11019.13707.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 13:33:19 +0100
Message-ID: <1289392399.2191.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 11:31 +0000, Catalin Marinas wrote:
> Commit 3e4d3af introduced the kmap_atomic_idx_push() function which
> warns on in_irq() with CONFIG_DEBUG_HIGHMEM enabled. This patch includes
> linux/hardirq.h for the in_irq definition.

Ah, indeed. The whole KS/LPC thing made me forget about this issue.
Somehow it only triggered on ARM.

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/highmem.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index e913819..b676c58 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -5,6 +5,7 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/uaccess.h>
> +#include <linux/hardirq.h>
>  
>  #include <asm/cacheflush.h>
>  
> 


