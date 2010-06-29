Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0F2G6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:58:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58398 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0F2G6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:58:45 -0400
Date: Tue, 29 Jun 2010 08:58:17 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>, Baruch Siach <baruch@tkos.co.il>,
       Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kbuild@vger.kernel.org
Subject: Re: Subject: [PATCH] arm: fix KConfig warning for mach-mx25
Message-ID: <20100629065817.GA23160@pengutronix.de>
References: <201006290005.20875.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006290005.20875.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiho,

[added linux-kbuild@vger.kernel.org to Cc:]

On Tue, Jun 29, 2010 at 12:05:20AM +0200, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de
> 
> This patch fixes a KConfig warning:
> "arch/arm/mach-mx25/Kconfig:18:warning: choice value used outside its
> choice group"
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
The problem also goes away when renaming one of the two
MACH_EUKREA_MBIMXSD_BASEBOARD (the other MACH_EUKREA_MBIMXSD_BASEBOARD
is in arch/arm/mach-mx3/Kconfig).  AFAIK Eric already sent a patch to
fix this.  I think this is the real issue, I don't know why the warning
goes away with your patch.

Nevertheless I like your patch.  And note there are two other variables
in arch/arm/mach-mx2 that could benefit from the same "fix".  (But as I
moved this file in my tree I suggest to wait until my changes hit Linus'
tree and then fix arch/arm/mach-imx/Kconfig.)

Best regards
Uwe

> ---
> KernelVersion: linux-next-20100628
>  arch/arm/mach-mx25/Kconfig |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-mx25/Kconfig b/arch/arm/mach-mx25/Kconfig
> index 3a6668e..2f436ed 100644
> --- a/arch/arm/mach-mx25/Kconfig
> +++ b/arch/arm/mach-mx25/Kconfig
> @@ -15,8 +15,7 @@ choice
>  	default MACH_EUKREA_MBIMXSD_BASEBOARD
>  
>  config MACH_EUKREA_MBIMXSD_BASEBOARD
> -	prompt "Eukrea MBIMXSD development board"
> -	bool
> +	bool "Eukrea MBIMXSD development board"
>  	help
>  	  This adds board specific devices that can be found on Eukrea's
>  	  MBIMXSD evaluation board.
> -- 
> 1.7.1

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
