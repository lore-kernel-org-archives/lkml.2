Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2DPQbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:31:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:42890 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab2DPQbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89619288"
Date: Mon, 16 Apr 2012 18:40:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v2] mfd: asic3: Avoid unbalanced irq wakeup
 enables/disables
Message-ID: <20120416164014.GO24130@sortiz-mobl>
References: <1334100934.85623.YahooMailClassic@web29003.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334100934.85623.YahooMailClassic@web29003.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Apr 11, 2012 at 12:35:34AM +0100, Paul Parsons wrote:
> The mfd/asic3 driver does not currently define a irq_set_wake() handler.
> Consequently any attempt to configure the 3 ASIC3 GPIO buttons - RECORD,
> CALENDAR, HOME - as wakeup sources results in Unbalanced IRQ warnings
> when the system is woken from sleep mode:
> 
> WARNING: at kernel/irq/manage.c:520 irq_set_irq_wake+0xc4/0xf8()
> Unbalanced IRQ 342 wake disable
> ...
> WARNING: at kernel/irq/manage.c:520 irq_set_irq_wake+0xc4/0xf8()
> Unbalanced IRQ 337 wake disable
> ...
> WARNING: at kernel/irq/manage.c:520 irq_set_irq_wake+0xc4/0xf8()
> Unbalanced IRQ 339 wake disable
> ...
> 
> This patch adds a irq_set_wake() handler to the mfd/asic3 driver.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> ---
> 
> V2:
> This patch now adds asic3_gpio_irq_set_wake() to mfd/asic3 instead of
> disabling the 3 ASIC3 GPIO buttons as wakeup sources in pxa/hx4700.
> This patch now submitted to linux-kernel instead of linux-arm-kernel.
> Rebased from linux-2.6.39-rc6 to linux-3.4-rc2.
Thanks, patch applied as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
