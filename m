Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1LZUoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 15:44:39 -0500
Received: from d1.icnet.pl ([212.160.220.21]:49174 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1LZUog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 15:44:36 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level callback
Date: Mon, 26 Dec 2011 21:43:23 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <201112261330.22783.jkrzyszt@tis.icnet.pl> <20111226172349.GK8722@opensource.wolfsonmicro.com>
In-Reply-To: <20111226172349.GK8722@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Message-Id: <201112262143.23704.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 of December 2011 at 18:23:50, Mark Brown wrote:
> On Mon, Dec 26, 2011 at 01:30:22PM +0100, Janusz Krzysztofik wrote:
> 
> > > Why's this code not been dropped and what is it for?
> 
> > It is, and will be, used by another regulator consumer, the modem. The 
> > device is controlled by the generic serial8250 driver, extended with a 
> > custom .pm hook which enables/disables the regulator. The above code, 
> > temporarily shared with the ASoC device before updated, is now just 
> > moved down the board file where the modem related bits are located (see 
> > patch 3/4).
> 
> > Any hints like that for the codec driver?
> 
> The main thing that looks bad here is that you're keeping track of the
> state of the regulator by hand.  It may be that the upper layers aren't
> reference counting in which case you might need this but it certainly
> looks very suspicious as-is.

OK, I can try to examine how the serial8250 driver tracks the device 
power state when calling the .pm hook and if it looks safe to drop that 
regulator state manual tracking.

Thanks,
Janusz
