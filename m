Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2IUAob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:44:31 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:60929 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab2IUAo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:44:29 -0400
Date: Fri, 21 Sep 2012 00:44:28 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: OMAP: hwmod: partially un-reset hwmods might
 not be properly enabled
In-Reply-To: <1345614150-25723-2-git-send-email-omar.luna@linaro.org>
Message-ID: <alpine.DEB.2.00.1209210042370.6888@utopia.booyaka.com>
References: <1345614150-25723-1-git-send-email-omar.luna@linaro.org> <1345614150-25723-2-git-send-email-omar.luna@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar

On Wed, 22 Aug 2012, Omar Ramirez Luna wrote:

> Some IP blocks might not be using/controlling more than one
> reset line, this check loosens the restriction to fully use
> hwmod framework for those drivers.
> 
> E.g.: ipu has reset lines: mmu_cache, cpu0 and cpu1.
> - As of now cpu1 is not used and hence (with previous check) the
>   IP block isn't fully enabled by hwmod code.
> - Usually ipu and dsp processors configure their mmu module first
>   and then enable the processors, this involves:
>     * Deasserting mmu reset line, and enabling the module.
>     * Deasserting cpu0 reset line, and enabling the processor.
>   The ones portrayed in this example are controlled through
>   rproc_fw_boot in drivers/remoteproc/remoteproc_core.c
> 
> While at it, prevent _omap4_module_disable if all the hardreset
> lines on an IP block are not under reset.
> 
> This will allow the driver to:
>   a. Deassert the reset line.
>   b. Enable the hwmod through runtime PM default callbacks.
>   c. Do its usecase.
>   d. Disable hwmod through runtime PM.
>   e. Assert the reset line.
> 
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

Well, I don't think this is the right long-term solution, but I'd like to 
see this moving forward.  So this one has been queued for 3.7.  Hopefully 
we can figure out the right thing once the PRM driver is ready (which will 
handle the low-level hard resets).


- Paul
