Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1HLCt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:49:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43970 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752511Ab1HLCt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:49:56 -0400
Subject: Re: [PATCH 2/4] ASoC: Add ADAU1373 codec support
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <4E4471E1.5060706@metafoo.de>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
	 <1312948364-2587-2-git-send-email-lars@metafoo.de>
	 <20110811092702.GA18454@opensource.wolfsonmicro.com>
	 <4E43AACF.5060701@metafoo.de>
	 <1313068590.19990.2.camel@finisterre.wolfsonmicro.main>
	 <4E4471E1.5060706@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Fri, 12 Aug 2011 10:20:46 +0900
Message-ID: <1313112046.19990.32.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 02:20 +0200, Lars-Peter Clausen wrote:
> On 08/11/2011 03:16 PM, Mark Brown wrote:

> > Sorry, what does this actually control? I guess I've been mislead but
> > from the name of the control I'd expect it to control if the outputs
> > were physically connected as mono or stereo outputs.

> It controls how Lineout and Speaker mixers distribute the left and right input
> channels to their output channels.

Ah, I see. I guess that should really be represented in DAPM so that if
we're playing a mono signal out we figure out that both left and right
channels are connected even if there's only input for one of them,
especially for the line outputs which may be connected to external
speaker drivers or something that needs power management.

