Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3ACHfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:35:48 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:50667 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:35:45 -0500
Date: Wed, 2 Jan 2013 23:35:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] timer: vt8500: Move system timer to clocksource
Message-ID: <20130103073540.GB11309@core.coreip.homeip.net>
References: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
 <1357183510-8476-2-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357183510-8476-2-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:25:09PM +1300, Tony Prisk wrote:
> +static void __init vt8500_timer_init(void)
> +{
> +	struct device_node *np;
> +	int timer_irq;
> +
> +	np = of_find_matching_node(NULL, vt8500_timer_ids);
> +	if (!np) {
> +		pr_err("%s: Timer description missing from Device Tree\n",
> +								__func__);
> +		return;
> +	}
> +	regbase = of_iomap(np, 0);
> +	if (!regbase) {
> +		pr_err("%s: Missing iobase description in Device Tree\n",
> +								__func__);
> +		of_node_put(np);
> +		return;
> +	}
> +	timer_irq = irq_of_parse_and_map(np, 0);
> +	if (!timer_irq) {
> +		pr_err("%s: Missing irq description in Device Tree\n",
> +								__func__);
> +		of_node_put(np);
> +		return;

You are forgetting to unmap the regbase here.

Thanks.

-- 
Dmitry
