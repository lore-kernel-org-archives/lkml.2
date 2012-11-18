Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2KRObM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:31:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50300 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2KRObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:31:08 -0500
Message-ID: <50A8F0DF.8040509@gmail.com>
Date: Sun, 18 Nov 2012 15:29:51 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: "hongbo.zhang" <hongbo.zhang@linaro.org>, linaro-kernel@lists.linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: Re: [PATCH V6 1/2] Thermal: Add ST-Ericsson DB8500 thermal driver.
References: <1352977003-25095-1-git-send-email-hongbo.zhang@linaro.com> <1352977003-25095-2-git-send-email-hongbo.zhang@linaro.com> <1352983878.2080.25.camel@rzhang1-mobl4>
In-Reply-To: <1352983878.2080.25.camel@rzhang1-mobl4>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 01:51 PM, Zhang Rui wrote:
> On Thu, 2012-11-15 at 18:56 +0800, hongbo.zhang wrote:
>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>
>> This driver is based on the thermal management framework in thermal_sys.c. A
>> thermal zone device is created with the trip points to which cooling devices
>> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
>> clipped down to cool the CPU, and other cooling devices can be added and bound
>> to the trip points dynamically.  The platform specific PRCMU interrupts are
>> used to active thermal update when trip points are reached.
>>
>> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
>> Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>
> 
> Patch is refreshed and applied to thermal next.
> refreshed patch attached.
[...]
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 99b6587..d96da07 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -101,5 +101,25 @@ config EXYNOS_THERMAL
>  	  If you say yes here you get support for TMU (Thermal Managment
>  	  Unit) on SAMSUNG EXYNOS series of SoC.
>  
> +config DB8500_THERMAL
> +	bool "DB8500 thermal management"
> +	depends on ARCH_U8500

Shouldn't it depend on THERMAL as well, as in Hongbo's original patch?

> +	default y
> +	help
> +	  Adds DB8500 thermal management implementation according to the thermal
> +	  management framework. A thermal zone with several trip points will be
> +	  created. Cooling devices can be bound to the trip points to cool this
> +	  thermal zone if trip points reached.
> +
> +config DB8500_CPUFREQ_COOLING
> +	tristate "DB8500 cpufreq cooling"
> +	depends on ARCH_U8500
> +	depends on CPU_THERMAL
> +	default y
> +	help
> +	  Adds DB8500 cpufreq cooling devices, and these cooling devices can be
> +	  bound to thermal zone trip points. When a trip point reached, the
> +	  bound cpufreq cooling device turns active to set CPU frequency low to
> +	  cool down the CPU.
>  
>  endif

--
Francesco
