Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2KGOx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:53:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48132 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab2KGOxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:53:55 -0500
Date: Wed, 7 Nov 2012 08:53:52 -0600
From: Nishanth Menon <nm@ti.com>
To: Joshua Emele <jemele@gmail.com>
CC: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-omap@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] cpufreq: OMAP: if an iva clock name is specified,
 load iva resources
Message-ID: <20121107145352.GA15742@kahuna>
References: <1352252861-18384-1-git-send-email-jemele@gmail.com>
 <1352252861-18384-2-git-send-email-jemele@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1352252861-18384-2-git-send-email-jemele@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:47-20121106, Joshua Emele wrote:
> +static int __cpuinit omap_iva_init(struct cpufreq_policy *policy)
> +{
> +	int result;
> +	if (!iva_clk_name) {
> +		pr_info("%s: iva unavailable\n", __func__);
> +		return 0;
> +	}
> +	iva_dev = omap_device_get_by_hwmod_name("iva");

NAK. Reasons as follows:
a) cpufreq is purely meant for cpu, not IVA. we should instead be using
devfreq which is designed around the usage for co-processor
b) clubbing ARM's frequency decision is definitely NOT equal to IVA
frequency decision, not only is it wrong in terms of modularization, it
is wrong in terms of power benefits as well (not to mention weirdness
needed when you look at all OMAP SoC variants)
c) DVFS is not trivial around multiple co-processor transitions -> core
OPPs (as dependent OPP) needs to be addressed as well. ideally common
clock framework could take care of clock dependencies.

-- 
Regards,
Nishanth Menon
