Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2ILMCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:02:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2ILMCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:02:13 -0400
Date: Wed, 12 Sep 2012 13:00:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH 11/11] ASoC: omap-pcm: Convert to use dmaengine
Message-ID: <20120912120028.GC28448@n2100.arm.linux.org.uk>
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com> <1347450427-27627-12-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347450427-27627-12-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:47:07PM +0300, Peter Ujfalusi wrote:
> 2. Pause/Resume
>    OMAP DMA engine backend does not support pausing and resuming
>    an in-progress transfer.  It is unclear from the specs what
>    effect clearing the enable bit has on the DMA position of a
>    destination synchronized transfer, and whether the transfer
>    can be restarted from the exact point that it was paused (or
>    whether the data in the FIFO read from memory is simply
>    discarded.)

It's worth noting that this comment (which was in my original patch)
is there to spark _comment_ and _discussion_ and should not make its
way into the final version of these patches.

Given that suspend/resume is important on OMAP platforms, it's something
that needs to be resolved - in a way that complies with what ALSA expects.
I do not believe that the way the existing drivers do this is compliant
as the manuals imply that stopping memory->peripheral transfers results
in data being discarded from the DMA's FIFOs.  As I understand it, ALSA
requires no data to be discarded.

As we have no way to know how much data may be discarded from the DMA
FIFO...
