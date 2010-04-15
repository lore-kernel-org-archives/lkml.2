Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0DOF5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:57:23 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:41864 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047Ab0DOF5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:57:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANdGxktbstG6/2dsb2JhbACbYHK+OQ2FAQQ
Date: Thu, 15 Apr 2010 07:57:15 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
Cc: Wim Van Sebroeck <wim@iguana.be>, Chris Friesen <cfriesen@nortel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixed book E watchdog period register mask.
Message-ID: <20100415055715.GD15728@infomag.iguana.be>
References: <u2l7dc909981004142059p9a453a0gf761e496a65a77d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2l7dc909981004142059p9a453a0gf761e496a65a77d3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luuk,

will add this one today or tomorrow, when I finished translating an audit report.

Kind regards,
Wim.

> A previous fix changed the WDTP function to use the period directly,
> rather than subtracting from 63.  However the mask generation was
> not changed, so the mask was coming out as 0.  This patch fixes it.
> 
> Signed-off-by: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
> ---
>  drivers/watchdog/booke_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
> index 8b724aa..500d383 100644
> --- a/drivers/watchdog/booke_wdt.c
> +++ b/drivers/watchdog/booke_wdt.c
> @@ -44,7 +44,7 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
> 
>  #ifdef	CONFIG_FSL_BOOKE
>  #define WDTP(x)		((((x)&0x3)<<30)|(((x)&0x3c)<<15))
> -#define WDTP_MASK	(WDTP(0))
> +#define WDTP_MASK	(WDTP(0x3f))
>  #else
>  #define WDTP(x)		(TCR_WP(x))
>  #define WDTP_MASK	(TCR_WP_MASK)
> -- 
> 1.6.3.4
