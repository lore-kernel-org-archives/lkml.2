Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1ISL03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:26:29 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58730 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab1ISL01 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:26:27 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Date: Mon, 19 Sep 2011 14:26:31 +0300
Message-ID: <2033664.fWQvF2IA53@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20110919110006.GH23727@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com> <1316090379-30760-8-git-send-email-peter.ujfalusi@ti.com> <20110919110006.GH23727@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 September 2011 12:00:06 Mark Brown wrote:
> On Thu, Sep 15, 2011 at 03:39:29PM +0300, Peter Ujfalusi wrote:
> > The default gains on outputs/inputs are set to 0dB.
> > To be able to handle pop noise better, we need to lower
> > the gains on controls, where it is possible.
> 
> It looks like what you really want to do here is implement support
> having PGAs able to cache the gain the user has set but hold the gain at
> zero while the PGA is disabled.

The twl6040 had support for this, but we did not lowered the initial gain 
after cold power on.
This resulted a pop noise at the first time the audio paths had been used.

> This would be generally useful, a lot
> of older parts liked to have the PGAs muted when powering them.

I have similar implementation (caching of the output gain values) in the 
twl4030 - there the reason was to decrease the power consumption.
We need to have some sort of caching for the gain values, and linking the 
volume controls to DAPM in order to restore, or turn them off at the correct 
time.
In twl4030 case I have custom PGA event handlers for outputs, and I manage the 
individual output amplifiers through them.
Here in twl6040 we also have event handlers to do the ramp up/down on the 
gains. AFAIK some wm* codec have similar code.

I can take a look at these to find a generic way to handle them.

--
Péter
