Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab1FATsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:48:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51139 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759768Ab1FATsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u+2qA4tzf6PST7mBS6R3Ts0ovtSCxNeYXyjCh+grxi5GTHWHVlNHwazBocQzVZWtmw
         XR32r9b699qynH+jXk7WUlNxdrjSiRpf4xEIs2kDVUyoxOejNo4hnI8jXTIXkyEZOiAF
         zMK6IEW9DvHWcl4AzdGV6qwNB39BGspToE6aA=
Message-ID: <4DE6977E.5080107@samsung.com>
Date: Wed, 01 Jun 2011 12:48:14 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Donggeun Kim <dg77.kim@samsung.com>
CC: davej@redhat.com, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] CPUFREQ/S5PV210,EXYNOS4: Add Kconfig options for S5PV210
 and EXYNOS4 CPUfreq drivers
References: <1306476428-24808-1-git-send-email-dg77.kim@samsung.com> <1306483489-10432-1-git-send-email-dg77.kim@samsung.com>
In-Reply-To: <1306483489-10432-1-git-send-email-dg77.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/11 01:04, Donggeun Kim wrote:
> This patch adds CONFIG_CPU_FREQ_S5PV210 and CONFIG_CPU_FREQ_EXYNOS4
> to the machine Kconfig files.
>
> Signed-off-by: Donggeun Kim<dg77.kim@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos4/Kconfig |    7 +++++++
>   arch/arm/mach-s5pv210/Kconfig |    7 +++++++
>   2 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
> index e849f67..123e5e2 100644
> --- a/arch/arm/mach-exynos4/Kconfig
> +++ b/arch/arm/mach-exynos4/Kconfig
> @@ -91,6 +91,13 @@ config EXYNOS4_SETUP_FIMC
>   	help
>   	  Common setup code for the camera interfaces.
>
> +config CPU_FREQ_EXYNOS4
> +	bool
> +	depends on CPU_FREQ&&  ARCH_EXYNOS4
> +	default y
> +	help
> +	  This enabls the CPUfreq driver for EXYNOS4.
> +
>   # machine support
>
>   menu "EXYNOS4 Machines"
> diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
> index 37b5a97..376e824 100644
> --- a/arch/arm/mach-s5pv210/Kconfig
> +++ b/arch/arm/mach-s5pv210/Kconfig
> @@ -59,6 +59,13 @@ config S5PV210_SETUP_FIMC
>   	help
>   	  Common setup code for the camera interfaces.
>
> +config CPU_FREQ_S5PV210
> +	bool
> +	depends on CPU_FREQ&&  CPU_S5PV210
> +	default y
> +	help
> +	  This enabls the CPUfreq driver for S5PV210.
> +
>   menu "S5PC110 Machines"
>
>   config MACH_AQUILA

Cc'ed Ben Dooks.

No. Please don't add this in arch/arm. If required, they should be
added in drivers/cpufreq/ like x86.

As a note, I'm sorting that out which includes all of Samsung cpufreq
driver.

Dave, could you please see below? If you're ok, will submit remained
others for Samsung cpufreq drivers.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

---

 From 137f53472a0ea8ce584adbddfdb6ae645fc5a09c Mon Sep 17 00:00:00 2001
From: Kukjin Kim <kgene.kim@samsung.com>
Date: Wed, 1 Jun 2011 12:37:47 -0700
Subject: [PATCH] cpufreq: Add Samsung cpufreq driver compile in Kconfig.arm

According to discussion of the ARM arch subsystem migration,
ARM cpufreq drivers move to drivers/cpufreq. So this patch
adds Kconfig.arm for ARM like x86 and adds Samsung cpufreq
driver compile in there.

As a note didn't add 'default y' on this to build error during
each maintainers' merge. If required, it can be added later.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
  drivers/cpufreq/Kconfig     |    5 +++++
  drivers/cpufreq/Kconfig.arm |   21 +++++++++++++++++++++
  drivers/cpufreq/Makefile    |    2 ++
  3 files changed, 28 insertions(+), 0 deletions(-)
  create mode 100644 drivers/cpufreq/Kconfig.arm

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 9fb8485..e898215 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -184,5 +184,10 @@ depends on X86
  source "drivers/cpufreq/Kconfig.x86"
  endmenu

+menu "ARM CPU frequency scaling drivers"
+depends on ARM
+source "drivers/cpufreq/Kconfig.arm"
+endmenu
+
  endif
  endmenu
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
new file mode 100644
index 0000000..f2fc3a4
--- /dev/null
+++ b/drivers/cpufreq/Kconfig.arm
@@ -0,0 +1,21 @@
+#
+# ARM CPU Frequency scaling drivers
+#
+
+config ARM_S5PV210_CPUFREQ
+	bool "Samsung S5PV210 and S5PC110"
+	depends on CPU_S5PV210
+	---help---
+	  This adds the CPUFreq driver for Samsung S5PV210 and
+	  S5PC110 SoCs.
+
+	  If in doubt, say N.
+
+config ARM_EXYNOS4210_CPUFREQ
+	bool "Samsung EXYNOS4210"
+	depends on CPU_EXYNOS4210
+	---help---
+	  This adds the CPUFreq driver for Samsung EXYNOS4210
+	  SoC (S5PV310 or S5PC210).
+
+	  If in doubt, say N.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index e2fc2d2..864a27c 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -41,3 +41,5 @@ obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o

  # ARM SoC drivers
  obj-$(CONFIG_UX500_SOC_DB8500)		+= db8500-cpufreq.o
+obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
+obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
-- 
1.7.4.4
