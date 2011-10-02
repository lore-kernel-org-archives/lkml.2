Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1JBUrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:47:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab1JBUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:47:32 -0400
Date: Sun, 2 Oct 2011 21:47:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: Re: [PATCH 5/6] ASoC: samsung: fix Kconfig dependencies
Message-ID: <20111002204729.GC5811@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317587284-2776-6-git-send-email-arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 10:28:03PM +0200, Arnd Bergmann wrote:

>  config SND_SAMSUNG_AC97
>  	tristate
> +	depends on SND_SOC_ALL_CODECS=n || SND_SOC_ALL_CODECS
>  	select SND_SOC_AC97_BUS

No, I'm not sure what the problem you're trying to fix here but this
looks pretty terrible.  SND_SOC_ALL_CODECS is a debugging tool for build
coverage, we shouldn't be restricting actual useful drivers based on it.
What is the intention of this change and why does it only apply to the
Samsung platform?  It all looks very magic.

>  config SND_SOC_SAMSUNG_SMDK_WM8994
>  	tristate "SoC I2S Audio support for WM8994 on SMDK"
>  	depends on SND_SOC_SAMSUNG && (MACH_SMDKV310 || MACH_SMDKC210)
> +	depends on MFD_WM8994
>  	select SND_SOC_WM8994

This is non-idiomatic - we always select the CODEC drivers rather than
depending on them for usability.

Please also split the two changes you're doing here into separate
patches.  I might've applied the wm8994 bit but it's squashed in with
the AC'97 change...
