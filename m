Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1LAThb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:37:31 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65284 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab1LATha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:37:30 -0500
Message-ID: <4ED7D734.4020301@metafoo.de>
Date: Thu, 01 Dec 2011 20:36:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
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
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>	<4ED37CE3.6040008@metafoo.de>	<CANKRQnh7MnSQdKXvPJvSPzf-7afXmHip9LqR1cKCgB6HXqcnBg@mail.gmail.com>	<4ED4EE48.8070100@metafoo.de> <CANKRQniP=UUAPbbyoZNvxs16H7QZzS=O9zwt6kJu69u8s8qGTQ@mail.gmail.com>
In-Reply-To: <CANKRQniP=UUAPbbyoZNvxs16H7QZzS=O9zwt6kJu69u8s8qGTQ@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 08:46 AM, Tomoya MORINAGA wrote:
> 2011/11/29 Lars-Peter Clausen <lars@metafoo.de>:
>>
>> Also this doesn't make much sense:
>> +       {"Input Mux", "Analog MIC in", "MICBIAS"},
>> +       {"Input Mux", "Digital MIC in", "MICBIAS"},
>>
>> You have mux, but both possible settings of the mux connect to the same
>> source, which pretty much makes the mux useless.
>>
> 
> Yes, you are right.
> This setting was miss-settings.
> This MICBIAS supplies to external MIC as reference voltage.
> So, I think MICBIAS shouldn't appear at this setting.
> I show modified settings.
>        /* input */
>        {"Input Mux", "Analog MIC SingleEnded in", "MIN"},
>        {"Input Mux", "Analog MIC Differential in", "MIN"},
>        {"Input Mux", "Digital MIC in", "MDIN"},
>        {"ADC", "PGA", "Input Mux"},
> 

The middle part(the control) of the path must either be a control attached to
the mixer on the left side(the sink) or a element of the mux's enum if a mux is
on the left side. If the left side is neither a mixer or a mux the middle part
is ignored.

The other problem probably is that you have one mux which lets you switch
between single-ended analog input, differential analog input and digital input.
The first two options are routed through PGA and ADC the later not.

- Lars
