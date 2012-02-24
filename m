Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab2BXUCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:02:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BXUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:02:53 -0500
Date: Fri, 24 Feb 2012 12:02:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: <rui.zhang@intel.com>, <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <salvatore.dedominicis@st.com>, <linux-kernel@vger.kernel.org>,
        <len.brown@intel.com>
Subject: Re: [PATCH] thermal: Add support for thermal sensor present on
 SPEAr13xx machines
Message-Id: <20120224120251.ad8e7332.akpm@linux-foundation.org>
In-Reply-To: <032b0bad50a9ad812c9a907138bb1a6caed38c74.1330068012.git.viresh.kumar@st.com>
References: <032b0bad50a9ad812c9a907138bb1a6caed38c74.1330068012.git.viresh.kumar@st.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 12:57:38 +0530
Viresh Kumar <viresh.kumar@st.com> wrote:

> From: Vincenzo Frascino <vincenzo.frascino@st.com>
> 
> ST's SPEAr13xx machines are based on CortexA9 ARM processors. These
> machines contain a thermal sensor for junction temperature monitoring.
> 
> This patch adds support for this thermal sensor in existing thermal
> framework.
> 
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -18,3 +18,10 @@ config THERMAL_HWMON
>  	depends on THERMAL
>  	depends on HWMON=y || HWMON=THERMAL
>  	default y
> +
> +config SPEAR_THERMAL
> +	bool "SPEAr thermal sensor driver"
> +	depends on THERMAL
> +	help
> +	  Enable this to plug the SPEAr thermal sensor driver into the Linux
> +	  thermal framework

The driver can be compiled for all architectures which support
CONFIG_THERMAL.  This includes x86_64.  Was that intended?

I don't think it's necessarily a bad thing: it gives the driver a lot
more compilation coverage and exposes bugs such as

drivers/thermal/spear_thermal.c: In function 'spear_thermal_probe':
drivers/thermal/spear_thermal.c:159: warning: cast from pointer to integer of different size

--- a/drivers/thermal/spear_thermal.c~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix
+++ a/drivers/thermal/spear_thermal.c
@@ -156,8 +156,8 @@ static int spear_thermal_probe(struct pl
 
 	platform_set_drvdata(pdev, spear_thermal);
 
-	dev_info(&spear_thermal->device, "Thermal Sensor Loaded at: 0x%x.\n",
-			(unsigned int)stdev->thermal_base);
+	dev_info(&spear_thermal->device, "Thermal Sensor Loaded at: 0x%p.\n",
+			stdev->thermal_base);
 
 	return 0;
 

but I do wonder if this was intentional.

