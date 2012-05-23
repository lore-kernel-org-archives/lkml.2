Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab2EWLfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:35:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:18870 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933378Ab2EWLfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170303956"
Date: Wed, 23 May 2012 13:35:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, jonghwa3.lee@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] MFD: MAX77693: add IRQ handler
Message-ID: <20120523113529.GA23600@sortiz-mobl>
References: <1336995606-1607-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336995606-1607-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Mon, May 14, 2012 at 08:40:06PM +0900, Chanwoo Choi wrote:
> This patch supports IRQ handling for MAX77693.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
This patch breaks the build in this way:

drivers/mfd/max77693.c: In function ‘max77693_i2c_probe’:
drivers/mfd/max77693.c:157:2: error: implicit declaration of function
‘max77693_irq_init’ [-Werror=implicit-function-declaration]
drivers/mfd/max77693.c: In function ‘max77693_resume’:
drivers/mfd/max77693.c:215:2: error: implicit declaration of function
‘max77693_irq_resume’ [-Werror=implicit-function-declaration]

drivers/mfd/max77693-irq.c: In function ‘max77693_irq_lock’:
drivers/mfd/max77693-irq.c:104:2: error: ‘struct max77693_dev’ has no member
named ‘irqlock’
drivers/mfd/max77693-irq.c: In function ‘max77693_irq_sync_unlock’:
drivers/mfd/max77693-irq.c:119:11: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cache’
drivers/mfd/max77693-irq.c:119:42: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:122:13: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:125:24: error: ‘struct max77693_dev’ has no member
named ‘irqlock’
drivers/mfd/max77693-irq.c: In function ‘max77693_irq_mask’:
drivers/mfd/max77693-irq.c:141:11: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:143:11: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c: In function ‘max77693_irq_unmask’:
drivers/mfd/max77693-irq.c:153:11: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:155:11: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c: In function ‘max77693_irq_thread’:
drivers/mfd/max77693-irq.c:209:26: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:211:27: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:217:39: error: ‘struct max77693_dev’ has no member
named ‘irq_domain’
drivers/mfd/max77693-irq.c: In function ‘max77693_irq_init’:
drivers/mfd/max77693-irq.c:260:2: error: ‘struct max77693_dev’ has no member
named ‘irqlock’
drivers/mfd/max77693-irq.c:268:12: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:269:12: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cache’
drivers/mfd/max77693-irq.c:271:12: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cur’
drivers/mfd/max77693-irq.c:272:12: error: ‘struct max77693_dev’ has no member
named ‘irq_masks_cache’
drivers/mfd/max77693-irq.c:292:10: error: ‘struct max77693_dev’ has no member
named ‘irq_domain’

I fixed it up for you with commit 78302a194c0ddf4438e50e3f9b327a6dce6bc8fc but
please make sure your code builds properly next time.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
