Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2HOVbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:31:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57402 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab2HOVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:31:37 -0400
Date: Wed, 15 Aug 2012 23:31:26 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Huacai Chen <chenhuacai@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH V5 13/18] drm: Define SAREA_MAX for Loongson (PageSize =
 16KB).
Message-ID: <20120815213126.GC15844@linux-mips.org>
References: <1344677543-22591-1-git-send-email-chenhc@lemote.com>
 <1344677543-22591-14-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344677543-22591-14-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 05:32:18PM +0800, Huacai Chen wrote:

> Subject: [PATCH V5 13/18] drm: Define SAREA_MAX for Loongson (PageSize = 16KB).

But your code doesn't define it just for Loongsson as the log message claims
but rather for all MIPS.

> diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
> index ee5389d..1d1a858 100644
> --- a/include/drm/drm_sarea.h
> +++ b/include/drm/drm_sarea.h
> @@ -37,6 +37,8 @@
>  /* SAREA area needs to be at least a page */
>  #if defined(__alpha__)
>  #define SAREA_MAX                       0x2000U
> +#elif defined(__mips__)
> +#define SAREA_MAX                       0x4000U

How about replacing this whole #ifdef mess with something like:

#include <linux/kernel.h>
#include <asm/page.h>

/* Intel 830M driver needs at least 8k SAREA */
#define SAREA_MAX	max(PAGE_SIZE, 0x2000U)

MIPS also uses 64K page size and your patch as posted would break with 64k
pages.

  Ralf
