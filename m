Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2FTNpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:45:34 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24001
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290Ab2FTNpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:45:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 20 Jun 2012 21:41:32 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>, <alsa-devel@alsa-project.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [alsa-devel] [PATCH v2 2/3] ASoC: dmaengine-pcm: Rename and
 deprecate snd_dmaengine_pcm_pointer
Message-ID: <20120620134131.GK10387@shlinux2.ap.freescale.net>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
 <1339438302-12417-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339438302-12417-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 08:11:41PM +0200, Lars-Peter Clausen wrote:
> Currently the sound dmaengine pcm helper functions implement the pcm_pointer
> callback by trying to count the number of elapsed periods. This is done by
> advancing the stream position in the dmaengine callback by one period.
> Unfortunately there is no guarantee that the callback will be called for each
> elapsed period. It may be possible that under high system load it is only called
> once for multiple elapsed periods. This patch renames the current implementation
> and documents its shortcomings and that it should not be used anymore in new
> drivers.
> 
> The next patch will introduce a new snd_dmaengine_pcm_pointer which will be
> implemented based on querying the current stream position from the dma device.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

> ---
> If you are maintaining a pcm driver which use the dmaengine pcm helper please
> check if you platform works with the new snd_dmaengine_pcm_pointer
> implementation which is added in the next patch (ux500 seems to be good
> candidate). And if it does send a follow-up patch to convert your platform to
> the new implementation. If it does not please try to fix or add residue
> reporting support to your dmaengine driver.
> 
Will try it after adding cyclic tx_status support for mxs/imx dma driver.

Regards
Dong Aisheng

