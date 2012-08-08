Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2HHMng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:43:36 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35873 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758085Ab2HHMnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:43:33 -0400
Message-ID: <50225EF1.4010203@ti.com>
Date: Wed, 08 Aug 2012 15:43:29 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com> <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com> <5022529D.3090406@ti.com>
In-Reply-To: <5022529D.3090406@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 08/08/2012 02:50 PM, Benoit Cousson wrote:
>> +Required properties:
>> +- compatible : must be "ti,twl4030-audio"
>> +- ti,audio_mclk: Master clock frequency used on the board. Supported
>> +	         frequencies: 19200000, 26000000 and 38400000
> 
> Since you care about the frequency only you can use the generic
> attribute: clock-frequency (in your example, I2C is using it).

I see, I'll use replace the property with clock-frequency.

> That being said, since we do have the clock binding now, maybe we should
> create a clock provider at board level for the sys_clk and thus you will
> just have to create a phandle to it in your audio description.
> 
> In theory OMAP and other components will thus have to use that sys_clock
> reference as well.

And in the driver I would need to do for example:
clkp = clk_get(NULL, "audio_mclk");
clk_rate = clk_get_rate(clkp);
clk_put(clkp);

to get the frequency in this way?
Note that the twl4030-audio stack itself does not handle clocks at the moment
since the clock needed for the audio module is always running (HFCLKIN ->
HFCLKOUT -> AUDIO_MCLK (USB_MCLK)). All of this is within twl4030. Do we
really want to model this?

-- 
Péter
