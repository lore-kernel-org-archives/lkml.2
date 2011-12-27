Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1L0R0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:26:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33880 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab1L0R0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:26:03 -0500
Date: Tue, 27 Dec 2011 17:26:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [alsa-devel] [PATCH 2/4] ASoC: cx20442: add bias control over a
 platform provided regulator
Message-ID: <20111227172559.GB22970@opensource.wolfsonmicro.com>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1324681944-19067-3-git-send-email-jkrzyszt@tis.icnet.pl>
 <20111226110201.GA8722@opensource.wolfsonmicro.com>
 <201112271516.09114.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112271516.09114.jkrzyszt@tis.icnet.pl>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 03:16:08PM +0100, Janusz Krzysztofik wrote:
> On Monday 26 of December 2011 at 12:02:01, Mark Brown wrote:

> > which would look a lot more natural - you shouldn't need to remember if
> > the regulator is enabled, you should just turn it on in the STANDBY to
> > PREPARE transition and turn it off in the ON to PREPARE or PREPARE to
> > STANDBY transitions.

> Can I assume STANDBY or OFF at the time the codec .remove method is 
> called? If not, is there a helper function available which can be called 
> in order to perform all those ON -> PREPARE -> STANDBY [-> OFF] transitions before calling regulator_put()?

It'll be in STANDBY or OFF depending on if the device sets
idle_bias_off.
