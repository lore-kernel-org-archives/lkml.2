Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1JKOsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:48:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40897 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1JKOsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:48:32 -0400
Date: Tue, 11 Oct 2011 15:48:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 2/6] MFD: twl6040: Cache the vibra control registers
Message-ID: <20111011144824.GE1098@sirena.org.uk>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
 <1316760584-27426-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316760584-27426-3-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Drilling for oil is boring.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 09:49:40AM +0300, Peter Ujfalusi wrote:
> The vibra control register will be used from the ASoC codec driver as well.
> In order to avoid latency issues caused by I2C read access, cache the two
> control register within the core driver, so we do not need to reach out
> to the chip to read it back.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

It strikes me that it might be useful to just convert the driver to
regmap and get cache for everything...

Anyway, could you please restructure this series to minimize the
dependency on the input subsystem?  Then we can get the rest of it
applied.
