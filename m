Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2A3IbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:31:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:64931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab2A3IbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:31:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="104072500"
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
	 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 14:02:26 +0530
Message-ID: <1327912346.1527.13.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 15:56 +0100, Guennadi Liakhovetski wrote:
> This patch adds a library of functions, helping to implement dmaengine
> drivers for hardware, unable to handle scatter-gather lists natively.
> The first version of this driver only supports memcpy and slave DMA
> operation.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v2:
> 
> 1. switch from using a tasklet to threaded IRQ, which allowed to
> 2. remove lock / unlock inline functions
> 3. remove __devinit, __devexit annotations
Sorry to join the discussion late, was on vacation, travel, long
weekend...

I don't still comprehend the need for a library on top of dmaengine
which gain is just a library between clients and dmacs. Surely we don't
want to write another abstraction on top of one provided?

If the question is to handle scatter-gather even if the hardware doesn't
have the capability, then why don't add that in dmaengine itself rather
than one more layer?

-- 
~Vinod

