Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2INIyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:54:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:1237 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2INIyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:54:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="221974649"
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to
 dmaengine_prep_dma_cyclic()
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
In-Reply-To: <5052E72A.8040207@metafoo.de>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>
	 <5051FB4D.3000009@metafoo.de> <1347593217.1943.26.camel@vkoul-udesk3>
	 <5052E72A.8040207@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 14:20:30 +0530
Message-ID: <1347612630.1943.29.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 10:13 +0200, Lars-Peter Clausen wrote:
> On 09/14/2012 05:26 AM, Vinod Koul wrote:
> > On Thu, 2012-09-13 at 17:27 +0200, Lars-Peter Clausen wrote:
> >> Hi,
> >>
> >> Hm... Do you think it would work as well if we implement this by
> >> setting the
> >> callback for the descriptor to NULL? If the callback is NULL there is
> >> nothing to at the end of a transfer/period and the dma engine driver
> >> may
> >> choose to disable interrupts. This would also benefit non cyclic
> >> transfers
> >> where the callback is NULL and we do not need add the new parameter to
> >> dmaengine_prep_dma_cyclic.
> > That will work too.... BUT the idea of no_wake mode in ALSA is that we
> > should not have any interrupts, so anything which is going to cause
> > interrupts to AP in undesired. The interrupts still happen and it just
> > that dmaengine driver is not notifying client.
> 
> Well, the idea was that the driver would disable interrupts if there is no
> callback to call, since there would be nothing to do in the interrupt
> handler anyway. But I guess the flags approach should work fine as well.
Yes we _could_ do that, but this relies on dmaengine driver to have this
implicit understanding. Anyone using dmaengine library in ASoC may or
may not be aware of this, so i would consider it hackish.

Using this flag explicitly makes everyone aware what the intended
behaviour is.

-- 
~Vinod

