Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2CVIfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:35:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53713 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab2CVIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:35:11 -0400
Date: Thu, 22 Mar 2012 16:34:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mxs: enforce semantics of
 clk_prepare()/clk_unprepare() and clk_enable()/clk_disable()
Message-ID: <20120322083457.GE2213@S2101-09.ap.freescale.net>
References: <1332404298-18891-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
In-Reply-To: <1332404298-18891-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 09:18:17AM +0100, Lothar Waﬂmann wrote:
> After introducing clk_prepare()/clk_unprepare() there may still be
> drivers out there that don't use the new functions.
> This patch warns about drivers calling clk_enable() without a
> preceding clk_prepare() and various other invalid sequences of calls
> to clk_enable()/clk_disable() and clk_prepare()/clk_unprepare().
> 

I plan to migrate the mxs clock driver to common clk framework in the
next merge window.  Thus, I do not see much point to take this patch.

> To not make a system unusable due to excessive warning messages the
> warnings are limited to 1 per clk by a flag in the 'flags' member of
> struct clk.
> 
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  arch/arm/mach-mxs/clock.c              |   98 ++++++++++++++++++++++++++++----
>  arch/arm/mach-mxs/include/mach/clock.h |    6 ++
>  2 files changed, 93 insertions(+), 11 deletions(-)

-- 
Regards,
Shawn
