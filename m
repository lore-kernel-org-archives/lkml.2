Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2EDKhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:37:55 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47255 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635Ab2EDKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:37:53 -0400
Message-ID: <4FA3B182.5060001@ti.com>
Date: Fri, 04 May 2012 13:37:54 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com> <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com> <20120503132004.GB14296@sirena.org.uk> <4FA2881B.6010902@ti.com> <20120503145248.GJ3955@opensource.wolfsonmicro.com> <4FA2A08C.5000403@ti.com> <20120503152643.GM3955@opensource.wolfsonmicro.com> <4FA3958A.4080206@ti.com> <20120504090856.GA14230@opensource.wolfsonmicro.com>
In-Reply-To: <20120504090856.GA14230@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 12:08 PM, Mark Brown wrote:
> You're not understanding the issue at all - the issue is that if
> some driver outside the twl6040 driver is using an interrupt in that
> range based off the irq_base that they supplied then you'll break them.
> The most common case here is using GPIOs on the device as interrupts.

The OMAP platform related drives has been already converted to use
irq_alloc_descs(-1, 0, nr_irqs, 0); to map their range (including GPIO,
twl6030, etc).
Neither of these are using or have irq_base passed from board files for
some time now. We still have the defines for the legacy define based
mapping of the ranges, but it is no longer in use.
To be fair: in arch/arm/mach-omap2/ there's one driver which has not
been converted. It is the gpmc (Flash).

> If this is safe you should at least be making it clear why...

I'll add short explanation to the commit message.

-- 
Péter
