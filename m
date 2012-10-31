Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab2JaSzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:55:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50361 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab2JaSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:55:33 -0400
Date: Wed, 31 Oct 2012 19:55:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH 2/4, v2] AMD64 EDAC: Add support for >255 memory
 controllers
Message-ID: <20121031185530.GK24389@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Torsten Kaiser <just.for.lkml@googlemail.com>
References: <1351662932-22279-2-git-send-email-daniel@numascale-asia.com>
 <1351673292-31359-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351673292-31359-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:48:12PM +0800, Daniel J Blueman wrote:
> As the AMD64 last-level-cache ID is 16-bits and federated systems
> eg using Numascale's NumaConnect/NumaChip can have more than 255 memory
> controllers, use 16-bits to store the ID.
> 
> v2: Avoid change to intlv_en variable
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  drivers/edac/amd64_edac.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 18d404a..28b2005 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -942,7 +942,8 @@ static u64 get_error_address(struct mce *m)
>  		struct amd64_pvt *pvt;
>  		u64 cc6_base, tmp_addr;
>  		u32 tmp;
> -		u8 mce_nid, intlv_en;
> +		u16 mce_nid;
> +		u8 intlv_en;
>  
>  		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
>  			return addr;
> @@ -1499,7 +1500,7 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>  	u8 channel;
>  	bool high_range = false;
>  
> -	u8 node_id    = dram_dst_node(pvt, range);
> +	u16 node_id   = dram_dst_node(pvt, range);

No need for that change since the field dram_dst_node returns is 3 bits
wide (see F1x4{0,4}).

-- 
Regards/Gruss,
    Boris.
