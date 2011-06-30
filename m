Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1F3NMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:12:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39482 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1F3NMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:12:13 -0400
Date: Thu, 30 Jun 2011 14:11:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] arm: platsmp: Allow secondary cpu hotplug with
	maxcpus=1
Message-ID: <20110630131154.GJ23312@n2100.arm.linux.org.uk>
References: <1309372300-28911-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309372300-28911-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:31:39AM -0700, Stephen Boyd wrote:
>  void __init platform_smp_prepare_cpus(unsigned int max_cpus)
>  {
> -	int i;
> -
>  	/*
>  	 * Initialise the present map, which describes the set of CPUs
>  	 * actually populated at the present time.
>  	 */
> -	for (i = 0; i < max_cpus; i++)
> -		set_cpu_present(i, true);
> +	init_cpu_present(&cpu_possible_map);

Ok, if we're now doing this in every platform, it might as well go into
arch/arm/kernel/smp.c - platforms can re-initialize the present map
in this callback if they need to do something different.
