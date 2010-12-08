Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0LHPRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:17:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54991 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab0LHPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:17:11 -0500
Date: Wed, 8 Dec 2010 15:14:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v2 5/6] msm: hotplug: support cpu hotplug on msm
Message-ID: <20101208151451.GG9777@n2100.arm.linux.org.uk>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-6-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291782501-3909-6-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:28:20PM -0800, Jeff Ohlstein wrote:
> +static DECLARE_COMPLETION(cpu_killed);

There's changes in my tree for 2.6.38 which gets rid of this completion
from platform code.

> +void platform_cpu_die(unsigned int cpu)
> +{
> +#ifdef DEBUG
> +	unsigned int this_cpu = hard_smp_processor_id();
> +
> +	if (cpu != this_cpu) {
> +		printk(KERN_CRIT "Eek! platform_cpu_die running on %u, should be %u\n",
> +			   this_cpu, cpu);
> +		BUG();
> +	}
> +#endif

This debug check can not possibly ever happen; it can be removed.

> +
> +	printk(KERN_NOTICE "CPU%u: shutdown\n", cpu);

This printk is not required with those changes I mentioned above.

