Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2KTPBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:01:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43539 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2KTPBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:01:18 -0500
Date: Tue, 20 Nov 2012 16:01:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3, v3] AMD64 EDAC: Cleanup type usage to be consistent
Message-ID: <20121120150110.GB28594@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1353319368-9179-1-git-send-email-daniel@numascale-asia.com>
 <1353319368-9179-3-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353319368-9179-3-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 06:02:48PM +0800, Daniel J Blueman wrote:
> As the Northbridge IDs are at most 16-bits, use the same type
> consistently and cleanup some indexes to use smaller types.
> 
> v2: Drop changes for later cleanups
> v3: Further changes suggested by Boris
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/include/asm/amd_nb.h    |    2 +-
>  arch/x86/include/asm/processor.h |    2 +-
>  arch/x86/kernel/cpu/amd.c        |    4 ++--
>  drivers/edac/amd64_edac.c        |   16 ++++++++--------
>  drivers/edac/amd64_edac.h        |    6 +++---
>  5 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 9f5532a..b0815a0 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -76,7 +76,7 @@ static inline bool amd_nb_has_feature(unsigned feature)
>  	return ((amd_northbridges.flags & feature) == feature);
>  }
>  
> -static inline struct amd_northbridge *node_to_amd_nb(int node)
> +static inline struct amd_northbridge *node_to_amd_nb(u16 node)
>  {
>  	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
>  }

You have a hunk in patch 1/3 changing the argument being passed to this
function to u16 but you're changing the actual function right here, in
3/3, which is strange and easy to puzzle a potential reviewer.

As a rule of thumb: always do your changes to the functions and their callsites
in one patch so that they belong together and can be reviewed easily.

Thanks.

-- 
Regards/Gruss,
Boris.
