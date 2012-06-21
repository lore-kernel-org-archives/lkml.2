Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296Ab2FUVDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:03:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760281Ab2FUVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:03:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
Date: Thu, 21 Jun 2012 21:03:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <201206211717.46142.arnd@arndb.de> <4FE35A78.60003@wwwdotorg.org>
In-Reply-To: <4FE35A78.60003@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206212103.29517.arnd@arndb.de>
X-Provags-ID: V02:K0:HrUMPmmX/4lsrNttrsDcBWsRwUqUwA2wCk+hvk5vwUU
 G3wF9fgzkX5i/wnVUHlr96am3XThMFPyF/Tg13b+h0YhH/o/Nt
 zBfc4p2WivL8/WoBG8Iu9nxEaA4TWNlPREDiVB8XgPr8RCyUYP
 9AW0/cQuc9PSWtyI/1Pxz0i54L6rl/8d+8fkB5INbHoV2rvEst
 oHKiuk+y4wWeAyd+Uk9TlMDR32+yqeqVeYPjlhErFhnwmgCFFC
 3xQ89hi4ExjpZ/G7RY/AMaGhyO1/74lIscwinFzwz9BXdCTKB0
 5KZB3N0xyg8OKbKDsoi0Nms4ns70hD97CEmL8JlXFyCiPdiFJD
 q8Ich4o276cs+kAvPgyQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012, Stephen Warren wrote:
> > It should never be necessary to add board-specific properties in the
> > nodes that describe the SoC specific bits. What I was referring to
> > is just moving the data that currently resides in the regulator
> > driver into DT.
> 
> I guess I must be misunderstanding that comment - there are many many
> examples of boards adding properties to nodes that describe the SoC. For
> example, the GPIOs used by SDHCI controllers, board-specific max clock
> rates for SDHCI or I2C controllers, pinmux configuration properties, to
> name just a few.

The difference is that configuration is board specific, but capabilities
of the hardware are soc specific. The regulator-compatible property
identifies just the capabilities and the location of one regulator:

Look at struct ab8500_regulator_info, everything in there describes
the soc: min/max voltages, register banks, startup delay. Those are
all things that we could in theory have in the .dtsi file describing
the soc.

The board specific settings on the other hand are about what to
put into those registers and what voltage to use. From all I can
tell, those settings belong into the node that actually uses the
regulator, not the node that defines it.

	Arnd
