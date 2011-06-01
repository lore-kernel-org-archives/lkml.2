Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1FANRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:17:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50061 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1FANRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:17:15 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Date: Wed, 1 Jun 2011 16:17:14 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com> <201106011554.53090.peter.ujfalusi@ti.com> <20110601130034.GE11352@atomide.com>
In-Reply-To: <20110601130034.GE11352@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201106011617.14854.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011 16:00:34 Tony Lindgren wrote:
> Yeah, most of it might be possible to describe with just a flags
> like TWL_HAS_VIBRA etc.

Or TWL_BOARD_HAS_VIBRA, TWL_BOARD_HAS_CODEC...

For the audio part it is a bit complicated than that:
different base frequencies, for twl6040 we have parameters for Vibra (twl4030 
class only have the coexistence). The soc codec has a list of misc parameters 
for board specific configurations as well (not all board using them).
I was thinking to switch the MFD driver(s) to use flags to specify the needed 
child, and change the child drivers to deal with the missing platform data 
themselves.
In that way, board files can pass the vibra/codec platform data to the new 
i2c_twl file for example, and provide flags to enable functionality.

> > I'll take a look, but I think it is not going to be part of v2 of this
> > series.
> 
> We should not do renaming before the clean-up though, it gets
> classified as "unnecesary churn".

The changes in board files are minimal. The biggest part is the code move, and 
that will remain the same now or later...

-- 
Péter
