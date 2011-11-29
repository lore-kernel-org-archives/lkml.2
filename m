Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1K2OhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:37:00 -0500
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1055 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1K2Og7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:36:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24853
Message-ID: <4ED4EE48.8070100@metafoo.de>
Date: Tue, 29 Nov 2011 15:38:00 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>	<4ED37CE3.6040008@metafoo.de> <CANKRQnh7MnSQdKXvPJvSPzf-7afXmHip9LqR1cKCgB6HXqcnBg@mail.gmail.com>
In-Reply-To: <CANKRQnh7MnSQdKXvPJvSPzf-7afXmHip9LqR1cKCgB6HXqcnBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 01:17 PM, Tomoya MORINAGA wrote:
> 2011/11/28 Lars-Peter Clausen <lars@metafoo.de>:
> 
>> Also none of the inputs is> routed to the ADC, which seems a bit strange.
> This same as my referencing "wm8731.c".Could you give me more information?
> 

The DAPM routes are used to do power management based on active path and for
this the routes should more or less represent the routing of internal audio
signals in your CODEC. I would expect the analog signals to go to the ADC on
the CODEC. And if you don't connect them in your DAPM routings ASoC will
probably not power-up the ADC since there are no active source signals.

Also this doesn't make much sense:
+	{"Input Mux", "Analog MIC in", "MICBIAS"},
+	{"Input Mux", "Digital MIC in", "MICBIAS"},

You have mux, but both possible settings of the mux connect to the same
source, which pretty much makes the mux useless.
