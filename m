Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab1HWJKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:10:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50751 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab1HWJKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <201108212242.12717.linux@rainbow-software.org>
References: <201108212242.12717.linux@rainbow-software.org>
Date: Tue, 23 Aug 2011 10:10:00 +0100
Message-ID: <CAPM=9tzF7C_gW44csqYwK+wdT9mwWBrA3O_9JQNfg=6aip4kag@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Resurrect Intel740 driver: i740fb
From: Dave Airlie <airlied@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 9:42 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Hello,
> this is an v2 attempt to resurrect an old (like 2.4.19) out-of-tree driver for
> Intel740 graphics cards and modify it for recent kernels. The old driver is
> located at: http://sourceforge.net/projects/i740fbdev/files/
>
> It was easier to create a new driver based on skeletonfb, using most of the
> low level HW code from the old driver. The DDC code is completely new.
>
> The driver was tested on two 8MB cards: ManLi and Diamond Stealth II G460
>
> The i740_calc_fifo() function formatting is nice but does not pass
> checkpatch. Making it checkpatch-compliant makes the code look ugly. How to
> make it both nice and compatible with Linux coding style?
> (the remaining // comments mark things that need attention - missing xpan
> and suspend/resume)
>
> Changes in v2:
> - fixed 15bpp (16bpp 555) mode
> - not working 1280x1024-32 is not a bug but card's feature, it's now handled
>  correctly by the driver
> - 24bpp modes still don't work in fbtest but it looks like fbtest bug!
>
> Is there any better way to test fb drivers than fbtest?
>
> no signed-off-by yet
>
> --- linux-2.6.39-rc2-orig/drivers/video/Kconfig 2011-04-06 03:30:43.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/video/Kconfig      2011-07-30 11:34:10.000000000 +0200
> @@ -1117,6 +1117,17 @@ config FB_RIVA_BACKLIGHT
>        help
>          Say Y here if you want to control the backlight of your display.
>
> +config FB_I740
> +       tristate "Intel740 support (EXPERIMENTAL)"
> +       depends on EXPERIMENTAL && FB && PCI && X86_32 && AGP_INTEL
> +       select FB_MODE_HELPERS
> +       select FB_CFB_FILLRECT
> +       select FB_CFB_COPYAREA
> +       select FB_CFB_IMAGEBLIT
> +       select VGASTATE
> +       help
> +         This driver supports graphics cards based on Intel740 chip.
> +

It shouldn't need AGP_INTEL, as its an AGP card not an integrated
chipset, it might need just AGP.

Dave.
