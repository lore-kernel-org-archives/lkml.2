Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2LMAXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:23:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:17957 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2LMAX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:23:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="261395530"
Message-ID: <1355358199.2276.2.camel@rzhang1-mobl4>
Subject: Re: Thermal: Add a thermal notifier for user space
From: Zhang Rui <rui.zhang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>
Date: Thu, 13 Dec 2012 08:23:19 +0800
In-Reply-To: <20121212182838.GA7497@redhat.com>
References: <20121212180547.F12BE6606F0@gitolite.kernel.org>
	 <20121212182838.GA7497@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 13:28 -0500, Dave Jones wrote:
> On Wed, Dec 12, 2012 at 06:05:47PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=1cc807a234cb988d69ba18f6a3a1c68d71e54bed
>  > Commit:     1cc807a234cb988d69ba18f6a3a1c68d71e54bed
>  > Parent:     e151a202a084f9f4310d1aa4398325c56ca95fda
>  > Author:     Durgadoss R <durgadoss.r@intel.com>
>  > AuthorDate: Tue Sep 18 11:05:03 2012 +0530
>  > Committer:  Zhang Rui <rui.zhang@intel.com>
>  > CommitDate: Mon Nov 5 14:00:08 2012 +0800
>  > 
>  >     Thermal: Add a thermal notifier for user space
>  >     
>  >     This patch registers a governor which will let the
>  >     user land manage the platform thermals. Whenever a
>  >     trip happens, this governor just notifies the user
>  >     space using kobj_uevent().
>  >     
>  >     Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
>  >     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
>  
>  > +config USER_SPACE
>  > +	bool "User_space thermal governor"
>  > +	depends on THERMAL
>  > +	help
>  > +	  Enable this to let the user space manage the platform thermals.
> 
> This is terribly generic sounding.  Might I suggest THERMAL_USER_SPACE instead ?
> 
Hi, Dave,

You're right. How about the patch attached?

thanks,
rui

>From 595a531b3fbfd21d3d84a16fb8df93fdc0fe47e5 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 13 Dec 2012 08:05:12 +0800
Subject: [PATCH] Thermal: Rename thermal governor Kconfig options

Rename thermal governor Kconfig options,
CONFIG_STEP_WISE, CONFIG_FAIR_SHARE, CONFIG_USER_SPACE
to
CONFIG_THERMAL_GOVERNOR_STEP_WISE,
CONFIG_THERMAL_GOVERNOR_FAIR_SHARE,
CONFIG_THERMAL_GOVERNOR_USER_SPACE,
to avoid confusions brought by the previous generic naming.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/Kconfig  |   12 ++++++------
 drivers/thermal/Makefile |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 8636fae..13fed80 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -29,14 +29,14 @@ choice
 
 config THERMAL_DEFAULT_GOV_STEP_WISE
 	bool "step_wise"
-	select STEP_WISE
+	select THERMAL_GOVERNOR_STEP_WISE
 	help
 	  Use the step_wise governor as default. This throttles the
 	  devices one step at a time.
 
 config THERMAL_DEFAULT_GOV_FAIR_SHARE
 	bool "fair_share"
-	select FAIR_SHARE
+	select THERMAL_GOVERNOR_FAIR_SHARE
 	help
 	  Use the fair_share governor as default. This throttles the
 	  devices based on their 'contribution' to a zone. The
@@ -44,24 +44,24 @@ config THERMAL_DEFAULT_GOV_FAIR_SHARE
 
 config THERMAL_DEFAULT_GOV_USER_SPACE
 	bool "user_space"
-	select USER_SPACE
+	select THERMAL_GOVERNOR_USER_SPACE
 	help
 	  Select this if you want to let the user space manage the
 	  lpatform thermals.
 
 endchoice
 
-config FAIR_SHARE
+config THERMAL_GOVERNOR_FAIR_SHARE
 	bool "Fair-share thermal governor"
 	help
 	  Enable this to manage platform thermals using fair-share governor.
 
-config STEP_WISE
+config THERMAL_GOVERNOR_STEP_WISE
 	bool "Step_wise thermal governor"
 	help
 	  Enable this to manage platform thermals using a simple linear
 
-config USER_SPACE
+config THERMAL_GOVERNOR_USER_SPACE
 	bool "User_space thermal governor"
 	help
 	  Enable this to let the user space manage the platform thermals.
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index d8da683..4f5103d 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -5,9 +5,9 @@
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
 
 # governors
-obj-$(CONFIG_FAIR_SHARE)	+= fair_share.o
-obj-$(CONFIG_STEP_WISE)		+= step_wise.o
-obj-$(CONFIG_USER_SPACE)	+= user_space.o
+obj-$(CONFIG_THERMAL_GOVERNOR_FAIR_SHARE)	+= fair_share.o
+obj-$(CONFIG_THERMAL_GOVERNOR_STEP_WISE)	+= step_wise.o
+obj-$(CONFIG_THERMAL_GOVERNOR_USER_SPACE)	+= user_space.o
 
 # cpufreq cooling
 obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
-- 
1.7.9.5




