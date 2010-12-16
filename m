Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab0LPVor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:44:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59828 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0LPVop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:44:45 -0500
Date: Thu, 16 Dec 2010 21:44:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v5 5/5] msm: add SMP support for msm
Message-ID: <20101216214420.GX9937@n2100.arm.linux.org.uk>
References: <1292482456-22690-1-git-send-email-johlstei@codeaurora.org> <1292482456-22690-6-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292482456-22690-6-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:54:16PM -0800, Jeff Ohlstein wrote:
> +void __cpuinit platform_secondary_init(unsigned int cpu)
> +{
> +	/* Configure edge-triggered PPIs */
> +	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);

At some point we should really clean this up so we don't have code
writing directly to the GIC registers like this.

> +static __init void prepare_cold_cpu(unsigned int cpu)
> +{
> +	int ret;
> +	ret = scm_set_boot_addr((void *)
> +				virt_to_phys(msm_secondary_startup),

It seems wrong to cast a physical address to a pointer - physical
addresses should not be pointer-like.  Can it stay as an integer?

