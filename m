Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913Ab1JGJXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:23:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33960 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684Ab1JGJXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:23:19 -0400
Date: Fri, 7 Oct 2011 10:22:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?V=EDctor_Manuel_J=E1quez?= Leal 
	<vjaquez@igalia.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Timo Teras <timo.teras@solidboot.com>
Subject: Re: [PATCH v3] omap: dmtimer: convert printk to pr_err
Message-ID: <20111007092243.GC27281@n2100.arm.linux.org.uk>
References: <20111006201827.GT6324@atomide.com> <1317977417-17874-1-git-send-email-vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317977417-17874-1-git-send-email-vjaquez@igalia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:50:16AM +0200, Víctor Manuel Jáquez Leal wrote:
> Convert a printk(KERN_ERR) message in the driver to pr_err().
...
> @@ -111,7 +111,7 @@ static void omap_dm_timer_wait_for_reset(struct omap_dm_timer *timer)
>  	while (!(__raw_readl(timer->sys_stat) & 1)) {
>  		c++;
>  		if (c > 100000) {
> -			printk(KERN_ERR "Timer failed to reset\n");
> +			pr_err("Timer failed to reset\n");

What is the reason behind this change?  It looks like it's to use the
latest and greatest function.

If so, please don't make these changes - we have on many occasions been
blamed for size of diffstat, churn, needless change, and this patch is
exactly that.

By all means fix printk's without KERN_ constants, possibly converting
them to pr_*, but don't go around replacing printk(KERN_* with pr_*(
without ensuring that there's a real benefit to the change.
