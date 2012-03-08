Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2CHMPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:15:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51040 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2CHMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:15:08 -0500
Date: Thu, 8 Mar 2012 20:14:55 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Huang Shijie <b32955@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] drivers: base: add support for stmp-style devices
Message-ID: <20120308121452.GA2499@S2101-09.ap.freescale.net>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
 <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 11:28:32PM +0100, Wolfram Sang wrote:
> MX23/28 use IP cores which follow a register layout I have first seen on
> STMP3xxx SoCs. In this layout, every register actually has four u32:
> 
>  1.) to store a value directly
>  2.) a SET register where every 1-bit sets the corresponding bit,
>      others are unaffected
>  3.) same with a CLR register
>  4.) same with a TOG (toggle) register
> 
> Also, the 2 MSBs in register 0 are always the same and can be used to reset
> the IP core.
> 
> All this is strictly speaking not mach-specific (but IP core specific) and,
> thus, doesn't need to be in mach-mxs/include. At least mx6 also uses IP cores
> following this stmp-style. So:
> 
> Introduce a stmp-style device, put the code and defines for that in a public
> place (drivers/base/), and let drivers for stmp-style devices select that code.
> To avoid regressions and ease reviewing, the actual code is simply copied from
> mach-mxs. It definately wants updates, but those need a seperate patch series.
> 
> Voila, mach dependency gone, reusable code introduced. Note that I didn't
> remove the duplicated code from mach-mxs yet, first the drivers have to be
> converted.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
