Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2K2Oe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:34:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56020 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2K2Oe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:34:56 -0500
Date: Thu, 29 Nov 2012 15:34:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v7] AMD64 EDAC: Fix type usage in NB IDs and memory
 ranges
Message-ID: <20121129143452.GD30789@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
 <1353997932-8475-4-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353997932-8475-4-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:32:12PM +0800, Daniel J Blueman wrote:
> Use appropriate types for northbridge IDs and memory ranges.
> 
> v7: Refactor patches grouping changes
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/include/asm/amd_nb.h |    2 +-
>  drivers/edac/amd64_edac.c     |   20 ++++++++++----------
>  drivers/edac/amd64_edac.h     |    6 +++---
>  3 files changed, 14 insertions(+), 14 deletions(-)
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
>  {
>  	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
>  }
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 62b7b17..b27412a 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
>   * DRAM base/limit associated with node_id
>   */
>  static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
> -				   unsigned nid)
> +				   u8 nid)
>  {
>  	u64 addr;
>  
> @@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
>  						u64 sys_addr)
>  {
>  	struct amd64_pvt *pvt;
> -	unsigned node_id;
> +	u8 node_id;
>  	u32 intlv_en, bits;
>  
>  	/*
> @@ -1348,7 +1348,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
>  }
>  
>  /* Convert the sys_addr to the normalized DCT address */
> -static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
> +static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
>  				 u64 sys_addr, bool hi_rng,
>  				 u32 dct_sel_base_addr)
>  {
> @@ -1399,7 +1399,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
>   * checks if the csrow passed in is marked as SPARED, if so returns the new
>   * spare row
>   */
> -static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
> +static int f10_process_possible_spare(struct amd64_pvt *pvt, u16 dct, int csrow)

This one can stay u8 since it comes from dram_dst_node() through
f1x_lookup_addr_in_dct() and it is u8 already there.

But, in general, the patches look much more straightforward and easy to
review, so please add those minor changes and I'll pick them up.

Also, I'm assuming you're testing them on both your Numascale systems
and on a normal AMD multisocket box, correct?

Thanks.

-- 
Regards/Gruss,
    Boris.
