Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1CYHbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:31:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45142 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1CYHbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:31:00 -0400
Date: Fri, 25 Mar 2011 08:30:54 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv6 4/4] ARM: mx51: Add support for low power suspend on
 MX51
Message-ID: <20110325073054.GE7285@pengutronix.de>
References: <1300915676-10359-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300915676-10359-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1300915676-10359-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1300915676-10359-4-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300915676-10359-4-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:28:14 up 20:47, 11 users,  load average: 0.04, 0.09, 0.08
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 04:27:56PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Adds initial low power suspend functionality to MX51.
> Supports "mem" and "standby" modes.
> 
> +
> +static int __init mx5_pm_init(void)
> +{
> +	if (gpc_dvfs_clk == NULL)
> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
> +
> +	if (!IS_ERR(gpc_dvfs_clk)) {
> +		if (cpu_is_mx51())
> +			suspend_set_ops(&mx5_suspend_ops);
> +	} else {
> +		printk(KERN_ERR "Cannot enter SRPG suspend -no gpc_dvfs clock!\n");
> +		return -EPERM;

This will print a warning on every non i.MX51 machine, not a good idea.
Please just bail out early on irrelevant machines.

Sascha

> +	}
> +
> +	return 0;
> +}
> +device_initcall(mx5_pm_init);
> -- 
> 1.6.0.4
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
