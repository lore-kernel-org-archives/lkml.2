Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2KWAmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:42:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48582 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2KWAmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:42:05 -0500
Date: Thu, 22 Nov 2012 16:38:52 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH resend 0/10] Get rid of FIQ_START/enable/disable_fiq() + some
 FIQ cleanups
Message-ID: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew, Russell,

These are small cleanups that I keep resending since Aug. Andrew, can you
please take them for the time being?

The rationale is the same:

During KDB FIQ patches review Russell mentioned that I should not
introduce another FIQ_START. It seems that in v3.6-rc the FIQ_START issue
was somewhat band-aided, i.e. machines don't necessary need to define this
stuff any longer, but I also read the background of the issue, and Russell
once said that he don't want the FIQ subsystem to mess with genirq.

So, the patch set is pretty straightforward:

- Get rid of FIQ_START. Nobody but platform-specific code (and
  platform-specific drivers) should know the details about which interrupt
  can be routed to FIQ and which cannot;

- Remove disable/enable_fiq() calls from the FIQ subsys.

Thanks!

--
 arch/arm/include/asm/fiq.h                    |  2 -
 arch/arm/include/asm/mach/irq.h               |  7 +++-
 arch/arm/kernel/fiq.c                         | 37 +++++--------------
 arch/arm/kernel/irq.c                         |  2 -
 arch/arm/mach-omap1/include/mach/irqs.h       |  4 --
 arch/arm/mach-rpc/dma.c                       |  4 +-
 arch/arm/mach-rpc/include/mach/irqs.h         |  8 ++--
 arch/arm/mach-rpc/irq.c                       | 21 ++---------
 arch/arm/mach-s3c24xx/include/mach/irqs.h     |  3 --
 arch/arm/plat-mxc/avic.c                      |  5 ---
 arch/arm/plat-mxc/include/mach/irqs.h         |  2 -
 arch/arm/plat-mxc/tzic.c                      |  5 ---
 arch/arm/plat-s3c24xx/irq.c                   |  6 +--
 .../media/platform/soc_camera/mx1_camera.c    |  6 +--
 sound/soc/fsl/imx-pcm-fiq.c                   |  4 +-
 15 files changed, 31 insertions(+), 85 deletions(-)
