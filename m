Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2KAIKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 04:10:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63223 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2KAIKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 04:10:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fa66d0000004cf-4d-50922e5aa625
Message-id: <50922E59.6080000@samsung.com>
Date: Thu, 01 Nov 2012 17:10:01 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>
Subject: Re: [PATCH v3] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
References: <1351677237-18240-1-git-send-email-jonghwa3.lee@samsung.com>
 <4D68720C2E767A4AA6A8796D42C8EB591FF32C@BGSMSX101.gar.corp.intel.com>
In-reply-to: <4D68720C2E767A4AA6A8796D42C8EB591FF32C@BGSMSX101.gar.corp.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jQd0ovUkBBh/XGVhc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJOP33FUrDPruLu5auMDYxTDboYOTkkBEwkHu1bxQxh
	i0lcuLeerYuRi0NIYDqjxLNTu1hBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6
	l4wS/7oPQtVrSeza94QdxGYRUJX4vuQyE4jNJiAn8bbpGyPIHFGBCIlf/RwgYRGg8vYdOxlB
	5jALzGWSOHRiKdhBwgKxEo/fzGaHWDCBUeLlx49ggzgFQiS6zt9jm8AoMAvJfbMQ7puF5L4F
	jMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJD8ZnUDsaVDRaHGAU4GJV4eA1LJwYIsSaW
	FVfmHmKU4GBWEuF93A0U4k1JrKxKLcqPLyrNSS0+xCjNwaIkztvskRIgJJCeWJKanZpakFoE
	k2Xi4JRqYHRWv2FidzWLd3m+wD7t71rWpSq/uZqddV1O/133Q/X780Ulop97JYPYT0T9b8jf
	dv72XsM5BeqHm/dGciw7ve86o+iNaVfncMr8X5H6qkagKv3Xx339IZ7KKpcr48tkLW2eKTzz
	Uzila7HuYcmxKkt2geuJ4Wxpd/qKTvuEvLlioL1P/H9ClxJLcUaioRZzUXEiAB91NaxBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2012년 11월 01일 16:56, R, Durgadoss wrote:
> Hi,
>
>> +++ b/Documentation/thermal/exynos_thermal_emulation
>> @@ -0,0 +1,49 @@
>> +EXYNOS EMULATION MODE
>> +========================
>> +
>> +Copyright (C) 2012 Samsung Electronics
>> +
>> +Writen by Jonghwa Lee <jonghwa3.lee@samsung.com>
> s/Writen/Written

Oops, Sorry ^^;

>> +
>> +Description
>> +-----------
>> +
>> +Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
>> management unit.
>> +Thermal emulation mode supports software debug for TMU's operation.
>> User can set temperature
>> +manually with software code and TMU will read current temperature from
>> user value not from
>> +sensor's value.
>> +
>> +Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support
>> in available.
>> +When it's enabled, sysfs node will be created under
>> +/sys/bus/platform/devices/'exynos device name'/ with name of
>> 'emulation'.
>> +
>> +The sysfs node, 'emulation', will contain value 0 for the initial state. When
>> you input any
>> +temperature you want to update to sysfs node, it automatically enable
>> emulation mode and
>> +current temperature will be changed into it.
>> +(Exynos also supports user changable delay time which would be used to
>> delay of
>> + changing temperature. However, this node only uses same delay of real
>> sensing time, 938us.)
>> +
>> +Disabling emulation mode only requires writing value 0 to sysfs node.
> This documentation looks fine. As a reply to one of the comments in the
> previous version, you gave me an explanation. Could you please add that
> explanation here as well ? I think that would help all of us, after this
> patch set gets merged..

Okay, I'll add that comments to the next patch.

>> +
>> +
>> +TEMP	120 |
>> +	    |
>> +	100 |
>> +	    |
>> +	 80 |
>> +	    |		     	 	 +-----------
>> +	 60 |      		     	 |	    |
>> +	    |	           +-------------|          |
>> +	 40 |              |         	 |          |
>> +   	    |		   |	     	 |          |
>> +	 20 |		   |	     	 |          +----------
>> +	    |	 	   |	     	 |          |          |
>> +  	  0
>> |______________|_____________|__________|__________|_______
>> __
>> +		   A	    	 A	    A	   	       A     TIME
>> +		   |<----->|	 |<----->|  |<----->|	       |
>> +		   | 938us |  	 |	 |  |       |          |
>> +emulation    :  0 50	   |  	 70      |  20      |          0
>> +current temp :   sensor   50		 70         20	      sensor
>> +
>> +
>> +
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index e1cb6bd..c02a66c 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -55,3 +55,12 @@ config EXYNOS_THERMAL
>>  	help
>>  	  If you say yes here you get support for TMU (Thermal Managment
>>  	  Unit) on SAMSUNG EXYNOS series of SoC.
>> +
>> +config EXYNOS_THERMAL_EMUL
>> +	bool "EXYNOS TMU emulation mode support"
>> +	depends on !CPU_EXYNOS4210 && EXYNOS_THERMAL
>> +	help
>> +	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
>> +	  Enable this option will be make sysfs node in exynos thermal
>> platform
>> +	  device directory to support emulation mode. With emulation mode
>> sysfs
>> +	  node, you can manually input temperature to TMU for simulation
>> purpose.
>> diff --git a/drivers/thermal/exynos_thermal.c
>> b/drivers/thermal/exynos_thermal.c
>> index fd03e85..4bdd1eb 100644
>> --- a/drivers/thermal/exynos_thermal.c
>> +++ b/drivers/thermal/exynos_thermal.c
>> @@ -99,6 +99,14 @@
>>  #define IDLE_INTERVAL 10000
>>  #define MCELSIUS	1000
>>
>> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
>> +#define EXYNOS_EMUL_TIME	0x57F0
>> +#define EXYNOS_EMUL_TIME_SHIFT	16
>> +#define EXYNOS_EMUL_DATA_SHIFT	8
>> +#define EXYNOS_EMUL_DATA_MASK	0xFF
>> +#define EXYNOS_EMUL_ENABLE	0x1
>> +#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
>> +
>>  /* CPU Zone information */
>>  #define PANIC_ZONE      4
>>  #define WARN_ZONE       3
>> @@ -832,6 +840,84 @@ static inline struct  exynos_tmu_platform_data
>> *exynos_get_driver_data(
>>  	return (struct exynos_tmu_platform_data *)
>>  			platform_get_device_id(pdev)->driver_data;
>>  }
>> +
>> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
>> +static ssize_t exynos_tmu_emulation_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf)
>> +{
>> +	struct platform_device *pdev = container_of(dev,
>> +					struct platform_device, dev);
>> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>> +	unsigned int reg;
>> +	u8 temp_code;
>> +	int temp = 0;
>> +
>> +	mutex_lock(&data->lock);
>> +	clk_enable(data->clk);
>> +	reg = readl(data->base + EXYNOS_EMUL_CON);
>> +	clk_disable(data->clk);
>> +	mutex_unlock(&data->lock);
>> +
>> +	if (reg & EXYNOS_EMUL_ENABLE) {
>> +		reg >>= EXYNOS_EMUL_DATA_SHIFT;
>> +		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
>> +		temp = code_to_temp(data, temp_code);
>> +	} else {
>> +		temp = 0;
>> +	}
> Do we still need the else part ?
>

No, we don't. I'll remove it.

>> +
>> +	return sprintf(buf, "%d\n", temp);
>> +}
>> +
>> +static ssize_t exynos_tmu_emulation_store(struct device *dev,
>> +					struct device_attribute *attr,
>> +					const char *buf, size_t count)
>> +{
>> +	struct platform_device *pdev = container_of(dev,
>> +					struct platform_device, dev);
>> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>> +	unsigned int reg;
>> +	int temp = 0;
> Looks like we don't need to assign 0 to temp here..

Yes, you're right.

>> +
>> +	if (!sscanf(buf, "%d\n", &temp) || temp < 0)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&data->lock);
>> +	clk_enable(data->clk);
>> +
>> +	reg = readl(data->base + EXYNOS_EMUL_CON);
>> +
>> +	if (temp)
>> +		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT)
>> |
>> +			(temp_to_code(data, temp) <<
>> EXYNOS_EMUL_DATA_SHIFT) |
>> +			EXYNOS_EMUL_ENABLE;
>> +	else
>> +		reg &= ~EXYNOS_EMUL_ENABLE;
>> +
>> +	writel(reg, data->base + EXYNOS_EMUL_CON);
>> +
>> +	clk_disable(data->clk);
>> +	mutex_unlock(&data->lock);
>> +
>> +	return count;
>> +}
>> +
>> +static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
>> +					exynos_tmu_emulation_store);
>> +static int create_emulation_sysfs(struct device *dev)
>> +{
>> +	return device_create_file(dev, &dev_attr_emulation);
>> +}
>> +static void remove_emulation_sysfs(struct device *dev)
>> +{
>> +	device_remove_file(dev, &dev_attr_emulation);
>> +}
>> +#else
>> +static inline int create_emulation_sysfs(struct device *dev) {return 0;}
>> +static inline void remove_emulation_sysfs(struct device *dev){}
>> +#endif
>> +
>>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>>  {
>>  	struct exynos_tmu_data *data;
>> @@ -930,6 +1016,11 @@ static int __devinit exynos_tmu_probe(struct
>> platform_device *pdev)
>>  		dev_err(&pdev->dev, "Failed to register thermal
>> interface\n");
>>  		goto err_clk;
>>  	}
>> +
>> +	ret = create_emulation_sysfs(&pdev->dev);
>> +	if (ret)
>> +		dev_err(&pdev->dev, "Faield to create emulation mode
> s/Faield/Failed

Typo again -_-;, sorry.

>> sysfs node\n");
>> +
>>  	return 0;
>>  err_clk:
>>  	platform_set_drvdata(pdev, NULL);
>> @@ -941,6 +1032,8 @@ static int __devexit exynos_tmu_remove(struct
>> platform_device *pdev)
>>  {
>>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>>
>> +	remove_emulation_sysfs(&pdev->dev);
>> +
> Yes, this makes it cleaner.
>
>>  	exynos_tmu_control(pdev, false);
>>
>>  	exynos_unregister_thermal();
>> --
>> 1.7.4.1
Thanks for reviewing my codes.
I'll apply your comments and re-post it as soon.

Thanks,
Jonghwa.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

