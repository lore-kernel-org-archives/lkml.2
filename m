Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2K3RRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:17:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51149 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab2K3RRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:17:52 -0500
Date: Fri, 30 Nov 2012 18:17:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v8] AMD64 EDAC: Fix type usage in NB IDs and memory
 ranges
Message-ID: <20121130171749.GB23034@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
 <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 04:44:20PM +0800, Daniel J Blueman wrote:
> Use appropriate types for northbridge IDs and memory ranges. Mark immutable
> data const and keep within compilation unit on related structures. Tested on
> multi-socket server and multi-server, multi-socket NumaConnect setup.
> 
> v7: Refactor patches grouping changes
> v8: Drop unneeded change; use const and static where appropriate
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/include/asm/amd_nb.h |    2 +-
>  drivers/edac/amd64_edac.c     |   26 +++++++++++++-------------
>  drivers/edac/amd64_edac.h     |    6 +++---
>  3 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 417eb24..d2e703b 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -76,7 +76,7 @@ static inline bool amd_nb_has_feature(unsigned feature)
>  	return ((amd_northbridges.flags & feature) == feature);
>  }
>  
> -static inline struct amd_northbridge *node_to_amd_nb(int node)
> +static inline struct amd_northbridge *node_to_amd_nb(u16 node)

I'm dropping this change from this patch because if we go with it,
we'll have to change all callsites of node_to_amd_nb which would cause
unnecessary churn.

So, I've applied the final patchset and uploaded a branch here:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git numascale

Please give it a run on both configurations and let me know if something
is still amiss.

Thanks.

-- 
Regards/Gruss,
    Boris.
