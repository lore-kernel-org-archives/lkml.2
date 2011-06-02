Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1FBGPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 02:15:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48379 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1FBGPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 02:15:47 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Date: Thu, 2 Jun 2011 09:15:46 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com> <201106011617.14854.peter.ujfalusi@ti.com> <20110601133823.GI11352@atomide.com>
In-Reply-To: <20110601133823.GI11352@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201106020915.46491.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011 16:38:23 Tony Lindgren wrote:
> But you could easily remove all the board specific struct
> twl4030_codec_data and struct twl4030_codec_audio_data entries by adding a
> default audio init option to omap_pmic_init for the common configuration.

Yeah, I can grep in the board files, and see what is the most common 
configuration

> How about something like:
> 
> void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int
> pmic_irq, struct twl4030_platform_data *pmic_data, u32 flags);

common-board-devices.c has omap_pmic_init, but without the flags.

> Where flags would be TWL_BOARD_HAS_DEFAULT_CODEC etc, and if the entry in
> pmic_data is NULL, just use the default configuration. I think you already
> have the clkrate there?

I'll take a look, should we have new file specifically for twl, or should I 
extend the common-board-devices.c with the twl related things? IMHO a new file 
might be better, since the full twl config might be quite big.

-- 
Péter
