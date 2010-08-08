Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0HHVuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 17:50:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:13777 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab0HHVuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 17:50:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,338,1278313200"; 
   d="scan'208";a="594119440"
Date: Sun, 8 Aug 2010 23:50:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Subject: Re: [PATCH 1/2] mfd: menelaus: Fix mmc slot 2 misconfiguration
Message-ID: <20100808215016.GA3480@sortiz-mobl>
References: <1281287124-26693-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281287124-26693-1-git-send-email-jhnikula@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarkko,

On Sun, Aug 08, 2010 at 08:05:23PM +0300, Jarkko Nikula wrote:
> We are modifying register value instead of return value.
Patch applied, kiitos.


> This fix is originally done by Carlos Eduardo Aguiar. Original fix is
> commit bb4e91722e29efe31587d2cc664b6def645aecd9 in
> git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
> 
> Author modified the fix for mainline version of menelaus.
> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> ---
> Tested on N810. Integrated eMMC on N810 started to work with this patch.
> ---
>  drivers/mfd/menelaus.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index a3fb4bc..e02b574 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -356,9 +356,9 @@ int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
>  		int b;
>  
>  		if (enable)
> -			ret |= 1 << 1;
> +			val |= 1 << 1;
>  		else
> -			ret &= ~(1 << 1);
> +			val &= ~(1 << 1);
>  		b = menelaus_read_reg(MENELAUS_MCT_CTRL2);
>  		b &= ~0x03;
>  		b |= power;
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
