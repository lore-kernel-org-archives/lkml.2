Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2ITL72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:59:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55074 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab2ITL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:59:26 -0400
Date: Thu, 20 Sep 2012 07:59:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: codecs: Add DA9055 codec driver
Message-ID: <20120920115908.GL17666@opensource.wolfsonmicro.com>
References: <1347622057.16763.27.camel@matrix>
 <20120919025035.GI8832@opensource.wolfsonmicro.com>
 <1348142335.18996.17.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348142335.18996.17.camel@matrix>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:28:55PM +0530, Ashish Chavan wrote:

> > > +	/* To select if MIC Bias powers MIC 1 or MIC 2 */
> > > +	SOC_ENUM("Mic Bias Select", da9055_mic_bias_select),

> > This would normally be something controlled by the board...  what
> > exactly is this doing?  How does the MICBIAS relate to the microphone
> > inputs?

> Yes, it should be controlled by the board.
> This control selects which of the two MIC Bias pins acts as the BIAS
> source. Earlier we misinterpreted it because of a hardware modification
> which was present on the board without our knowledge.

OK, that sounds like it should either be hooked up in the DAPM graph
or supplied as platform data then.

> > Given that there's no regulator support here
> > it's also a bit surprising that you need to do a sync outside of system
> > suspend...

> I am not sure if I understood this fully. Do you mean a sync is not
> required here?

You only need to resync if the device might have lost power and
forgotten it's register settings (or might've forgotten them for some
other reason).  If the device is left powered up then this isn't needed.
