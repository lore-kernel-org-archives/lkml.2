Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2LSLAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:00:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52979 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2LSLAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:00:40 -0500
Message-ID: <50D19E52.9030003@ti.com>
Date: Wed, 19 Dec 2012 12:00:34 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
References: <1352968293.10872.51.camel@cumari.coelho.fi>  <20121218095450.GB27751@arwen.pp.htv.fi>  <20121219094552.GN4985@opensource.wolfsonmicro.com>  <50D19040.5090404@ti.com>  <20121219100909.GO4985@opensource.wolfsonmicro.com>  <50D19463.5010605@ti.com>  <20121219103206.GQ4985@opensource.wolfsonmicro.com> <1355913954.5273.21.camel@cumari.coelho.fi> <50D19D54.2000307@ti.com>
In-Reply-To: <50D19D54.2000307@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 11:56 AM, Peter Ujfalusi wrote:
> BTW: have you happened to ubdate u-boot recently? There is a nice easter egg
> added there:
> f3f98bb ARM: OMAP4/5: Do not configure non essential pads, clocks, dplls.
> 
> Which means that _essential_ clocks and pads are no longer configured.

Meanwhile you can try to hack the u-boot to enable the 32k from there. It is
going to stay up since we do not have code to control it in the kernel anymore.

Also do something like this at the same time to get things working:
diff --git a/include/configs/omap4_common.h b/include/configs/omap4_common.h
index cbc9bdb..b0ff1ec 100644
--- a/include/configs/omap4_common.h
+++ b/include/configs/omap4_common.h
@@ -271,4 +271,8 @@

 #define CONFIG_SYS_THUMB_BUILD

+/* Configure all pins and clocks */
+#define CONFIG_SYS_ENABLE_PADS_ALL
+#define CONFIG_SYS_CLOCKS_ENABLE_ALL
+
 #endif /* __CONFIG_OMAP4_COMMON_H */

-- 
Péter
