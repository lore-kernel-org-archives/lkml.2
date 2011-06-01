Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1FANic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:38:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19178 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507Ab1FANia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:38:30 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3T+VarDt0/+KNaXAyt8z6
Date: Wed, 1 Jun 2011 06:38:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Message-ID: <20110601133823.GI11352@atomide.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
 <201106011554.53090.peter.ujfalusi@ti.com>
 <20110601130034.GE11352@atomide.com>
 <201106011617.14854.peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106011617.14854.peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [110601 06:13]:
> On Wednesday 01 June 2011 16:00:34 Tony Lindgren wrote:
> > Yeah, most of it might be possible to describe with just a flags
> > like TWL_HAS_VIBRA etc.
> 
> Or TWL_BOARD_HAS_VIBRA, TWL_BOARD_HAS_CODEC...
> 
> For the audio part it is a bit complicated than that:
> different base frequencies, for twl6040 we have parameters for Vibra (twl4030 
> class only have the coexistence). The soc codec has a list of misc parameters 
> for board specific configurations as well (not all board using them).
> I was thinking to switch the MFD driver(s) to use flags to specify the needed 
> child, and change the child drivers to deal with the missing platform data 
> themselves.
> In that way, board files can pass the vibra/codec platform data to the new 
> i2c_twl file for example, and provide flags to enable functionality.

OK, sounds doable.
 
> > > I'll take a look, but I think it is not going to be part of v2 of this
> > > series.
> > 
> > We should not do renaming before the clean-up though, it gets
> > classified as "unnecesary churn".
> 
> The changes in board files are minimal. The biggest part is the code move, and 
> that will remain the same now or later...

But you could easily remove all the board specific struct twl4030_codec_data
and struct twl4030_codec_audio_data entries by adding a default audio
init option to omap_pmic_init for the common configuration.

How about something like:

void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
                    struct twl4030_platform_data *pmic_data, u32 flags);

Where flags would be TWL_BOARD_HAS_DEFAULT_CODEC etc, and if the entry in
pmic_data is NULL, just use the default configuration. I think you already
have the clkrate there?

Regards,

Tony
