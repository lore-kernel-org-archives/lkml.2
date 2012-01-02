Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2ABHef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:34:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52561 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2ABHee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:34:34 -0500
Date: Mon, 2 Jan 2012 00:34:30 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: Re: [RFC][PATCH 0/4] lcd: platform-lcd: Add lcd panel and device
 tree support
Message-ID: <20120102073430.GH13015@ponder.secretlab.ca>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 11:24:31AM +0530, Thomas Abraham wrote:
> The platform-lcd driver depends on platform-specific callbacks to setup the
> lcd panel. These callbacks are supplied using driver's platform data. But
> for adding device tree support for platform-lcd driver, providing such
> callbacks is not possible (without using auxdata).
> 
> Since the callbacks are usually lcd panel specific, it is possible to include
> the lcd panel specific setup and control functionality in the platform-lcd
> driver itself, thereby eliminating the need for supplying platform specific
> callbacks to the driver. The platform-lcd driver can include support for
> multiple lcd panels.
> 
> This patchset removes the need for platform data for platform-lcd driver and
> adds support which can be used to implement lcd panel specific functionality
> in the driver. As an example, the support for Hydis hv070wsa lcd panel is added
> to the platform-lcd driver which is then used on the Exynos4 based Origen board.
> This currently breaks build for other users of platform-lcd driver. Those can be
> fixed if this approach is acceptable.

Approach looks okay to me.  I've not looked too deeply though.

g.

> 
> Thomas Abraham (4):
>   lcd: platform-lcd: Eliminate need for platform data
>   lcd: platform-lcd: Add support for Hydis hv070wsa lcd panel
>   ARM: Exynos: Remove platform data of platform-lcd driver
>   lcd: platform-lcd: Add device tree support
> 
>  arch/arm/mach-exynos/mach-origen.c     |   25 +-----
>  drivers/video/backlight/Kconfig        |    6 ++
>  drivers/video/backlight/platform_lcd.c |  128 ++++++++++++++++++++++++++++---
>  include/video/platform_lcd.h           |   11 +--
>  4 files changed, 129 insertions(+), 41 deletions(-)
> 
