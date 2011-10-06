Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab1JFNWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:22:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44958 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964826Ab1JFNWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:22:13 -0400
Date: Thu, 6 Oct 2011 14:22:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 01/10] ASoC: wm8510: Convert to snd_soc_cache_sync
Message-ID: <20111006132211.GB16404@opensource.wolfsonmicro.com>
References: <1317881417.13399.1.camel@phoenix>
 <1317881503.13399.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317881503.13399.3.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 02:11:43PM +0800, Axel Lin wrote:

> +static int wm8510_volatile_register(struct snd_soc_codec *codec,
> +				    unsigned int reg)
> +{
> +	switch (reg) {
> +	case WM8510_RESET:
> +		return 1;
> +	default:
> +		return 0;
> +	}
> +}
> +

This is wrong in quite a few of the patches - all the 7, 9 CODECs are
write only, there's no readback support at all (in general if the driver
isn't actully verifying a device ID or otherwise doing a physical read
then it probably doesn't support readback).
