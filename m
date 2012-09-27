Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2I0OIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:08:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57736 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab2I0OIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:08:46 -0400
Date: Thu, 27 Sep 2012 15:08:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, marex@denx.de, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix request_threaded_irq() parameter
Message-ID: <20120927140843.GX4428@opensource.wolfsonmicro.com>
References: <1348718135-10300-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348718135-10300-1-git-send-email-festevam@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 12:55:35AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> On a mx53qsb dt-kernel the da9052-core driver fails to probe:
> 
> da9052 1-0048: DA9052 ADC IRQ failed ret=-22
> 
> In request_threaded_irq() the first parameter is missing the da9052->irq_base.
> 
> Fix it and avoid the error.

The driver shouldn't be relying on irq_base at all, it should use
regmap_get_virq() to look up the interrupt number.  If it relies on
irq_base then the user is forced to assign one (or rely on automatic
assignment, which is a bit erratic.  Otherwise it can use a linear
domain which doesn't rely on being able to allocate a big block of
interrupt numbers.
