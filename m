Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2JaGpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:45:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:22950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2JaGpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="162728154"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>
Subject: RE: [PATCH v2] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Thread-Topic: [PATCH v2] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Thread-Index: AQHNtx7n+YMSf3Woz0ObGln8lMi8pJfS7v4Q
Date: Wed, 31 Oct 2012 06:45:08 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591FDE36@BGSMSX101.gar.corp.intel.com>
References: <1351657147-26092-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1351657147-26092-1-git-send-email-jonghwa3.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like a nice feature :-)
Without something like this, we had been spending time on
writing test drivers, to actually test our thermal framework code.

BTW, against which tree this patch was generated ?
Rui's -next or master or Linux-next ?

Some comments below, on a quick glance..

> -----Original Message-----
> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
> Sent: Wednesday, October 31, 2012 9:49 AM
> To: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Brown, Len; R, Durgadoss; Rafael J.
> Wysocki; Amit Dinel Kachhap; Jonghwa Lee
> Subject: [PATCH v2] Thermal: exynos: Add sysfs node supporting exynos's
> emulation mode.
> 
> This patch supports exynos's emulation mode with newly created sysfs node.
> Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
> management unit. Thermal emulation mode supports software debug for
> TMU's
> operation. User can set temperature manually with software code and TMU
> will read current temperature from user value not from sensor's value.
> This patch includes also documentary placed under
> Documentation/thermal/.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
> v2
>  exynos_thermal.c
>  - Fix build error occured by wrong emulation control register name.
>  - Remove exynos5410 dependent codes.
>  exynos_theraml_emulation
>  - Align indentation.
> 
>  Documentation/thermal/exynos_thermal_emulation |   49 +++++++++++++
>  drivers/thermal/Kconfig                        |    9 +++
>  drivers/thermal/exynos_thermal.c               |   88
> ++++++++++++++++++++++++
>  3 files changed, 146 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/thermal/exynos_thermal_emulation
> 
> diff --git a/Documentation/thermal/exynos_thermal_emulation
> b/Documentation/thermal/exynos_thermal_emulation
> new file mode 100644
> index 0000000..062d867
> --- /dev/null
> +++ b/Documentation/thermal/exynos_thermal_emulation
> @@ -0,0 +1,49 @@
> +EXYNOS EMULATION MODE
> +========================
> +
> +Copyright (C) 2012 Samsung Electronics
> +
> +Writen by Jonghwa Lee <jonghwa3.lee@samsung.com>
> +
> +Description
> +-----------
> +
> +Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
> management unit.
> +Thermal emulation mode supports software debug for TMU's operation.
> User can set temperature
> +manually with software code and TMU will read current temperature from
> user value not from
> +sensor's value.
> +
> +Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support
> in available.
> +When it's enabled, sysfs node will be created under
> +/sys/bus/platform/devices/'exynos device name'/ with name of
> 'emulation'.
> +
> +The sysfs node, 'emulation', will contain value 0 for the initial state. When
> you input any
> +temperature you want to update to sysfs node, it automatically enable
> emulation mode and
> +current temperature will be changed into it.
> +(Exynos also supports user changable delay time which would be used to
> delay of
> + changing temperature. However, this node only uses same delay of real
> sensing time, 938us.)
> +
> +Disabling emulation mode only requires writing value 0 to sysfs node.
> +
> +
> +TEMP	120 |
> +	    |
> +	100 |
> +	    |
> +	 80 |
> +	    |		     	 	 +-----------
> +	 60 |      		     	 |	    |
> +	    |	           +-------------|          |
> +	 40 |              |         	 |          |
> +   	    |		   |	     	 |          |
> +	 20 |		   |	     	 |          +----------
> +	    |	 	   |	     	 |          |          |
> +  	  0
> |______________|_____________|__________|__________|_______
> __
> +		   A	    	 A	    A	   	       A     TIME
> +		   |<----->|	 |<----->|  |<----->|	       |
> +		   | 938us |  	 |	 |  |       |          |
> +emulation    :  0  50	   |  	 70      |  20      |          0
> +current temp :   sensor   50		 70         20	      sensor

Thanks for the documentation. Is there a publicly available data sheet for this?
If so, please provide the link here.

> +
> +
> +
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index e1cb6bd..c02a66c 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -55,3 +55,12 @@ config EXYNOS_THERMAL
>  	help
>  	  If you say yes here you get support for TMU (Thermal Managment
>  	  Unit) on SAMSUNG EXYNOS series of SoC.
> +
> +config EXYNOS_THERMAL_EMUL
> +	bool "EXYNOS TMU emulation mode support"
> +	depends on !CPU_EXYNOS4210 && EXYNOS_THERMAL
> +	help
> +	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
> +	  Enable this option will be make sysfs node in exynos thermal
> platform
> +	  device directory to support emulation mode. With emulation mode
> sysfs
> +	  node, you can manually input temperature to TMU for simulation
> purpose.
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index fd03e85..9e3c150 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -99,6 +99,15 @@
>  #define IDLE_INTERVAL 10000
>  #define MCELSIUS	1000
> 
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +#define EXYNOS_EMUL_TIME	0x57F0
> +#define EXYNOS_EMUL_TIME_SHIFT	16
> +#define EXYNOS_EMUL_DATA_SHIFT	8
> +#define EXYNOS_EMUL_DATA_MASK	0xFF
> +#define EXYNOS_EMUL_DISABLE	0x0
> +#define EXYNOS_EMUL_ENABLE	0x1
> +#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
> +
>  /* CPU Zone information */
>  #define PANIC_ZONE      4
>  #define WARN_ZONE       3
> @@ -832,6 +841,82 @@ static inline struct  exynos_tmu_platform_data
> *exynos_get_driver_data(
>  	return (struct exynos_tmu_platform_data *)
>  			platform_get_device_id(pdev)->driver_data;
>  }
> +
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +static ssize_t exynos_tmu_emulation_show(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +					struct platform_device, dev);
> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +	unsigned int reg;
> +	u8 temp_code;
> +	int temp, enable;
> +
> +	mutex_lock(&data->lock);
> +	clk_enable(data->clk);
> +	reg = readl(data->base + EXYNOS_EMUL_CON);
> +	clk_disable(data->clk);
> +	mutex_unlock(&data->lock);
> +
> +	enable = reg & EXYNOS_EMUL_ENABLE;

Looks like we don't need this variable 'enable'.
Also, initialize temp to 0 in the beginning, which will save the
else part of the code.

> +
> +	if (enable) {
> +		reg >>= EXYNOS_EMUL_DATA_SHIFT;
> +		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
> +		temp = code_to_temp(data, temp_code);
> +	} else {
> +		temp = 0;
> +	}
> +
> +	return sprintf(buf, "%d\n", temp);
> +}
> +
> +static ssize_t exynos_tmu_emulation_store(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +					struct platform_device, dev);
> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +	unsigned int reg;
> +	u8 temp_code;
> +	int temp, enable, i;
> +
> +	if (!sscanf(buf, "%d\n", &temp))
> +		return -EINVAL;
> +
> +	if (temp < 0)
> +		return -EINVAL;

Why not combine both the if s using || ?

> +
> +	mutex_lock(&data->lock);
> +	clk_enable(data->clk);
> +
> +	reg = readl(data->base + EXYNOS_EMUL_CON);
> +	enable = reg & EXYNOS_EMUL_ENABLE;
> +	if (!enable && !temp)
> +		goto out;

I think you what you are trying to do here is this:
If the emulation is already disabled, and 'this' write tries to
disable it again, you jump to 'out' as an optimization.
Please correct me if I am wrong.

In this case, name the variable is_enabled or something like
that, which makes the check more explicit.

> +
> +	temp_code = (reg >> EXYNOS_EMUL_DATA_SHIFT) &
> EXYNOS_EMUL_DATA_MASK;
> +	temp_code = temp == 0 ? temp_code : temp_to_code(data, temp);
> +
> +	reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
> +		(temp_code << EXYNOS_EMUL_DATA_SHIFT) |
> +		 (temp > 0 ? EXYNOS_EMUL_ENABLE :
> EXYNOS_EMUL_DISABLE);

2 things here:
1. Can we make the temp > 0 comparison as a separate statement, so that
it is easy to read/maintain ?

2. you are comparing temp > 0 here, but above you return when temp < 0.
Looks like, in this case, the flow will never reach here, when temp < 0.

> +
> +	writel(reg, data->base + EXYNOS_EMUL_CON);
> +out:
> +	clk_disable(data->clk);
> +	mutex_unlock(&data->lock);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
> +					exynos_tmu_emulation_store);
> +#endif
> +
>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data;
> @@ -930,6 +1015,9 @@ static int __devinit exynos_tmu_probe(struct
> platform_device *pdev)
>  		dev_err(&pdev->dev, "Failed to register thermal
> interface\n");
>  		goto err_clk;
>  	}
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +	device_create_file(&pdev->dev, &dev_attr_emulation);

Don't we want to capture the return value here ?
Also, if we conditionally create this, we should remove this conditionally also.
I did not see a corresponding device_remove_file for this attr.

> +#endif

Can we club all the code inside CONFIG_*_EMUL at one place ?
This will make it neat, and not spread the #ifdefs all over the driver.

Thanks,
Durga
