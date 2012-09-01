Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2IAJ3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:29:49 -0400
Received: from d1.icnet.pl ([212.160.220.21]:47708 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab2IAJ3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:29:48 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: ams-delta: fix card initalization failure
Date: Sat, 01 Sep 2012 11:09:18 +0200
Message-ID: <1939338.OUN9Uq58XY@vclass>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.8.3 (Linux/3.1.10-gentoo-r1; KDE/4.8.3; i686; ; )
In-Reply-To: <20120831213103.GC5495@opensource.wolfsonmicro.com>
References: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl> <1809544.cvZPIRmRr5@acer> <20120831213103.GC5495@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia piątek, 31 sierpnia 2012 14:31:04 Mark Brown pisze:
> On Wed, Aug 29, 2012 at 07:04:48AM +0200, Janusz Krzysztofik wrote:
> > On Tue, 28 Aug 2012 11:13:39 Mark Brown wrote:
> 
> > > The above looks like you already have a platform driver? 

Mark,
I should have rather answered: No, ams-delta.c is not a platform driver, 
only a module which registeres a soc-audio device and provides device 
specific data and callbacks to the soc-audio platform driver.

> > > All I'm
> > > suggesting is changing the above to use platform rather than 
driver
> > > data.
> ...
> s/drvdata/platdata/ in the code. 

Taking the above into account, I would have to apply this substitue to 
the soc-core.c, which is actually the platform driver for the ams-delta 
ASoC device, and this would break a lot of other cards.

> If you can't do this then just
> referencing the data directly in the code would be better than this
> bodge, it'd be much less fragile.

I see your point, however for now I can see no better way of referencing 
the data (of type struct snd_soc_card) then passing it to 
snd_soc_register_card(). But for this to work, I would have to register 
successfully an ams-delta specific platform device first, not the soc-
audio. This, even if still done from the sound/soc/omap/ams-delta.c, not 
from an arch board file, would require now not existing ams-delta ASoC 
platform driver probe/remove callbacks at least. I'm still not convinced 
if such modification would be acceptable in the middle of the rc cycle.

If there is a simpler, less intrusive way to do this, then sorry, I 
still can't see it.

Thanks,
Janusz
