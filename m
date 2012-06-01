Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449Ab2FAVRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:17:17 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:55007 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab2FAVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:17:13 -0400
Message-ID: <4FC93154.1060906@bootc.net>
Date: Fri, 01 Jun 2012 22:17:08 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120529 Thunderbird/13.0
MIME-Version: 1.0
To: Chris Boot <bootc@bootc.net>
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nix@esperi.org.uk,
        carolyn.wyborny@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] e1000e: Disable ASPM L1 on 82574
References: <1335216578-21542-1-git-send-email-bootc@bootc.net> <1335216578-21542-2-git-send-email-bootc@bootc.net>
In-Reply-To: <1335216578-21542-2-git-send-email-bootc@bootc.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/2012 22:29, Chris Boot wrote:
> ASPM on the 82574 causes trouble. Currently the driver disables L0s for
> this NIC but only disables L1 if the MTU is >1500. This patch simply
> causes L1 to be disabled regardless of the MTU setting.
>
> Signed-off-by: Chris Boot <bootc@bootc.net>
> Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
> Cc: Nix <nix@esperi.org.uk>
> Link: https://lkml.org/lkml/2012/3/19/362
> ---
>  drivers/net/ethernet/intel/e1000e/82571.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
> index b3fdc69..c6d95f2 100644
> --- a/drivers/net/ethernet/intel/e1000e/82571.c
> +++ b/drivers/net/ethernet/intel/e1000e/82571.c
> @@ -2061,8 +2061,9 @@ const struct e1000_info e1000_82574_info = {
>  				  | FLAG_HAS_SMART_POWER_DOWN
>  				  | FLAG_HAS_AMT
>  				  | FLAG_HAS_CTRLEXT_ON_LOAD,
> -	.flags2			  = FLAG2_CHECK_PHY_HANG
> +	.flags2			= FLAG2_CHECK_PHY_HANG
>  				  | FLAG2_DISABLE_ASPM_L0S
> +				  | FLAG2_DISABLE_ASPM_L1
>  				  | FLAG2_NO_DISABLE_RX,
>  	.pba			= 32,
>  	.max_hw_frame_size	= DEFAULT_JUMBO,

Now that this patch is in master (d4a4206e) and has presumably been
widely tested, what's the possibility of it making it into stable? I
really should have included a CC to stable when I sent it...

This patch should probably also be accompanied with 59aed952 (e1000e:
Remove special case for 82573/82574 ASPM L1 disablement) on top, to
remove a special case that's no longer required once this is applied.

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net

