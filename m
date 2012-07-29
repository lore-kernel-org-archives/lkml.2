Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2G2Ui5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:38:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46491 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab2G2Ui4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:38:56 -0400
Date: Sun, 29 Jul 2012 21:38:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: arizona: convert to regmap_add_irq_chips
Message-ID: <20120729203854.GF4384@opensource.wolfsonmicro.com>
References: <1343415776-27176-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343415776-27176-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:02:56PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The Arizona chip contains a single interrupt that represents the unified
> output of multiple internal interrupt controllers. This pattern has been
> factored out into regmap-irq, so convert the Arizona driver to use the
> new regmap-irq code.

So, I didn't like the patch this depends on but anyway..

> 1) regmap_add_irq_chips() calls regmap_add_irq_chip() with irq==0 rather
>    than -1, so in turn irq_domain_add_linear() is called rather than
>    irq_domain_add_legacy(). This change could be avoided by providing an
>    irq_bases array to regmap_add_irq_chips().

This is a problem.

> 2) regmap_add_irq_chips() requests the top-level interrupt itself, so this
>    happens before the Arizona driver hooks the child BOOT_DONE and
>    CTRLIF_ERR interrupts. In the original, all the IRQ chips were created
>    first, and then the top-level IRQ was requested. This may cause a
>    functional difference if those interrupts are pending at probe() time.

Boot done is very likely to be asserted.
