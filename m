Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab1LZRX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:23:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59770 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1LZRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:23:56 -0500
Date: Mon, 26 Dec 2011 17:23:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level callback
Message-ID: <20111226172349.GK8722@opensource.wolfsonmicro.com>
References: <201112261330.22783.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112261330.22783.jkrzyszt@tis.icnet.pl>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 01:30:22PM +0100, Janusz Krzysztofik wrote:

> > Why's this code not been dropped and what is it for?

> It is, and will be, used by another regulator consumer, the modem. The 
> device is controlled by the generic serial8250 driver, extended with a 
> custom .pm hook which enables/disables the regulator. The above code, 
> temporarily shared with the ASoC device before updated, is now just 
> moved down the board file where the modem related bits are located (see 
> patch 3/4).

> Any hints like that for the codec driver?

The main thing that looks bad here is that you're keeping track of the
state of the regulator by hand.  It may be that the upper layers aren't
reference counting in which case you might need this but it certainly
looks very suspicious as-is.
