Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2DPQtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:49:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:7969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab2DPQtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131527830"
Date: Mon, 16 Apr 2012 18:58:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Paul Parsons <lost.distance@yahoo.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: asic3: fix asic3_gpio_to_irq
Message-ID: <20120416165810.GR24130@sortiz-mobl>
References: <1334230414-1768-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334230414-1768-1-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Thu, Apr 12, 2012 at 03:33:34PM +0400, Dmitry Artamonow wrote:
> Assumption that irq numbers of asic3 gpios start at
> IRQ_BOARD_START is certainly wrong - driver may as well
> use any other base for its irqs (consider for example
> the imaginary case of two ASIC3 chips onboard)
> 
> Furthermore, some platforms even don't have IRQ_BOARD_START
> defined, so driver will fail to build on them:
> -------------------------------------------------------
> drivers/mfd/asic3.c: In function 'asic3_gpio_to_irq':
> drivers/mfd/asic3.c:530: error: 'IRQ_BOARD_START' undeclared (first use in this function)
> drivers/mfd/asic3.c:530: error: (Each undeclared identifier is reported only once
> drivers/mfd/asic3.c:530: error: for each function it appears in.)
> -------------------------------------------------------
> 
> Fix it by using irq_base from driver data.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
>  drivers/mfd/asic3.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
Thanks, I applied this one to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
