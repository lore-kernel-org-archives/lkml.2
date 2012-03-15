Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2COEuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:50:50 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61279 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2COEus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120314144524.GT3133@opensource.wolfsonmicro.com>
References: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
	<1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
	<20120314144524.GT3133@opensource.wolfsonmicro.com>
Date: Thu, 15 Mar 2012 13:50:48 +0900
Message-ID: <CANKRQni-8w+2p6=ZisQ+GXhGpNmYhesKfTHfOjWGGrQrhvTFGA@mail.gmail.com>
Subject: Re: [PATCH v6] sound/soc/lapis: add machine driver for ML7213 Carrier Board
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:45 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 09, 2012 at 03:38:11PM +0900, Tomoya MORINAGA wrote:
>
>> +     /* set codec DAI configuration */
>> +     ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
>> +                              SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* set cpu DAI configuration */
>> +     ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
>> +                              SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
>
> This looks very broken, you're setting the two ends of the link to
> different configurations.  If this is needed it should be documented why.
>
> Also, this should be set in the dai_link structure as data rather than
> set each time.

OK.
codec is slave, i2s controller is master.
So, I'll use SND_SOC_DAIFMT_CBS_CFM.

thanks.
-- 
ROHM Co., Ltd.
tomoya
