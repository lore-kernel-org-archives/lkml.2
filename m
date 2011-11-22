Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab1KVKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:22:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37767 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754685Ab1KVKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:22:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/PF11RIDPPz8s7Of8XkLCBxebKzrO8/hG+5hA3EY
	ykmFVWchad7le/
Subject: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series
From: Mike Galbraith <efault@gmx.de>
To: Nicolas Kalkhof <nkalkhof@web.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        maciej.rutecki@gmail.com
In-Reply-To: <1525712996.2585575.1321949994931.JavaMail.fmail@mwmweb003>
References: <1525712996.2585575.1321949994931.JavaMail.fmail@mwmweb003>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 11:22:19 +0100
Message-ID: <1321957339.6855.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 09:19 +0100, Nicolas Kalkhof wrote:
> Hi Mike,
> 
> thanks for your reply! I didn't set any polling explicitly.
> 
> My boot params are:
> intel_iommu=off pcie_aspm=force i915.powersave=1 i915.i915_enable_rc6=1
> 
> and in the cpufrequtils startup daemon the only parameter set is:
> # Options when starting cpufreq (given to the `cpufreq-set` program)
> START_OPTS="--governor ondemand"
> 
> egrep "IDLE|GOV" .config yields:
> 
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_INTEL_IDLE=y
> # CONFIG_I7300_IDLE is not set
> 
> Any advice?

Not really.  If you apply the below, then..

make -C tools/perf prefix=/usr/local install
perf top -U

..does perf top agree with oprofile?

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9cdedb..28ef86d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -636,7 +636,6 @@ static const char *skip_symbols[] = {
 	"exit_idle",
 	"mwait_idle",
 	"mwait_idle_with_hints",
-	"poll_idle",
 	"ppc64_runlatch_off",
 	"pseries_dedicated_idle_sleep",
 	NULL


