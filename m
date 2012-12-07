Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab2LGJvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:51:25 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:41296 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789Ab2LGJvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:51:22 -0500
Message-ID: <50C1BC10.8000506@compulab.co.il>
Date: Fri, 07 Dec 2012 11:51:12 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.7) Gecko/20121022 Thunderbird/10.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, "Hunter, Jon" <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH V3 11/11] ARM: delete struct sys_timer
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org> <1353349867-28494-12-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1353349867-28494-12-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I've only now bumped into the patchset (working the back log on linux-arm).
Sorry for late reply, but I guess you should have Cc'd the relevant
mailing lists with such changes.
Cc'd now.

On 11/19/12 20:31, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Now that the only field in struct sys_timer is .init, delete the struct,
> and replace the machine descriptor .timer field with the initialization
> function itself.
> 
> This will enable moving timer drivers into drivers/clocksource without
> having to place a public prototype of each struct sys_timer object into
> include/linux; the intent is to create a single of_clocksource_init()
> function that determines which timer driver to initialize by scanning
> the device dtree, much like the proposed irqchip_init() at:
> http://www.spinics.net/lists/arm-kernel/msg203686.html
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> v3: Minor merge conflicts due to rebasing onto next-20121115.
> v2: Converted all platforms, not just Tegra.
> 
> The patch is very large, so I've trimmed it for the mailing list, leaving
> only the core ARM changes, changes outside arch/arm, and a single machine
> example. The full series can be found at:
> 
> git://nv-tegra.nvidia.com/user/swarren/linux-2.6 arm_timer_rework
> ---

[...]

>  arch/arm/mach-omap1/board-ams-delta.c          |    2 +-
>  arch/arm/mach-omap1/board-fsample.c            |    2 +-
>  arch/arm/mach-omap1/board-generic.c            |    2 +-
>  arch/arm/mach-omap1/board-h2.c                 |    2 +-
>  arch/arm/mach-omap1/board-h3.c                 |    2 +-
>  arch/arm/mach-omap1/board-htcherald.c          |    2 +-
>  arch/arm/mach-omap1/board-innovator.c          |    2 +-
>  arch/arm/mach-omap1/board-nokia770.c           |    2 +-
>  arch/arm/mach-omap1/board-osk.c                |    2 +-
>  arch/arm/mach-omap1/board-palmte.c             |    2 +-
>  arch/arm/mach-omap1/board-palmtt.c             |    2 +-
>  arch/arm/mach-omap1/board-palmz71.c            |    2 +-
>  arch/arm/mach-omap1/board-perseus2.c           |    2 +-
>  arch/arm/mach-omap1/board-sx1.c                |    2 +-
>  arch/arm/mach-omap1/board-voiceblue.c          |    2 +-
>  arch/arm/mach-omap1/common.h                   |    2 +-
>  arch/arm/mach-omap1/time.c                     |    6 +-----
>  arch/arm/mach-omap2/board-2430sdp.c            |    2 +-
>  arch/arm/mach-omap2/board-3430sdp.c            |    2 +-
>  arch/arm/mach-omap2/board-3630sdp.c            |    2 +-
>  arch/arm/mach-omap2/board-4430sdp.c            |    2 +-
>  arch/arm/mach-omap2/board-am3517crane.c        |    2 +-
>  arch/arm/mach-omap2/board-am3517evm.c          |    2 +-
>  arch/arm/mach-omap2/board-apollon.c            |    2 +-
>  arch/arm/mach-omap2/board-cm-t35.c             |    4 ++--
>  arch/arm/mach-omap2/board-cm-t3517.c           |    2 +-
>  arch/arm/mach-omap2/board-devkit8000.c         |    2 +-
>  arch/arm/mach-omap2/board-generic.c            |   12 ++++++------
>  arch/arm/mach-omap2/board-h4.c                 |    2 +-
>  arch/arm/mach-omap2/board-igep0020.c           |    4 ++--
>  arch/arm/mach-omap2/board-ldp.c                |    2 +-
>  arch/arm/mach-omap2/board-n8x0.c               |    6 +++---
>  arch/arm/mach-omap2/board-omap3beagle.c        |    2 +-
>  arch/arm/mach-omap2/board-omap3evm.c           |    2 +-
>  arch/arm/mach-omap2/board-omap3logic.c         |    4 ++--
>  arch/arm/mach-omap2/board-omap3pandora.c       |    2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c       |    2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c     |    2 +-
>  arch/arm/mach-omap2/board-omap4panda.c         |    2 +-
>  arch/arm/mach-omap2/board-overo.c              |    2 +-
>  arch/arm/mach-omap2/board-rm680.c              |    4 ++--
>  arch/arm/mach-omap2/board-rx51.c               |    2 +-
>  arch/arm/mach-omap2/board-ti8168evm.c          |    4 ++--
>  arch/arm/mach-omap2/board-zoom.c               |    4 ++--
>  arch/arm/mach-omap2/common.h                   |   12 ++++++------
>  arch/arm/mach-omap2/timer.c                    |   17 +++--------------

[...]

>  492 files changed, 622 insertions(+), 1199 deletions(-)

I've looked at the omap2+ changes and I think OMAP4 and 5 got messed up a bit...
the below (compile tested on omap2plus only) should be applied:

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 2e0c446..f5d5f59 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -725,6 +725,6 @@ MACHINE_START(OMAP_4430SDP, "OMAP4430 4430SDP board")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap_4430sdp_init,
 	.init_late	= omap4430_init_late,
-	.init_time	= omap4_sync32k_timer_init,
+	.init_time	= omap4_local_timer_init,
 	.restart	= omap44xx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 5da84a9..8a5f814 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -159,7 +159,7 @@ DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap4430_init_late,
-	.init_time	= omap4_sync32k_timer_init,
+	.init_time	= omap4_local_timer_init,
 	.dt_compat	= omap4_boards_compat,
 	.restart	= omap44xx_restart,
 MACHINE_END
@@ -179,7 +179,7 @@ DT_MACHINE_START(OMAP5_DT, "Generic OMAP5 (Flattened Device Tree)")
 	.init_irq	= omap_gic_of_init,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap_generic_init,
-	.init_time	= omap5_sync32k_timer_init,
+	.init_time	= omap5_realtime_timer_init,
 	.dt_compat	= omap5_boards_compat,
 	.restart	= omap44xx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index fcae01e..ed8240c 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -456,6 +456,6 @@ MACHINE_START(OMAP4_PANDA, "OMAP4 Panda board")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap4_panda_init,
 	.init_late	= omap4430_init_late,
-	.init_time	= omap4_sync32k_timer_init,
+	.init_time	= omap4_local_timer_init,
 	.restart	= omap44xx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 56a3281..b435027 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -84,8 +84,8 @@ extern void omap3_sync32k_timer_init(void);
 extern void omap3_secure_sync32k_timer_init(void);
 extern void omap3_gp_gptimer_timer_init(void);
 extern void omap3_am33xx_gptimer_timer_init(void);
-extern void omap4_sync32k_timer_init(void);
-extern void omap5_sync32k_timer_init(void);
+extern void omap4_local_timer_init(void);
+extern void omap5_realtime_timer_init(void);
 
 void omap2420_init_early(void);
 void omap2430_init_early(void);



-- 
Regards,
Igor.
