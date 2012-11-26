Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2KZKxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:53:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:31170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab2KZKxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:53:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,319,1352102400"; 
   d="scan'208";a="247144497"
Date: Mon, 26 Nov 2012 11:53:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] mfd: rc5t583: Fix array subscript is above array
 bounds
Message-ID: <20121126105335.GP12685@sortiz-mobl>
References: <1353378896.6455.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353378896.6455.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Nov 20, 2012 at 10:34:56AM +0800, Axel Lin wrote:
> I got below build warning while compiling this driver.
> It's obviously RC5T583_MAX_INTERRUPT_MASK_REGS is 9 but irq_en_add array only
> has 8 elements.
> 
>   CC      drivers/mfd/rc5t583-irq.o
> drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_sync_unlock':
> drivers/mfd/rc5t583-irq.c:227: warning: array subscript is above array bounds
> drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_init':
> drivers/mfd/rc5t583-irq.c:349: warning: array subscript is above array bounds
> 
> Since the number of interrupt enable registers is 8, this patch adds define for
> RC5T583_MAX_INTERRUPT_EN_REGS to fix this bug.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Laxman,
>   I don't have this hardware, I'd appreciate if you can review and test this patch.
> Thank you,
> Axel
>  drivers/mfd/rc5t583-irq.c   |    2 +-
>  include/linux/mfd/rc5t583.h |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
