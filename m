Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0LFOFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:05:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46568 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0LFOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:05:22 -0500
Date: Mon, 6 Dec 2010 14:05:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: ecard: Fix compilation warning.
Message-ID: <20101206140506.GE31777@n2100.arm.linux.org.uk>
References: <1291644243-23540-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291644243-23540-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 03:04:03PM +0100, Marek Belisko wrote:
> Fix following compilation warning:
> arch/arm/kernel/ecard.c:1066: warning: ignoring return value of
> 'device_register', declared with attribute warn_unused_result
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  arch/arm/kernel/ecard.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
> index eed2f79..da882b1 100644
> --- a/arch/arm/kernel/ecard.c
> +++ b/arch/arm/kernel/ecard.c
> @@ -1063,8 +1063,10 @@ ecard_probe(int slot, card_type_t type)
>  	*ecp = ec;
>  	slot_to_expcard[slot] = ec;
>  
> -	device_register(&ec->dev);
> -
> +	rc = device_register(&ec->dev);
> +	if (rc)
> +		goto nodev;
> +
>  	return 0;

No.  It is important that cards which are actually there remain present
even if device_register fails.  In other words, we _really_ don't care
what device_register() returns.
