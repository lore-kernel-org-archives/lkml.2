Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2KSAmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:42:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:39993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab2KSAmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:42:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,275,1352102400"; 
   d="scan'208";a="169934834"
Message-ID: <1353285765.2204.2.camel@rzhang1-mobl4>
Subject: Re: [PATCH V6 1/2] Thermal: Add ST-Ericsson DB8500 thermal driver.
From: Zhang Rui <rui.zhang@intel.com>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: "hongbo.zhang" <hongbo.zhang@linaro.org>, linaro-kernel@lists.linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Date: Mon, 19 Nov 2012 08:42:45 +0800
In-Reply-To: <50A8F0DF.8040509@gmail.com>
References: <1352977003-25095-1-git-send-email-hongbo.zhang@linaro.com>
	 <1352977003-25095-2-git-send-email-hongbo.zhang@linaro.com>
	 <1352983878.2080.25.camel@rzhang1-mobl4> <50A8F0DF.8040509@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-18 at 15:29 +0100, Francesco Lavra wrote:
> On 11/15/2012 01:51 PM, Zhang Rui wrote:
> > On Thu, 2012-11-15 at 18:56 +0800, hongbo.zhang wrote:
> >> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> >>
> >> This driver is based on the thermal management framework in thermal_sys.c. A
> >> thermal zone device is created with the trip points to which cooling devices
> >> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
> >> clipped down to cool the CPU, and other cooling devices can be added and bound
> >> to the trip points dynamically.  The platform specific PRCMU interrupts are
> >> used to active thermal update when trip points are reached.
> >>
> >> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> >> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> >> Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>
> > 
> > Patch is refreshed and applied to thermal next.
> > refreshed patch attached.
> [...]
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index 99b6587..d96da07 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -101,5 +101,25 @@ config EXYNOS_THERMAL
> >  	  If you say yes here you get support for TMU (Thermal Managment
> >  	  Unit) on SAMSUNG EXYNOS series of SoC.
> >  
> > +config DB8500_THERMAL
> > +	bool "DB8500 thermal management"
> > +	depends on ARCH_U8500
> 
> Shouldn't it depend on THERMAL as well, as in Hongbo's original patch?
> 
all of these options are available only if CONFIG_THERMAL is set.
please refer to commit 72e198978223f2020f7f59a6e2520f2b7d005e72 in the
thermal next tree.

thanks,
rui
> > +	default y
> > +	help
> > +	  Adds DB8500 thermal management implementation according to the thermal
> > +	  management framework. A thermal zone with several trip points will be
> > +	  created. Cooling devices can be bound to the trip points to cool this
> > +	  thermal zone if trip points reached.
> > +
> > +config DB8500_CPUFREQ_COOLING
> > +	tristate "DB8500 cpufreq cooling"
> > +	depends on ARCH_U8500
> > +	depends on CPU_THERMAL
> > +	default y
> > +	help
> > +	  Adds DB8500 cpufreq cooling devices, and these cooling devices can be
> > +	  bound to thermal zone trip points. When a trip point reached, the
> > +	  bound cpufreq cooling device turns active to set CPU frequency low to
> > +	  cool down the CPU.
> >  
> >  endif
> 
> --
> Francesco


