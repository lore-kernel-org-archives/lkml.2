Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2AILxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:53:46 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:57199 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691Ab2AILxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:53:44 -0500
Message-ID: <1326110015.24178.5.camel@odin>
Subject: Re: [PATCH v2 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level
 callback
From: Liam Girdwood <lrg@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Date: Mon, 09 Jan 2012 11:53:35 +0000
In-Reply-To: <1325214296-2888-5-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1325214296-2888-5-git-send-email-jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-30 at 04:04 +0100, Janusz Krzysztofik wrote:
> This functionality has just been implemented in the cx20442 codec
> driver, no need to keep it here duplicated.
> 
> Once done, remove the no longer used AMS_DELTA_LATCH2_MODEM_NRESET
> symbol from the board header file and a call to the regulator_toggle()
> helper function from the old API wrapper found in the board file.  While
> being at it, simplify the way the modem .pm callback handles the
> regulator, and drop that no longer used helper function and its related
> consumer setup elements completely.
> 
> Depends on patch 3/4 "ARM: OMAP1: ams-delta: update the modem to use
> regulator API"
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> Changes against initial version:
> * don't move consumer setup elements, now named to indicated their
>   modem related purpose, down the file,
> * don't track the regulator enavble/disable state, compare new target
>   power state with the old one instead; thanks to Mark Brown for
>   suggesting this simplification,
> * actually drop all references to AMS_DELTA_LATCH2_MODEM_NRESET.
> 
>  arch/arm/mach-omap1/board-ams-delta.c             |   42 +++-----------------
>  arch/arm/plat-omap/include/plat/board-ams-delta.h |    1 -
>  sound/soc/omap/ams-delta.c                        |   32 ----------------
>  3 files changed, 7 insertions(+), 68 deletions(-)

I tried to apply against ASoC but it failed with the omap files. It may
be better for this patch to go via Tony. 

2/4 applies and builds ok, but if there is a runtime dependency on the
rest it should go via Tony too.

Thanks

Liam

