Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1IUJWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:22:21 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54211 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab1IUJWU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:22:20 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: Re: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Date: Wed, 21 Sep 2011 12:22:26 +0300
Message-ID: <2240573.6cRWXtKJB6@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20110919114031.GI23727@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com> <2033664.fWQvF2IA53@barack> <20110919114031.GI23727@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 September 2011 12:40:32 Mark Brown wrote:
> On Mon, Sep 19, 2011 at 02:26:31PM +0300, Péter Ujfalusi wrote:
> > Here in twl6040 we also have event handlers to do the ramp up/down on
> > the
> > gains. AFAIK some wm* codec have similar code.
> 
> WM8350.

The implementation in twl6040 looks similar to the one in the wm8350 in 
regards to the ramp code, and caching of the user configured gains.

If you take a look at the wm8350 driver it is also changing the L/R OUT 1/2 
registers at probe time.
I don't see any difference in the two.
Also it seams that wm8350 has the same problem:
The default after the reset is 0x39 (0 dB)
In the wm8350 probe it is changed to 0x00 (-57dB)

The twl6040 already had the ramp up, and down code, but it was missing the 
initialization part (IOW configuring the lowest gain on the outputs after 
first power on).

We do have other scenarios covered, but this initialization was missing. This 
resulted that the _first_ playback has pop noise, but all subsequent playbacks 
were fine, since we had the runtime fix for this.

--
Péter
