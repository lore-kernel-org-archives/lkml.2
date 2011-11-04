Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1KDX17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:27:59 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45644 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1KDX15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:27:57 -0400
From: Kevin Hilman <khilman@ti.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lm <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] OMAP3/4: iommu: adapt to runtime pm
Organization: Texas Instruments, Inc.
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-5-git-send-email-omar.ramirez@ti.com>
Date: Fri, 04 Nov 2011 16:27:53 -0700
In-Reply-To: <1320185752-568-5-git-send-email-omar.ramirez@ti.com> (Omar
	Ramirez Luna's message of "Tue, 1 Nov 2011 17:15:52 -0500")
Message-ID: <87obwr1n9i.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Omar Ramirez Luna <omar.ramirez@ti.com> writes:

> Use runtime PM functionality interfaced with hwmod enable/idle
> functions, to replace direct clock operations, reset and sysconfig
> handling.
>
> Tidspbridge uses a macro removed with this patch, for now the value
> is hardcoded to avoid breaking compilation.
>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>

Looks like a good cleanup.

I agree with the comments from Myungjoo, and have a question below..

[...]

> @@ -821,9 +820,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
>  	if (!obj->refcount)
>  		return IRQ_NONE;
>  
> -	clk_enable(obj->clk);
>  	errs = iommu_report_fault(obj, &da);
> -	clk_disable(obj->clk);
>  	if (errs == 0)
>  		return IRQ_HANDLED;

I'm not terribly familiar with this IOMMU code, but this one looks
suspiciou because you're removing the clock calls but not replacing them
with runtime PM get/put calls.

I just want to make sure that's intentional.  If so, you might want to
add a comment about that to the changelog.

Kevin


