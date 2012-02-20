Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2BTTka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:40:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:17612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2BTTk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:40:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110154738"
Date: Mon, 20 Feb 2012 20:47:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] MFD: twl6040: Conversion to i2c driver
Message-ID: <20120220194736.GN5387@sortiz-mobl>
References: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Feb 10, 2012 at 12:00:15PM +0200, Peter Ujfalusi wrote:
> Hello,
> 
> Changes since v2:
> - soc/codec/Kconfig: make twl6040 depend on I2C
> - Regulator related patches has been removed (to be sent as separate series)
I applied all 3 patches. Patch #2 did not apply cleanly, due to the fact that
several struct twl4030_codec_data omap4panda.c references are not upstream
yet. This is my .rej:

--- arch/arm/mach-omap2/board-omap4panda.c
+++ arch/arm/mach-omap2/board-omap4panda.c
@@ -278,7 +279,7 @@
 	return 0;
 }
 
-static struct twl4030_codec_data twl6040_codec = {
+static struct twl6040_codec_data twl6040_codec = {
 	/* single-step ramp for headset and handsfree */
 	.hs_left_step	= 0x0f,
 	.hs_right_step	= 0x0f,
@@ -286,17 +287,14 @@
 	.hf_right_step	= 0x1d,
 };
 
-static struct twl4030_audio_data twl6040_audio = {
+static struct twl6040_platform_data twl6040_data = {
 	.codec		= &twl6040_codec,
 	.audpwron_gpio	= 127,
-	.naudint_irq	= OMAP44XX_IRQ_SYS_2N,
 	.irq_base	= TWL6040_CODEC_IRQ_BASE,
 };
 
 /* Panda board uses the common PMIC configuration */
-static struct twl4030_platform_data omap4_panda_twldata = {
-	.audio		= &twl6040_audio,
-};
+static struct twl4030_platform_data omap4_panda_twldata;

I'm not sure hwo we could handle that properly. Either by letting Tony
carrying this patchset, or by sending me the panda patch that adds those
structures. As you prefer.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
