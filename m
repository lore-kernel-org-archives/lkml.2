Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231Ab2CNRiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:38:19 -0400
Received: from smtp-out-225.synserver.de ([212.40.185.225]:1177 "EHLO
	smtp-out-225.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123Ab2CNRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:38:17 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8975
Message-ID: <4F60D804.30804@metafoo.de>
Date: Wed, 14 Mar 2012 18:40:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, qi.wang@intel.com,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Liam Girdwood <lrg@ti.com>, joel.clark@intel.com
Subject: Re: [alsa-devel] [PATCH v6] sound/soc/codecs: add LAPIS	Semiconductor
 ML26124
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>	<20120229235147.GM8295@opensource.wolfsonmicro.com>	<CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>	<20120302125819.GE3230@opensource.wolfsonmicro.com>	<CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>	<20120306100012.GC19635@opensource.wolfsonmicro.com>	<CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>	<20120306121222.GK19635@opensource.wolfsonmicro.com>	<CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>	<20120307114811.GF3107@opensource.wolfsonmicro.com> <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
In-Reply-To: <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 03:24 AM, Tomoya MORINAGA wrote:
> On Wed, Mar 7, 2012 at 8:48 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>>> If possible, I want to use framework features. However, I judged it is
>>> not possible.
>>> Let me confirm again.
>>> As I said before, all ML26124 registers need to be accessed by
>>> different address when read and write.
>>> Like below
>>> R       W
>>> $00h $01h Sampling setting
>>> $02h $03h PLL setting
>>> ...
>>> Even so, can I use framework features ?
>> No, in which case (to repeat what I said previously) you need to make
>> the code *much* clearer so the reader can understand what it is doing
>> and why it's having to open code this stuff.
> 
> 
> thanks.

If this is for all registers, how does stuff like DAPM work, which uses the
framework internal update_bits function?

If it's the case that the write address is always read address + 1 you can
still use the framework if you set write_flag_mask to 0x01 in your regmap
config. In my opinion it even makes sense to shift all the register numbers
to the left by one and use a 7/9 instead of a 8/8 addr/reg layout. This will
reduce the amount of memory wasted due to holes in the register cache.
