Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab1FUFZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 01:25:00 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52015 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab1FUFY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 01:24:59 -0400
Subject: Re: [PATCH 2/2] video: omap2: Compile omap2 support only when
 needed
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
In-Reply-To: <4E0022B5.9000500@linaro.org>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
	 <1308566761-2850-3-git-send-email-tushar.behera@linaro.org>
	 <1308575201.2076.57.camel@deskari>  <4E0022B5.9000500@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 08:24:53 +0300
Message-ID: <1308633893.1850.11.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 10:18 +0530, Tushar Behera wrote:
> Hi,
> 
> On Monday 20 June 2011 06:36 PM, Tomi Valkeinen wrote:
> > On Mon, 2011-06-20 at 16:16 +0530, Tushar Behera wrote:
> >> Currently display support for omap2 is selected by default and
> >> it gets built for all the configurations.
> >>
> >> Instead of it being a built-in feature, it's compilation should
> >> depend on the config option CONFIG_FB_OMAP2.
> >
> > No, I don't think so. omap2 directory contains vram, vrfb and omapdss,
> > all of which can be used without omapfb driver. vram and vrfb can be
> > even used without omapdss driver.
> Even if I build the kernel with i386_defconfig, I get some compiled 
> files within drivers/video/omap2.
> 
> $ make ARCH=x86 i386_defconfig O=out_dir
> $ make ARCH=x86 O=out_dir
> 
> $ ls out_dir/drivers/video/omap2
> built-in.o  displays  modules.builtin  modules.order
> 
> IMHO, drivers/video/omap2/ should not be compiled if the kernel is not 
> built for omap2.

Ok. Yes, that's a known "problem". We could have a OMAPx check there,
but then again, the driver is a driver for the DSS HW, which could, at
least in theory, used in other SoCs.

I don't think any driver should normally depend on ARCH_something or
MACH_something.

I think this is more of a "problem" with the build system. The same
thing can be seen with, for example, drivers/video/backlight/ and
drivers/video/display/ directories. In practice the created files do not
affect the kernel in any way, as far as I see.

 Tomi


