Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1JLPEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:04:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056Ab1JLPEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:04:11 -0400
Date: Wed, 12 Oct 2011 16:04:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg@ti.com, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        kuninori.morimoto.gx@renesas.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 7/9] ASoC: da7210: Add support for ALC and
 Noise suppression
Message-ID: <20111012150404.GT3647@opensource.wolfsonmicro.com>
References: <1318432070.12107.426.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318432070.12107.426.camel@matrix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:37:50PM +0530, Ashish Chavan wrote:

> +	if (ucontrol->value.integer.value[0]) {
> +		/* Check if noise suppression is enabled */
> +		if (reg_cache[DA7210_CONTROL] & DA7210_NOISE_SUP_EN) {

No, don't go peering directly into the register cache.  This is going to
explode if the board configures a different cache style and means you
can't change the cache type later.  Just read the register and trust
that the cache will do something sane.

> +			dev_dbg(codec->dev, "Failed to enable ALC\n");
> +			return -EPERM;
> +		}

Either drop the debug print or make it say what the problem is.

similar problems in the rest of the patch.

> +	SOC_SINGLE("ALC Capture Max Gain", DA7210_ALC_MAX, 0, 0x3F, 0),
> +	SOC_SINGLE("ALC Capture Min Gain", DA7210_ALC_MIN, 0, 0x3F, 0),
> +	SOC_SINGLE("ALC Capture Noise Gain", DA7210_ALC_NOIS, 0, 0x3F, 0),

Volume.
