Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2BCJVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:21:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45644 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab2BCJVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:21:13 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "Hilman, Kevin" <khilman@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
Thread-Topic: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
Thread-Index: AQHM4dFYU77TeNR4wkif3uVvUh773pYq5S6Q
Date: Fri, 3 Feb 2012 09:21:03 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C3317A5DF7@DBDE01.ent.ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {599DC9D6-BA79-45A3-B2F7-19A0B9D4951B}
x-cr-hashedpuzzle: Amsm DA3p Eg2g FU4/ I/xn JlUh NwxS bDwJ bR3H cu78 giFV
 pD2t uNEK vXTW zQG8
 2148;5;ZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG8AbQBhAHAAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwBuAHkAQABhAHQAbwBtAGkAZABlAC4AYwBvAG0A;Sosha1_v1;7;{599DC9D6-BA79-45A3-B2F7-19A0B9D4951B};ZwB1AHIAdQByAGEAagBhAC4AaABlAGIAYgBhAHIAQAB0AGkALgBjAG8AbQA=;Fri,
 03 Feb 2012 09:20:23
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYAOQAgADAAMAAvADIANQBdACAAZwBwAGkAbwAvAG8AbQBhAHAAOgAgAGQAcgBpAHYAZQByACAAYwBsAGUAYQBuAHUAcAAgAGEAbgBkACAAZgBpAHgAZQBzAA==
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarun,

I am interested in testing these patches on AM335x. Do you have a tree with these 
patches applied so that I can pull. 

On Thu, Feb 02, 2012 at 23:00:26, DebBarma, Tarun Kanti wrote:
> The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
>   Linus Torvalds (1):
>         Linux 3.3-rc2
> 
> are available in the git repository at:
> http://gitorious.org/~tarunkanti/omap-sw-develoment/tarunkantis-linux-omap-dev
> Branch: for_3.4/gpio_cleanup_fixes_v9
> 
> This series is continuation of cleanup of OMAP GPIO driver and fixes.
> The cleanup include getting rid of cpu_is_* checks wherever possible,
> use of gpio_bank list instead of static array, use of unique platform
> specific value associated data member to OMAP platforms to avoid
> cpu_is_* checks. The series also include PM runtime support.
> 
> Power Tests
> a) OMAP3430SDP
> - Modify board-3430sdp.c file to have multiple GPIO modules active
>   with debounce timeout enabled.
> - Enable CPU-Idle
> - Enable UART timeouts
> - Enable offmode
> - echo mem > /sys/power/state
> - Verify retention and offmode count increment
> 
>   Used following patches to avoid exception during system suspend:-
>   [PATCH RFC 1/2] mtd : Prevent the NULL pointer access
>   [PATCH RFC 2/2] mtd : Make the mtd_suspend return 0 if the suspend is not implemented
> 
> # echo mem > /sys/power/state
> [   47.128021] PM: Syncing filesystems ... done.
> [   47.144104] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [   47.168243] Freezing remaining freezable tasks ... (elapsed 0.02 seconds) don                                                                                                 e.
> [   47.205139] Unable to handle kernel NULL pointer dereference at virtual addre                                                                                                 ss 000000a0
> [   47.213317] pgd = deaac000
> [   47.216033] [000000a0] *pgd=9e932831, *pte=00000000, *ppte=00000000
> [   47.222381] Internal error: Oops: 17 [#1] SMP
> [   47.226745] Modules linked in:
> [   47.229827] CPU: 0    Not tainted  (3.3.0-rc2-00031-g12c5c5c #235)
> [   47.236022] PC is at mtd_cls_suspend+0x8/0x20
> [   47.240386] LR is at mtd_cls_suspend+0x8/0x20
> [   47.244750] pc : [<c02e78f8>]    lr : [<c02e78f8>]    psr: a0000013
> [   47.244750] sp : dea1fe60  ip : 22222222  fp : c0ee7d40
> [   47.256256] r10: c0ee7cf0  r9 : 00000000  r8 : c02e78f0
> [   47.261474] r7 : 00000000  r6 : 00000000  r5 : 00000002  r4 : dea45800
> [   47.268005] r3 : deb4cac0  r2 : 00000000  r1 : 00000002  r0 : 00000000
> [   47.274536] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   47.281677] Control: 10c5387d  Table: 9eaac019  DAC: 00000015
> [   47.287445] Process sh (pid: 1177, stack limit = 0xdea1e2f8)
> [   47.293090] Stack: (0xdea1fe60 to 0xdea20000)
> [...]
> 
> b) ZOOM3
> - Enable CPU-Idle
> - Enable UART timeout
> - echo mem > /sys/power/state
> - Wakeup system using serial keyboard
> - Verify retention count increment
> 
> Functional Tests
> - Done on OMAP2430, OMAP3430SDP, ZOOM3, OMAP4430
> 
> Bootup Test
> - Done on OMAP1710
>   Used following patch to fix OMAP1 build error:-
>   [PATCH] i2c: OMAP: Fix OMAP1 build error
> 

[..]
[..]

> Charulatha V (8):
>   gpio/omap: remove dependency on gpio_bank_count
>   gpio/omap: use flag to identify wakeup domain
>   gpio/omap: make gpio_context part of gpio_bank structure
>   gpio/omap: make non-wakeup GPIO part of pdata
>   gpio/omap: avoid cpu checks during module ena/disable
>   gpio/omap: use pinctrl offset instead of macro
>   gpio/omap: remove bank->method & METHOD_* macros
>   gpio/omap: fix bankwidth for OMAP7xx MPUIO
> 
> Nishanth Menon (4):
>   gpio/omap: save and restore debounce registers
>   gpio/omap: enable irq at the end of all configuration in restore
>   gpio/omap: restore OE only after setting the output level
>   gpio/omap: handle set_dataout reg capable IP on restore
> 
> Tarun Kanti DebBarma (13):
>   gpio/omap: handle save/restore context in GPIO driver
>   gpio/omap: further cleanup using wkup_en register
>   gpio/omap: use level/edge detect reg offsets
>   gpio/omap: remove hardcoded offsets in context save/restore
>   gpio/omap: cleanup set_gpio_triggering function
>   gpio/omap: cleanup omap_gpio_mod_init function
>   gpio/omap: remove unnecessary bit-masking for read access
>   gpio/omap: use pm-runtime framework
>   gpio/omap: optimize suspend and resume functions
>   gpio/omap: cleanup prepare_for_idle and resume_after_idle
>   gpio/omap: fix debounce clock handling
>   gpio/omap: fix incorrect access of debounce module
>   gpio/omap: remove omap_gpio_save_context overhead
> 
>  arch/arm/mach-omap1/gpio15xx.c         |    7 +-
>  arch/arm/mach-omap1/gpio16xx.c         |   47 ++-
>  arch/arm/mach-omap1/gpio7xx.c          |   14 +-
>  arch/arm/mach-omap2/gpio.c             |   36 +-
>  arch/arm/mach-omap2/pm34xx.c           |   14 -
>  arch/arm/plat-omap/include/plat/gpio.h |   29 +-
>  drivers/gpio/gpio-omap.c               | 1099 +++++++++++++-------------------
>  7 files changed, 549 insertions(+), 697 deletions(-)
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


Regards, 
Gururaja
