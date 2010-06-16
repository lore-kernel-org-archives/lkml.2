Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0FPHuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:50:01 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37347 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0FPHt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:49:59 -0400
Date: Wed, 16 Jun 2010 16:49:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-sh@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] soc/sh: Fix I2C dependency for SND_FSI_AK4642 and SND_FSI_DA7210
Message-ID: <20100616074947.GC29614@linux-sh.org>
References: <201006141739.42346.PeterHuewe@gmx.de> <201006151649.07554.PeterHuewe@gmx.de> <20100615151913.GJ14510@rakim.wolfsonmicro.main> <201006151738.56143.PeterHuewe@gmx.de> <20100616035440.GA29614@linux-sh.org> <250A6DE6-BB14-42F7-9500-A479C8FCA9B3@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <250A6DE6-BB14-42F7-9500-A479C8FCA9B3@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:43:33AM +0100, Mark Brown wrote:
> On 16 Jun 2010, at 04:54, Paul Mundt wrote:
> 
> > On Tue, Jun 15, 2010 at 05:38:55PM +0200, Peter Huewe wrote:
> >> The config option SND_FSI_AK4642 selects SND_SOC_AK4642 which in turn
> >> enables the compilation of ak4642.c - however this codec uses I2C to
> >> communicate with the HW.
> >> Same applies to DA7210.
> 
> > It uses I2C, but it doesn't matter which I2C master it's interfaced with.
> > A simple depends on I2C will suffice for this purpose just fine.
> 
> Since these are board specific drivers they know which I2C controller they are
> hooked up to and so can usefully depend on a specific controller - without the
> correct controller driver they will not function.

I don't really mind one way or the other. Having it depend on the
controller is fine, but it's not really much of a stretch to expect it to
show up on other boards with other controllers as well.

Very few SH CPUs use the same controller, so in this case it's really
more the exception than the norm. As soon as another board takes up one
of these blocks then we're forced to either switch to an I2C depends or
start making a dependency list for multiple controllers. It's the desire
to avoid the latter why I generally prefer the former, but again, I'm
fairly impartial regardless.
