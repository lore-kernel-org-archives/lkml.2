Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2BGNj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:39:28 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:35137 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab2BGNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:39:27 -0500
Message-ID: <4F31298C.5090008@ti.com>
Date: Tue, 07 Feb 2012 15:39:24 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120106 Thunderbird/9.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/7] MFD: twl6040: Convert to i2c driver, and separate
 it from twl core
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com> <1328619678-26080-3-git-send-email-peter.ujfalusi@ti.com> <20120207132925.GN3332@opensource.wolfsonmicro.com>
In-Reply-To: <20120207132925.GN3332@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 03:29 PM, Mark Brown wrote:
> and it looks like you'll save a bunch more code if you're able to
> convert over to using a regmap cache.  Note that as a first pass you
> just need to define which registers are volatile and enable a cache type
> - if defaults are omitted then the values will be read back from the
> device to start off with.

There's one thing which I need to sort out before I enable the regmap
cache for the twl6040 MFD (and remove all other caching of vibra
controls in the MFD, and from the ASoC codec driver):
In the codec driver I have one 'shadow' register which does not exist on
the HW. I'm going to need to have access to that shadow register's bits
in the future transparently.
I was wondering if we could add support to regmap for such SW only
registers. This would only make sens if the cache is enabled. We could
have a callback let's say shadow_reg() in remap_config struct. If it is
a shadow reg we never reach out for the HW and operate only on the cache.
Is this something we can add to regmap?

-- 
Péter
