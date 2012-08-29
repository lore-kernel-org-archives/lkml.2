Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2H2FNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 01:13:07 -0400
Received: from d1.icnet.pl ([212.160.220.21]:45865 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab2H2FNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 01:13:05 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: ams-delta: fix card initalization failure
Date: Wed, 29 Aug 2012 07:04:48 +0200
Message-ID: <1809544.cvZPIRmRr5@acer>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; i686; ; )
In-Reply-To: <20120828181338.GB8796@opensource.wolfsonmicro.com>
References: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl> <3048168.EXxi4fR4e7@acer> <20120828181338.GB8796@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012 11:13:39 Mark Brown wrote:
> On Tue, Aug 28, 2012 at 05:13:05PM +0200, Janusz Krzysztofik wrote:
> > On Mon, 27 Aug 2012 14:38:35 Mark Brown wrote:
> > > On Mon, Aug 27, 2012 at 11:28:30PM +0200, Janusz Krzysztofik wrote:
> 
> > > > -	platform_set_drvdata(ams_delta_audio_platform_device,
> > > > -				&ams_delta_audio_card);
> 
> > > The real fix here is that you should be using platform data here, 
not
> > > driver data.  Is there some reason not to do that?
> 
> > Do you think the change you propose is suitable for the rc cycle? 
I'm 
> > trying to fix a regression in the first place. Converting the ams-
delta 
> > asoc to a platform driver is on my todo list and I'm going to take 
care 
> > of this as soon as I have enough spare time.
> 
> The above looks like you already have a platform driver?  All I'm
> suggesting is changing the above to use platform rather than driver
> data.

The ams-delta asoc driver doesn't use snd_soc_register_card() so far, 
but relays solely on soc_probe() doing this for it, which in turn 
expects to find a snc_soc_card structure in drvdata. How is it supposed 
to find that structure if I pass it over platform data instead? Am I 
missing something?

Thanks,
Janusz
