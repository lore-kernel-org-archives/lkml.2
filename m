Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2COG3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:29:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42881 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2COG3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F60D804.30804@metafoo.de>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<20120229235147.GM8295@opensource.wolfsonmicro.com>
	<CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
	<20120302125819.GE3230@opensource.wolfsonmicro.com>
	<CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
	<20120306100012.GC19635@opensource.wolfsonmicro.com>
	<CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
	<20120306121222.GK19635@opensource.wolfsonmicro.com>
	<CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
	<20120307114811.GF3107@opensource.wolfsonmicro.com>
	<CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
	<4F60D804.30804@metafoo.de>
Date: Thu, 15 Mar 2012 15:29:31 +0900
Message-ID: <CANKRQnjhe2F-1OeQvcXZQEckOtkFnHD-8BoADQ6nN=x1xTZSWg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, qi.wang@intel.com,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Liam Girdwood <lrg@ti.com>, joel.clark@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 2:40 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> If this is for all registers, how does stuff like DAPM work, which uses the
> framework internal update_bits function?
>
> If it's the case that the write address is always read address + 1 you can
> still use the framework if you set write_flag_mask to 0x01 in your regmap
> config. In my opinion it even makes sense to shift all the register numbers
> to the left by one and use a 7/9 instead of a 8/8 addr/reg layout. This will
> reduce the amount of memory wasted due to holes in the register cache.

Thank you for your information.
I've just been investigating these.
I also found ASoC core access i2c driver via snd_soc_update_bits or others.
As a result, write register address is the same as read's.

I'll try to implement these.

BTW, currently, by settting ML26124 codec with fixed value,
I've confirmed both playback and capture work well.

thanks
-- 
ROHM Co., Ltd.
tomoya
