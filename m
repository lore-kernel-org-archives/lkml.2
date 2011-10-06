Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab1JFPTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:19:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34207 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756361Ab1JFPTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:19:40 -0400
Message-ID: <1317914379.10495.5.camel@Joe-Laptop>
Subject: Re: [PATCH] omap: dmtimer: convert printk to pr_*
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?V=EDctor?= Manuel =?ISO-8859-1?Q?J=E1quez?=
	 Leal <vjaquez@igalia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Timo Teras <timo.teras@solidboot.com>,
        Harvey Harrison <harvey.harrison@gmail.com>
Date: Thu, 06 Oct 2011 08:19:39 -0700
In-Reply-To: <1317898106-1891-1-git-send-email-vjaquez@igalia.com>
References: <1317898106-1891-1-git-send-email-vjaquez@igalia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 12:48 +0200, Víctor Manuel Jáquez Leal wrote:
> Convert all the printk(<level>) messages in the driver to pr_<level>().
[]
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
[]
> @@ -397,8 +397,7 @@ struct omap_dm_timer *omap_dm_timer_request_specific(int id)
>  	spin_lock_irqsave(&dm_timer_lock, flags);
>  	if (id <= 0 || id > dm_timer_count || dm_timers[id-1].reserved) {
>  		spin_unlock_irqrestore(&dm_timer_lock, flags);
> -		printk("BUG: warning at %s:%d/%s(): unable to get timer %d\n",
> -		       __FILE__, __LINE__, __func__, id);
> +		pr_warning("unable to get timer %d\n", id);

For new conversions, please use pr_warn not pr_warning.
It's shorter and similar to other dev_warn/netdev_warn
uses.

>  		dump_stack();

To emit a message then dump stack, please use
	WARN(1, fmt, ...)


