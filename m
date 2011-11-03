Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1KCATI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:19:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab1KCATH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:19:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: PM / OPP: Fix build when CONFIG_PM_OPP is not set
Date: Thu, 3 Nov 2011 01:21:42 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, Kevin Hilman <khilman@ti.com>
References: <20111102170055.GI31337@atomide.com>
In-Reply-To: <20111102170055.GI31337@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030121.42432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 02, 2011, Tony Lindgren wrote:
> Commit 03ca370fbf7b76d6d002380dbdc2cdc2319f9c80 (PM / OPP: Add
> OPP availability change notifier) does not compile if CONFIG_PM_OPP
> is not set:
> 
> arch/arm/plat-omap/omap-pm-noop.o: In function `opp_get_notifier':
> include/linux/opp.h:103: multiple definition of `opp_get_notifier'
> include/linux/opp.h:103: first defined here
> 
> Also fix incorrect comment.
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Mike Turquette <mturquette@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
> I'm seeing this with omap1_defconfig at least.
> 
> --- a/include/linux/opp.h
> +++ b/include/linux/opp.h
> @@ -97,11 +97,11 @@ static inline int opp_disable(struct device *dev, unsigned long freq)
>  	return 0;
>  }
>  
> -struct srcu_notifier_head *opp_get_notifier(struct device *dev)
> +static inline struct srcu_notifier_head *opp_get_notifier(struct device *dev)
>  {
>  	return ERR_PTR(-EINVAL);
>  }
> -#endif		/* CONFIG_PM */
> +#endif		/* CONFIG_PM_OPP */
>  
>  #if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
>  int opp_init_cpufreq_table(struct device *dev,
> 
> 

