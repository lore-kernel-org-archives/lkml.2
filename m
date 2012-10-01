Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2JASUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:20:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2JASUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:20:53 -0400
Date: Mon, 1 Oct 2012 15:20:46 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Igor Grinberg <grinberg@compulab.co.il>,
        Paul Walmsley <paul@pwsan.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [ 045/218] ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER
Message-ID: <20121001182046.GB3198@herton-Z68MA-D2H-B3>
References: <20120928201501.208384923@linuxfoundation.org>
 <20120928201506.626237283@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928201506.626237283@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:14:22PM -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Igor Grinberg <grinberg@compulab.co.il>
> 
> commit 45caae74d238ef6583e9402cb8c550cc0b0f7dbd upstream.
> 
> Currently, omap2_sync32k_clocksource_init() function initializes the 32K
> timer as the system clock source regardless of the CONFIG_OMAP_32K_TIMER
> setting.
> Fix this by providing a default implementation for
> !CONFIG_OMAP_32K_TIMER case.
> 
> Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
> Reviewed-by: Paul Walmsley <paul@pwsan.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/arm/mach-omap2/timer.c |    7 +++++++
>  1 file changed, 7 insertions(+)

Build failure with this patch:

linux/arch/arm/mach-omap2/timer.c:308:2: error: #else after #else
linux/arch/arm/mach-omap2/timer.c:238:0: error: the conditional began here
linux/arch/arm/mach-omap2/timer.c:326:21: error: expected declaration specifiers or '...' before numeric constant
linux/arch/arm/mach-omap2/timer.c:326:24: error: expected declaration specifiers or '...' before numeric constant
linux/arch/arm/mach-omap2/timer.c:326:27: error: expected declaration specifiers or '...' before string constant
linux/arch/arm/mach-omap2/timer.c:326:47: error: expected declaration specifiers or '...' before numeric constant
linux/arch/arm/mach-omap2/timer.c:326:50: error: expected declaration specifiers or '...' before string constant
linux/arch/arm/mach-omap2/timer.c:328:21: error: invalid suffix "_secure" on integer constant
linux/arch/arm/mach-omap2/timer.c:328:21: error: expected declaration specifiers or '...' before numeric constant
linux/arch/arm/mach-omap2/timer.c:328:31: error: expected declaration specifiers or '...' before numeric constant
linux/arch/arm/mach-omap2/timer.c:328:51: error: expected declaration specifiers or '...' before string constant
linux/arch/arm/mach-omap2/timer.c:329:4: error: expected declaration specifiers or '...' before numeric constant
linux/arch/arm/mach-omap2/timer.c:329:7: error: expected declaration specifiers or '...' before string constant

-- 
[]'s
Herton
