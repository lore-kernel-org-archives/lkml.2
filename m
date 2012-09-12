Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab2ILMxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:53:13 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:48238 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757819Ab2ILMxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:53:11 -0400
Message-ID: <505085DB.5000407@ti.com>
Date: Wed, 12 Sep 2012 15:53:47 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH 11/11] ASoC: omap-pcm: Convert to use dmaengine
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com> <1347450427-27627-12-git-send-email-peter.ujfalusi@ti.com> <20120912120028.GC28448@n2100.arm.linux.org.uk>
In-Reply-To: <20120912120028.GC28448@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 03:00 PM, Russell King - ARM Linux wrote:
> On Wed, Sep 12, 2012 at 02:47:07PM +0300, Peter Ujfalusi wrote:
>> 2. Pause/Resume
>>    OMAP DMA engine backend does not support pausing and resuming
>>    an in-progress transfer.  It is unclear from the specs what
>>    effect clearing the enable bit has on the DMA position of a
>>    destination synchronized transfer, and whether the transfer
>>    can be restarted from the exact point that it was paused (or
>>    whether the data in the FIFO read from memory is simply
>>    discarded.)
> 
> It's worth noting that this comment (which was in my original patch)
> is there to spark _comment_ and _discussion_ and should not make its
> way into the final version of these patches.
> 
> Given that suspend/resume is important on OMAP platforms, it's something
> that needs to be resolved - in a way that complies with what ALSA expects.
> I do not believe that the way the existing drivers do this is compliant
> as the manuals imply that stopping memory->peripheral transfers results
> in data being discarded from the DMA's FIFOs.  As I understand it, ALSA
> requires no data to be discarded.
> 
> As we have no way to know how much data may be discarded from the DMA
> FIFO...

I need to look at this, but at first look we do wait for the drain in
omap_stop_dma(). We used to use omap_stop_dma/omap_start_dma for pause/resume
operations.
But sDMA also have a bit: CDPi: PAUSE_LINK_LIST which should do what we are
looking for.
Need to read the relevant parts of the TRM, but AFAIK we are using normal mode
with linked list (self linking).
I already have the patch for this, I just need to test it on HW.

-- 
Péter
