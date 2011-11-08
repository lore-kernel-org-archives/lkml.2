Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1KHOi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:38:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56479 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755860Ab1KHOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:38:21 -0500
Date: Tue, 8 Nov 2011 14:38:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Takashi Iwai <tiwai@suse.de>, perex@perex.cz, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
Message-ID: <20111108143818.GA5632@opensource.wolfsonmicro.com>
References: <70D251FDDC55405882A8447CC455D56E@hacdom.okisemi.com>
 <8486F61FC3B94B908BFE654234DD6C97@hacdom.okisemi.com>
 <4E9BAEF7.1080406@dsn.lapis-semi.com>
 <s5h7h3ysa4l.wl%tiwai@suse.de>
 <4EA5563A.10703@dsn.lapis-semi.com>
 <20111024122015.GA26033@opensource.wolfsonmicro.com>
 <4EB8F079.9080703@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB8F079.9080703@dsn.lapis-semi.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:03:53PM +0900, Tomoya MORINAGA wrote:

So, I started looking at this but...

> struct snd_ml7213i2s_pcm {
> 	enum snd_soc_control_type control_type;
> 	struct snd_ml7213i2s *ml7213i2s;
> 	spinlock_t lock;
> 	unsigned int irq_pos;
> 	unsigned int buf_pos;
> 	struct snd_pcm_substream *substream;
> 	struct cbdata cbd;              /* i2s callback info */
> 	unsigned int channels;
> 	unsigned int rw;
> 	unsigned int rate;
> 	unsigned int ch;
> 	unsigned int setup_flag;
> 	unsigned int format;
> 	unsigned int bclkfs;
> 	struct mutex i2c_mutex;
> };

...this looks *really* confused, there's things in here which are a mix
of DMA controller and CODEC driver things.  The CODEC and DMA drivers
shouldn't know anything about each other, let alone be referencing the
same data structure.

> /*
>  * wm8731 register cache
>  * We can't read the WM8731 register space when we are
>  * using 2 wire for device control, so we cache them instead.
>  * There is no point in caching the reset register
>  */
> static const u16 wm8731_reg[WM8731_CACHEREGNUM] = {
> 	0x0097, 0x0097, 0x0079, 0x0079,
> 	0x000a, 0x0008, 0x009f, 0x000a,
> 	0x0000, 0x0000
> };

This is is just obviously wrong for this driver.  I stopped reading the
code at this point.
