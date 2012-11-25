Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2KYJRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 04:17:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:55004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab2KYJRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 04:17:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,315,1352102400"; 
   d="scan'208";a="246771908"
Message-ID: <1353835050.2176.3.camel@rzhang1-mobl4>
Subject: Re: [PATCH v5] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
From: Zhang Rui <rui.zhang@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Sun, 25 Nov 2012 17:17:30 +0800
In-Reply-To: <1353472261-17430-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1353472261-17430-1-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-21 at 13:31 +0900, Jonghwa Lee wrote:
> This patch supports exynos's emulation mode with newly created sysfs node.
> Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
> management unit. Thermal emulation mode supports software debug for TMU's
> operation. User can set temperature manually with software code and TMU
> will read current temperature from user value not from sensor's value.
> This patch includes also documentary placed under Documentation/thermal/.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
output of checkpatch.pl:
 
ERROR: trailing whitespace
#162: FILE: Documentation/thermal/exynos_thermal_emulation:27:
+want to update the any value of delay or next temperature, then you
have to enable emulation $

ERROR: space required after that ';' (ctx:VxV)
#319: FILE: drivers/thermal/exynos_thermal.c:927:
+static inline int create_emulation_sysfs(struct device *dev) {return
0;}
                                                                       ^

ERROR: space required before the open brace '{'
#320: FILE: drivers/thermal/exynos_thermal.c:928:
+static inline void remove_emulation_sysfs(struct device *dev){}

total: 3 errors, 0 warnings, 198 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

/home/rzhang1/1-sysfs.mbox has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.



output of git am:

git am 0001-Thermal-exynos-Add-sysfs-node-supporting-exynos-s-em.patch
Applying: Thermal: exynos: Add sysfs node supporting exynos's emulation
mode.
/home/rzhang1/src/thermal/.git/rebase-apply/patch:58: space before tab
in indent.
   	    |		   |	     	 |          |
/home/rzhang1/src/thermal/.git/rebase-apply/patch:61: space before tab
in indent.
  	  0 |______________|_____________|__________|__________|_________
/home/rzhang1/src/thermal/.git/rebase-apply/patch:67: new blank line at
EOF.
+
warning: 3 lines add whitespace errors.

Refreshed patch with these warnings fixed attached.

>From 3d80d1134a9b228cde7a55c5f9fa273dbbae7f50 Mon Sep 17 00:00:00 2001
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
Date: Wed, 21 Nov 2012 13:31:01 +0900
Subject: [PATCH] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.

This patch supports exynos's emulation mode with newly created sysfs node.
Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
management unit. Thermal emulation mode supports software debug for TMU's
operation. User can set temperature manually with software code and TMU
will read current temperature from user value not from sensor's value.
This patch includes also documentary placed under Documentation/thermal/.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/thermal/exynos_thermal_emulation |   53 ++++++++++++
 drivers/thermal/Kconfig                        |    9 ++
 drivers/thermal/exynos_thermal.c               |  103 ++++++++++++++++++++++++
 3 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/thermal/exynos_thermal_emulation

diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
new file mode 100644
index 0000000..b73bbfb
--- /dev/null
+++ b/Documentation/thermal/exynos_thermal_emulation
@@ -0,0 +1,53 @@
+EXYNOS EMULATION MODE
+========================
+
+Copyright (C) 2012 Samsung Electronics
+
+Written by Jonghwa Lee <jonghwa3.lee@samsung.com>
+
+Description
+-----------
+
+Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal management unit.
+Thermal emulation mode supports software debug for TMU's operation. User can set temperature
+manually with software code and TMU will read current temperature from user value not from
+sensor's value.
+
+Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
+When it's enabled, sysfs node will be created under
+/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
+
+The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
+temperature you want to update to sysfs node, it automatically enable emulation mode and
+current temperature will be changed into it.
+(Exynos also supports user changable delay time which would be used to delay of
+ changing temperature. However, this node only uses same delay of real sensing time, 938us.)
+
+Exynos emulation mode requires synchronous of value changing and enabling. It means when you
+want to update the any value of delay or next temperature, then you have to enable emulation
+mode at the same time. (Or you have to keep the mode enabling.) If you don't, it fails to
+change the value to updated one and just use last succeessful value repeatedly. That's why
+this node gives users the right to change termerpature only. Just one interface makes it more
+simply to use.
+
+Disabling emulation mode only requires writing value 0 to sysfs node.
+
+
+TEMP	120 |
+	    |
+	100 |
+	    |
+	 80 |
+	    |		     	 	 +-----------
+	 60 |      		     	 |	    |
+	    |	           +-------------|          |
+	 40 |              |         	 |          |
+	    |		   |	     	 |          |
+	 20 |		   |	     	 |          +----------
+	    |	 	   |	     	 |          |          |
+	  0 |______________|_____________|__________|__________|_________
+		   A	    	 A	    A	   	       A     TIME
+		   |<----->|	 |<----->|  |<----->|	       |
+		   | 938us |  	 |	 |  |       |          |
+emulation    :  0  50	   |  	 70      |  20      |          0
+current temp :   sensor   50		 70         20	      sensor
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 8636fae..f11ae0d 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -101,6 +101,15 @@ config EXYNOS_THERMAL
 	  If you say yes here you get support for TMU (Thermal Managment
 	  Unit) on SAMSUNG EXYNOS series of SoC.
 
+config EXYNOS_THERMAL_EMUL
+	bool "EXYNOS TMU emulation mode support"
+	depends on EXYNOS_THERMAL
+	help
+	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
+	  Enable this option will be make sysfs node in exynos thermal platform
+	  device directory to support emulation mode. With emulation mode sysfs
+	  node, you can manually input temperature to TMU for simulation purpose.
+
 config DB8500_THERMAL
 	bool "DB8500 thermal management"
 	depends on ARCH_U8500
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 7772d16..e2ef8a3 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -99,6 +99,14 @@
 #define IDLE_INTERVAL 10000
 #define MCELSIUS	1000
 
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+#define EXYNOS_EMUL_TIME	0x57F0
+#define EXYNOS_EMUL_TIME_SHIFT	16
+#define EXYNOS_EMUL_DATA_SHIFT	8
+#define EXYNOS_EMUL_DATA_MASK	0xFF
+#define EXYNOS_EMUL_ENABLE	0x1
+#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
+
 /* CPU Zone information */
 #define PANIC_ZONE      4
 #define WARN_ZONE       3
@@ -832,6 +840,94 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 	return (struct exynos_tmu_platform_data *)
 			platform_get_device_id(pdev)->driver_data;
 }
+
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+static ssize_t exynos_tmu_emulation_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	unsigned int reg;
+	u8 temp_code;
+	int temp = 0;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		goto out;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+	if (reg & EXYNOS_EMUL_ENABLE) {
+		reg >>= EXYNOS_EMUL_DATA_SHIFT;
+		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
+		temp = code_to_temp(data, temp_code);
+	}
+out:
+	return sprintf(buf, "%d\n", temp * MCELSIUS);
+}
+
+static ssize_t exynos_tmu_emulation_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	unsigned int reg;
+	int temp;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		goto out;
+
+	if (!sscanf(buf, "%d\n", &temp) || temp < 0)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+
+	if (temp) {
+		/* Both CELSIUS and MCELSIUS type are available for input */
+		if (temp > MCELSIUS)
+			temp /= MCELSIUS;
+
+		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
+			(temp_to_code(data, (temp / MCELSIUS))
+			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
+	} else {
+		reg &= ~EXYNOS_EMUL_ENABLE;
+	}
+
+	writel(reg, data->base + EXYNOS_EMUL_CON);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+out:
+	return count;
+}
+
+static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
+					exynos_tmu_emulation_store);
+static int create_emulation_sysfs(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_emulation);
+}
+static void remove_emulation_sysfs(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_emulation);
+}
+#else
+static inline int create_emulation_sysfs(struct device *dev) { return 0; }
+static inline void remove_emulation_sysfs(struct device *dev) {}
+#endif
+
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
@@ -930,6 +1026,11 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to register thermal interface\n");
 		goto err_clk;
 	}
+
+	ret = create_emulation_sysfs(&pdev->dev);
+	if (ret)
+		dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
+
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -941,6 +1042,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 
+	remove_emulation_sysfs(&pdev->dev);
+
 	exynos_tmu_control(pdev, false);
 
 	exynos_unregister_thermal();
-- 
1.7.7.6



