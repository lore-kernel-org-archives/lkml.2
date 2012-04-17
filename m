Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2DQO7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:59:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37218 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2DQO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:59:31 -0400
Date: Tue, 17 Apr 2012 15:59:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add Wolfson Microelectronics WM8766 codec ALSA
 driver
Message-ID: <20120417145929.GA22575@sirena.org.uk>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <1334611118-10301-3-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334611118-10301-3-git-send-email-linux@rainbow-software.org>
X-Cookie: The savior becomes the victim.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:18:36PM +0200, Ondrej Zary wrote:
> Needed by Philips PSC724 subdriver. The code does not contain any
> card-specific bits so it can be used by any other ALSA driver.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Please CC me (and ideally all of patches@opensource.wolfsonmicro.com)
on any drivers for Wolfson devices.  It's not like we're secretive!

> ---
>  include/sound/wm8766.h   |  160 ++++++++++++++++++++
>  sound/i2c/other/Makefile |    3 +-
>  sound/i2c/other/wm8766.c |  374 ++++++++++++++++++++++++++++++++++++++++++++++

No, this should be supported in ASoC - anything adding new code in
sound/i2c is *deeply* suspicious.

> +struct snd_wm8766_ops {
> +	void (*write)(struct snd_wm8766 *wm, u16 addr, u16 data);
> +};

You should in general use regmap rather than open coding register I/O
for I2C devices.

> +void snd_wm8766_init(struct snd_wm8766 *wm);
> +void snd_wm8766_set_if(struct snd_wm8766 *wm, u16 dac);
> +void snd_wm8766_set_master_mode(struct snd_wm8766 *wm, u16 mode);
> +void snd_wm8766_set_power(struct snd_wm8766 *wm, u16 power);
> +void snd_wm8766_volume_restore(struct snd_wm8766 *wm);
> +int snd_wm8766_build_controls(struct snd_wm8766 *wm);

I've not yet looked at the rest of the code but this looks awfully like
you've just invented a minimal version of the ASoC interfaces...
