Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab1LHHey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:34:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:19628 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab1LHHev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:34:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99969247"
Subject: Re: [PATCH] video IPUv1 fixes for different display connections
From: Vinod Koul <vinod.koul@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@keymile.com>,
        Daniel Mack <daniel@caiaq.de>, Eric Benard <eric@eukrea.com>
In-Reply-To: <1322747932-24943-1-git-send-email-s.hauer@pengutronix.de>
References: <1322747932-24943-1-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 13:03:26 +0530
Message-ID: <1323329606.1641.25.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 14:58 +0100, Sascha Hauer wrote:
> Hi,
> 
> The following series fixes the display connections to the IPU on
> i.MX3 boards. The connection to the display is completely independend
> of the internal pixel format in the framebuffer. The driver instead
> changes the IPU <-> Display mapping dependent on the pixelformat
> which is wrong.
> The following patch makes 16bpp and 32bpp modes possible on both
> RGB666 and RGB888 connected displays.
> The burstsize setting for 32bpp was configured wrong, so 32bpp
> modes have obviously never been tested.
> 
> Not for stable since all in kernel boards seem to work.
Applied thanks.

Couldn't help but notice that :
@@ -312,7 +312,7 @@ static void ipu_ch_param_set_size(union
chan_param_mem *params,
        case IPU_PIX_FMT_RGB565:
                params->ip.bpp  = 2;
                params->ip.pfs  = 4;

is not really good way. Someone else who is using this driver has no way
of knowing what these magic numbers mean and how to use them
Perhaps you can add meaning to these numbers and some note on why they
should be set to these values.


-- 
~Vinod

