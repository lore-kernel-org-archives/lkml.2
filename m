Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2GZHxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:53:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27869 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2GZHxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:53:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336348800"; 
   d="scan'208";a="13706842"
Message-ID: <1343289182.8016.38.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH] xen/p2m: Check __brk_limit before allocating.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Date: Thu, 26 Jul 2012 08:53:02 +0100
In-Reply-To: <1343161413-11077-1-git-send-email-konrad.wilk@oracle.com>
References: <1343161413-11077-1-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 16:23 -0400, Konrad Rzeszutek Wilk wrote:
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 64effdc..b5bb26c 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -498,7 +498,14 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  	return true;
>  }
> -
> +#include <asm/sections.h>
> +bool __init can_extend_brk()
> +{
> +	/* Always reserve one for the DMI extend_brk call. */

That seems a bit fragile, what if someone adds something else or the
link order changes etc?

Can't we just have a variant of extend_brk which returns NULL instead of
BUG_ON and do error checking?

Or even just change extend_brk and push the BUG_ONs out to the callers
-- there aren't that many of them.

Ian.
-- 
Ian Campbell


Most people in this society who aren't actively mad are, at best,
reformed or potential lunatics.
		-- Susan Sontag

