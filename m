Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1FCIIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:08:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24732 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891Ab1FCIIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:08:30 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/7QwJ/zkFiQxRgsv7mubij
Date: Fri, 3 Jun 2011 11:08:22 +0300
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
Message-ID: <20110603080819.GK8696@atomide.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
 <201106011617.14854.peter.ujfalusi@ti.com>
 <20110601133823.GI11352@atomide.com>
 <201106020915.46491.peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106020915.46491.peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [110602 09:11]:
> On Wednesday 01 June 2011 16:38:23 Tony Lindgren wrote:
> > But you could easily remove all the board specific struct
> > twl4030_codec_data and struct twl4030_codec_audio_data entries by adding a
> > default audio init option to omap_pmic_init for the common configuration.
> 
> Yeah, I can grep in the board files, and see what is the most common 
> configuration
> 
> > How about something like:
> > 
> > void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int
> > pmic_irq, struct twl4030_platform_data *pmic_data, u32 flags);
> 
> common-board-devices.c has omap_pmic_init, but without the flags.
> 
> > Where flags would be TWL_BOARD_HAS_DEFAULT_CODEC etc, and if the entry in
> > pmic_data is NULL, just use the default configuration. I think you already
> > have the clkrate there?
> 
> I'll take a look, should we have new file specifically for twl, or should I 
> extend the common-board-devices.c with the twl related things? IMHO a new file 
> might be better, since the full twl config might be quite big.

Yeah if it gets big then a separate file is better. Also, if we have
a common init function for twl, then it's easy to add the board specific
device tree initialization to that too and just leave out the calls to
omap_pmic_init from board-*.c files.

Regards,

Tony
