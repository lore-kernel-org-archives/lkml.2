Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab2INDa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:30:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:51539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab2INDa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="144936144"
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
In-Reply-To: <5051FB4D.3000009@metafoo.de>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>
	 <5051FB4D.3000009@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:56:57 +0530
Message-ID: <1347593217.1943.26.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 17:27 +0200, Lars-Peter Clausen wrote:
> Hi,
> 
> Hm... Do you think it would work as well if we implement this by
> setting the
> callback for the descriptor to NULL? If the callback is NULL there is
> nothing to at the end of a transfer/period and the dma engine driver
> may
> choose to disable interrupts. This would also benefit non cyclic
> transfers
> where the callback is NULL and we do not need add the new parameter to
> dmaengine_prep_dma_cyclic.
That will work too.... BUT the idea of no_wake mode in ALSA is that we
should not have any interrupts, so anything which is going to cause
interrupts to AP in undesired. The interrupts still happen and it just
that dmaengine driver is not notifying client.


-- 
~Vinod

