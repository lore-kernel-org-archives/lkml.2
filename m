Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018Ab2ILSGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:06:42 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:39952 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761002Ab2ILSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:06:39 -0400
Message-ID: <5050CF0E.3080502@xenotime.net>
Date: Wed, 12 Sep 2012 11:06:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Amit Daniel <amit.kachhap@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] thermal: cpu_cooling.c needs to select CPU_FREQ_TABLE
References: <20120912184644.48e4e2e7d59b12893a42f60a@canb.auug.org.au>
In-Reply-To: <20120912184644.48e4e2e7d59b12893a42f60a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

cpu_cooling.c (CONFIG_CPU_THERMAL) uses cpu frequency table
intefaces so it should select CPU_FREQ_TABLE.
Fixes these build errors:

drivers/built-in.o: In function `cpufreq_get_max_state':
cpu_cooling.c:(.text+0x4e1297): undefined reference to `cpufreq_frequency_get_table'
drivers/built-in.o: In function `cpufreq_set_cur_state':
cpu_cooling.c:(.text+0x4e138b): undefined reference to `cpufreq_frequency_get_table'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Amit Daniel <amit.kachhap@linaro.org>
---
 drivers/thermal/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Also, please add info in the MAINTAINERS file for drivers/thermal/.

--- linux-next-20120912.orig/drivers/thermal/Kconfig
+++ linux-next-20120912/drivers/thermal/Kconfig
@@ -22,6 +22,7 @@ config THERMAL_HWMON
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on THERMAL && CPU_FREQ
+	select CPU_FREQ_TABLE
 	help
 	  This implements the generic cpu cooling mechanism through frequency
 	  reduction, cpu hotplug and any other ways of reducing temperature. An
