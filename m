Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab1I2UbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:31:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:40544 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471Ab1I2UbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,463,1312182000"; 
   d="scan'208";a="21928491"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Wang, Shane" <shane.wang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "liang.tang@oracle.com" <liang.tang@oracle.com>,
        "Yu, Ke" <ke.yu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: RE: [PATCH 3/8] x86/acpi/sleep: Provide registration for
 acpi_suspend_lowlevel.
Thread-Topic: [PATCH 3/8] x86/acpi/sleep: Provide registration for
 acpi_suspend_lowlevel.
Thread-Index: AQHMfuTWyLtvImwM7EyberMoVXrmdJVkz30Q
Date: Thu, 29 Sep 2011 20:30:36 +0000
Message-ID: <9F57BF860713DF4BA3EFA4F8C6DFEDAC16F7CD7D@ORSMSX101.amr.corp.intel.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
 <1317327414-24072-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1317327414-24072-4-git-send-email-konrad.wilk@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Thursday, September 29, 2011 1:17 PM
> To: linux-kernel@vger.kernel.org; rjw@sisk.pl; tglx@linutronix.de; hpa@zytor.com; x86@kernel.org;
> Brown, Len; Cihula, Joseph; Wang, Shane; xen-devel@lists.xensource.com; linux-pm@lists.linux-
> foundation.org; tboot-devel@lists.sourceforge.net; linux-acpi@vger.kernel.org;
> liang.tang@oracle.com; Yu, Ke; Tian, Kevin; jeremy@goop.org
> Cc: Konrad Rzeszutek Wilk
> Subject: [PATCH 3/8] x86/acpi/sleep: Provide registration for acpi_suspend_lowlevel.
> 
> From: Liang Tang <liang.tang@oracle.com>
> 
> Which by default will be x86_acpi_suspend_lowlevel.
> This registration allows us to register another callback if there is a need to use another
> platform specific callback.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org
> CC: Len Brown <len.brown@intel.com>
> CC: Joseph Cihula <joseph.cihula@intel.com>
> CC: Shane Wang <shane.wang@intel.com>
> CC: linux-pm@lists.linux-foundation.org
> CC: linux-acpi@vger.kernel.org
> CC: Len Brown <len.brown@intel.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Liang Tang <liang.tang@oracle.com>
> ---
>  arch/x86/include/asm/acpi.h  |    2 +-
>  arch/x86/kernel/acpi/boot.c  |    2 ++
>  arch/x86/kernel/acpi/sleep.c |    4 ++--
>  arch/x86/kernel/acpi/sleep.h |    2 ++
>  drivers/acpi/sleep.c         |    2 ++
>  5 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h index 0a46696..9b538dc
> 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -119,7 +119,7 @@ static inline void acpi_disable_pci(void)  }
> 
>  /* Low-level suspend routine. */
> -extern int acpi_suspend_lowlevel(void);
> +extern int (*acpi_suspend_lowlevel)(void);
> 
>  extern const unsigned char acpi_wakeup_code[];  #define acpi_wakeup_address
> (__pa(TRAMPOLINE_SYM(acpi_wakeup_code)))
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c index 7f30806..ddd081b
> 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -44,6 +44,7 @@
>  #include <asm/mpspec.h>
>  #include <asm/smp.h>
> 
> +#include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
>  static int __initdata acpi_force = 0;
>  u32 acpi_rsdt_forced;
>  int acpi_disabled;
> @@ -556,6 +557,7 @@ int (*__acpi_override_sleep)(u8 sleep_state, u32 pm1a_ctrl,
>  			     u32 pm1b_ctrl, bool *skip_rest) \
>  			   __attribute__ ((unused)) = NULL;
> 
> +int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
>  /*
>   * success: return IRQ number (>=0)
>   * failure: return < 0
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c index 103b6ab..4d2d0b1
> 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -25,12 +25,12 @@ static char temp_stack[4096];  #endif
> 
>  /**
> - * acpi_suspend_lowlevel - save kernel state
> + * x86_acpi_suspend_lowlevel - save kernel state
>   *
>   * Create an identity mapped page table and copy the wakeup routine to
>   * low memory.
>   */
> -int acpi_suspend_lowlevel(void)
> +int x86_acpi_suspend_lowlevel(void)
>  {
>  	struct wakeup_header *header;
>  	/* address in low memory of the wakeup routine. */ diff --git a/arch/x86/kernel/acpi/sleep.h
> b/arch/x86/kernel/acpi/sleep.h index 416d4be..4d3feb5 100644
> --- a/arch/x86/kernel/acpi/sleep.h
> +++ b/arch/x86/kernel/acpi/sleep.h
> @@ -13,3 +13,5 @@ extern unsigned long acpi_copy_wakeup_routine(unsigned long);  extern void
> wakeup_long64(void);
> 
>  extern void do_suspend_lowlevel(void);
> +
> +extern int x86_acpi_suspend_lowlevel(void);
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c index 3ed80b2..3570c00 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -254,6 +254,8 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>  		break;
> 
>  	case ACPI_STATE_S3:
> +		if (!acpi_suspend_lowlevel)
> +			return -ENODEV;
>  		error = acpi_suspend_lowlevel();
>  		if (error)
>  			return error;
> --
> 1.7.4.1

