Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1FCNi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:38:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33178 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1FCNiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:38:21 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Date: Fri, 3 Jun 2011 16:38:25 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com> <201106020915.46491.peter.ujfalusi@ti.com> <20110603080819.GK8696@atomide.com>
In-Reply-To: <20110603080819.GK8696@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201106031638.26094.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 11:08:22 Tony Lindgren wrote:
> Yeah if it gets big then a separate file is better. Also, if we have
> a common init function for twl, then it's easy to add the board specific
> device tree initialization to that too and just leave out the calls to
> omap_pmic_init from board-*.c files.

I have parsed the board files for a pattern.
There are some, but I have my doubts as well:
We have eight platform data members in twl4030_platform_data for child 
devices.
USB, and audio/codec configuration might worth to move out (since most of the 
board does not have fine tuned parameters for codec).

The majority of the code related to pmic is coming from regulator setups, I 
can see similarities, but there are differences here and there, which makes 
the common configuration mostly useless (different peripherals, boot loader 
diffs, etc).

Having said that, I try to create a wrapper for omap_pmic_init, which can 
replace the current omap2/3/4_pmic_init, with that we can use common config 
for USB, audio, and some selected few regulators initially.
Later other parts might be possible to consolidate as well.
I'm going to call this new wrapper for now omap2/3/4_pmic_config.

Is this a good way to approach this issue?

-- 
Péter
