Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab1IJUhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 16:37:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab1IJUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 16:37:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform drivers
Date: Sat, 10 Sep 2011 22:37:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
References: <3110288.bQbb0H2ME1@wuerfel> <20110909193010.GA2993@opensource.wolfsonmicro.com> <20110909205645.GA16355@n2100.arm.linux.org.uk>
In-Reply-To: <20110909205645.GA16355@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109102237.15193.arnd@arndb.de>
X-Provags-ID: V02:K0:1AcxefCY7deri8HivwRWXo/v8vCx1w+o37Pb0jqbAoT
 K7SlcpU6Z1D4aEJlf1inrciy0F7A0LPJrfV+WF7q6KHDVE+12G
 moAiTdCXQyiZ79OZoYijJeSQ1GmYflG+SSLlkGImEqwMURZyT+
 vExQS9H0UB1OCSYqVAcv5zlnnL+3rI984caBLm5pzBPX9D4aSP
 F+2AsnCYH7GJXPNG2KsPFEong7nmADDpMTNK/ydqb2pxK+IlXR
 UX1a3kzLKRwOGTU7cHxIQscWGFWRG129s74U++65VTffiq3Y79
 BFkVkqoP3oB35OqpKmOa1unW5zmYc9eH2MHu42tmh0r//wxhqO
 jvGaKfFeNL5Y7igtetWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011, Russell King - ARM Linux wrote:
> That's just twisted and utterly insane - adding more code for precisely
> zero benefit what so ever.  Think about it - the device tree is already
> creating platform devices for entries in the device tree file.  What's
> the point of having this special ASoC code look up the platform compatible
> property in a table of strings to find a different string to manually
> create a device with.  Why not just add the bloody device to the DT
> file in the first place?  That's partly what DT is there for - to create
> platform specific struct devices.

Exactly. No driver or (worse) user program should ever need to look at
the top-level compatible property. When you want information about a
localized part of the system (e.g. the ASoC components), you should
look up the information for that component.

	Arnd
