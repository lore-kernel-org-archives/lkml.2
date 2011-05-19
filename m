Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1ESLMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:12:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34105 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1ESLL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:11:58 -0400
Message-ID: <4DD4FAE6.3060008@ti.com>
Date: Thu, 19 May 2011 12:11:34 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH v3 0/3] ASoC: add support for audio on iPaq
 hx4700
References: <1305732311-17639-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1305732311-17639-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/11 16:25, Dmitry Artamonow wrote:
> Ok, here's another version of patches adding audio support for good ole
> iPAQ hx4700. It took a bit faster to make v3 than I expected, so here is it.
> 
> Previous versions can be found here:
> https://lkml.org/lkml/2010/11/20/50 (v1)
> https://lkml.org/lkml/2011/5/16/462 (v2)
> 
> This patchset is based on 'for-next' branch of Mark's ASoC git tree
> (fetched today), also applies cleanly on linux-next-20110518.
> Lightly tested on real hardware - playback/recording/mixer seem to work
> without any glitches.
> 
> Changes v2 -> v3
> 
> * data based init is now used in codec and machine audio driver
>   for DAPM and controls
> * machine audio driver now is a proper platform driver, instantiating
>   sound card with snd_soc_register_card()
> * platform code registers corresponding platform_device for machine audio driver
> * ak4641_sync() is dropped in favour of snd_soc_cache_sync()
> * snd_soc_update_bits() is used instead of snd_soc_read()/update/snd_soc_write()
>   sequences. Also return value of snd_soc_update_bits is propagated further
>   for catching errors (previously result of snd_soc_write wasn't checked)
> * gpio_request_array is used now in machine audio driver
> * some other minor cleanup in the couple of places
> 
> Dmitry Artamonow (3):
>   ASoC: Asahi Kasei AK4641 codec driver
>   ASoC: add iPAQ hx4700 machine driver
>   pxa/hx4700: add platform device and I2C info for AK4641 codec
> 
>  arch/arm/mach-pxa/hx4700.c              |   25 ++
>  arch/arm/mach-pxa/include/mach/hx4700.h |    4 +-
>  include/sound/ak4641.h                  |   26 ++
>  sound/soc/codecs/Kconfig                |    4 +
>  sound/soc/codecs/Makefile               |    2 +
>  sound/soc/codecs/ak4641.c               |  664 +++++++++++++++++++++++++++++++
>  sound/soc/codecs/ak4641.h               |   47 +++
>  sound/soc/pxa/Kconfig                   |    9 +
>  sound/soc/pxa/Makefile                  |    2 +
>  sound/soc/pxa/hx4700.c                  |  255 ++++++++++++
>  10 files changed, 1036 insertions(+), 2 deletions(-)
>  create mode 100644 include/sound/ak4641.h
>  create mode 100644 sound/soc/codecs/ak4641.c
>  create mode 100644 sound/soc/codecs/ak4641.h
>  create mode 100644 sound/soc/pxa/hx4700.c
> 

All

Acked-by: Liam Girdwood <lrg@ti.com>
