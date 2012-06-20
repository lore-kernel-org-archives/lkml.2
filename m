Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2FTLDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:03:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:29955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab2FTLDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158599289"
Subject: Re: [PATCH v2 3/3] ASoC: dmaengine-pcm: Add support for querying
 stream position from DMA driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1339438302-12417-3-git-send-email-lars@metafoo.de>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
	 <1339438302-12417-3-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 16:25:33 +0530
Message-ID: <1340189733.1927.1651.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 20:11 +0200, Lars-Peter Clausen wrote:
> Currently the sound dmaengine pcm helper functions implement the pcm_pointer
> callback by trying to count the number of elapsed periods. This is done by
> advancing the stream position in the dmaengine callback by one period.
> Unfortunately there is no guarantee that the callback will be called for each
> elapsed period. It may be possible that under high system load it is only called
> once for multiple elapsed periods. This patch addresses the issue by
> implementing support for querying the current stream position directly from the
> dmaengine driver. Since not all dmaengine drivers support reporting the stream
> position yet the old period counting implementation is kept for now.
> 
> Furthermore the new mechanism allows to report the stream position with a
> sub-period granularity, given that the dmaengine driver supports this.
> 
Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

