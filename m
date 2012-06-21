Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2FUTqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:46:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32244 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab2FUTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:46:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6749"; a="203435105"
Date: Thu, 21 Jun 2012 14:46:11 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>, linux-hexagon@vger.kernel.org,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Remove useless wrappers of asm-generic/cpumask.h
Message-ID: <20120621194610.GA19619@codeaurora.org>
References: <1340306406.1773.59.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340306406.1773.59.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 09:20:06PM +0200, Paul Bolle wrote:
> frv and xtensa both have a header (in their include/asm directories)
> that are thin wrappers around asm-generic/cpumask.h. These wrappers are
> useless, since that header doesn't exist. They are also unused (all
> files including asm/cpumask.h are x86 specific).
> 
> hexagon and openrisc generate similar headers at build time (using a
> generic-y entry in include/asm/Kbuild). These generated headers are
> useless and unused too.
> 
> Remove these headers and generic-y entries.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/frv/include/asm/cpumask.h    |    6 ------
>  arch/hexagon/include/asm/Kbuild   |    1 -
>  arch/openrisc/include/asm/Kbuild  |    1 -
>  arch/xtensa/include/asm/cpumask.h |   16 ----------------
>  4 files changed, 0 insertions(+), 24 deletions(-)
>  delete mode 100644 arch/frv/include/asm/cpumask.h
>  delete mode 100644 arch/xtensa/include/asm/cpumask.h
> 
> diff --git a/arch/frv/include/asm/cpumask.h b/arch/frv/include/asm/cpumask.h
> deleted file mode 100644
> index d999c20..0000000
> --- a/arch/frv/include/asm/cpumask.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_CPUMASK_H
> -#define _ASM_CPUMASK_H
> -
> -#include <asm-generic/cpumask.h>
> -
> -#endif /* _ASM_CPUMASK_H */
> diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
> index 9aa17f1..8ecd202 100644
> --- a/arch/hexagon/include/asm/Kbuild
> +++ b/arch/hexagon/include/asm/Kbuild
> @@ -7,7 +7,6 @@ header-y += user.h
>  generic-y += auxvec.h
>  generic-y += bug.h
>  generic-y += bugs.h
> -generic-y += cpumask.h
>  generic-y += cputime.h
>  generic-y += current.h
>  generic-y += device.h
> diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
> index 3f35c38..08484f7 100644
> --- a/arch/openrisc/include/asm/Kbuild
> +++ b/arch/openrisc/include/asm/Kbuild
> @@ -13,7 +13,6 @@ generic-y += cacheflush.h
>  generic-y += checksum.h
>  generic-y += cmpxchg.h
>  generic-y += cmpxchg-local.h
> -generic-y += cpumask.h
>  generic-y += cputime.h
>  generic-y += current.h
>  generic-y += device.h
> diff --git a/arch/xtensa/include/asm/cpumask.h b/arch/xtensa/include/asm/cpumask.h
> deleted file mode 100644
> index ebeede3..0000000
> --- a/arch/xtensa/include/asm/cpumask.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/*
> - * include/asm-xtensa/cpumask.h
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file "COPYING" in the main directory of this archive
> - * for more details.
> - *
> - * Copyright (C) 2001 - 2005 Tensilica Inc.
> - */
> -
> -#ifndef _XTENSA_CPUMASK_H
> -#define _XTENSA_CPUMASK_H
> -
> -#include <asm-generic/cpumask.h>
> -
> -#endif /* _XTENSA_CPUMASK_H */
> -- 
> 1.7.7.6
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
