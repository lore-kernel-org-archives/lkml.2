Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab1LBFMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:12:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35916 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1LBFMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <4ED7D734.4020301@metafoo.de>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
	<4ED37CE3.6040008@metafoo.de>
	<CANKRQnh7MnSQdKXvPJvSPzf-7afXmHip9LqR1cKCgB6HXqcnBg@mail.gmail.com>
	<4ED4EE48.8070100@metafoo.de>
	<CANKRQniP=UUAPbbyoZNvxs16H7QZzS=O9zwt6kJu69u8s8qGTQ@mail.gmail.com>
	<4ED7D734.4020301@metafoo.de>
Date: Fri, 2 Dec 2011 14:12:20 +0900
Message-ID: <CANKRQni0BCkS4ZkopnqWyDvwtb7+tbh9Utow9kkEFqnzGe1Wkg@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/2 Lars-Peter Clausen <lars@metafoo.de>:
> The middle part(the control) of the path must either be a control attached to
> the mixer on the left side(the sink) or a element of the mux's enum if a mux is
> on the left side. If the left side is neither a mixer or a mux the middle part
> is ignored.
>
> The other problem probably is that you have one mux which lets you switch
> between single-ended analog input, differential analog input and digital input.
> The first two options are routed through PGA and ADC the later not.
I can understand.
The "digital input" description shouldn't be at snd_soc_dpram_route description.
So, I've modified like below. These satisfies your showed condition.

	/* Supply */
	{"DAC", NULL, "MCLK"},
	{"ADC", NULL, "MCLK"},
	{"DAC", NULL, "PLL"},
	{"ADC", NULL, "PLL"},

	/* output mixer */
	{"Output Mixer", "PGA Switch", "PGA"},
	{"Output Mixer", "DAC Switch", "DAC"},
	{"Output Mixer", "Line in Switch", "LIN"},

	/* outputs */
	{"LOUT", NULL, "Output Mixer"},
	{"SPOUT", NULL, "Output Mixer"},

	/* input */
	{"Input Mux", "Analog MIC SingleEnded in", "MIN"},
	{"Input Mux", "Analog MIC Differential in", "MIN"},
	{"ADC", NULL, "Input Mux"},


Thanks,
tomoya
