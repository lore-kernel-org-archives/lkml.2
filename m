Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2KHVLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:11:25 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:34978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab2KHVLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:11:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [patch] acpi, pm: fix build breakage
Date: Thu, 08 Nov 2012 22:15:36 +0100
Message-ID: <3279768.UJJiLZErXa@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.00.1211081119350.8749@chino.kir.corp.google.com>
References: <1766582.8gdQKXoi0K@vostro.rjw.lan> <alpine.DEB.2.00.1211061150190.6467@chino.kir.corp.google.com> <alpine.DEB.2.00.1211081119350.8749@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 08, 2012 11:20:01 AM David Rientjes wrote:
> Commit b87b49cd0efd ("ACPI / PM: Move device PM functions related to sleep 
> states") declared acpi_target_system_state() for CONFIG_PM_SLEEP whereas 
> it is only defined for CONFIG_ACPI_SLEEP, resulting in the following link 
> error:
> 
> drivers/built-in.o: In function `acpi_pm_device_sleep_wake':
> drivers/acpi/device_pm.c:342: undefined reference to `acpi_target_system_state'
> drivers/built-in.o: In function `acpi_dev_suspend_late':
> drivers/acpi/device_pm.c:501: undefined reference to `acpi_target_system_state'
> drivers/built-in.o: In function `acpi_pm_device_sleep_state':
> drivers/acpi/device_pm.c:221: undefined reference to `acpi_target_system_state'
> 
> Define it only for CONFIG_ACPI_SLEEP and fallback to a dummy definition 
> for other configs.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

I've received the patch and will apply it when I get back home from Spain.

Thanks,
Rafael


> ---
>  include/acpi/acpi_bus.h |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -469,11 +469,9 @@ static inline int acpi_pm_device_run_wake(struct device *dev, bool enable)
>  #endif
>  
>  #ifdef CONFIG_PM_SLEEP
> -u32 acpi_target_system_state(void);
>  int __acpi_device_sleep_wake(struct acpi_device *, u32, bool);
>  int acpi_pm_device_sleep_wake(struct device *, bool);
>  #else
> -static inline u32 acpi_target_system_state(void) { return ACPI_STATE_S0; }
>  static inline int __acpi_device_sleep_wake(struct acpi_device *adev,
>  					   u32 target_state, bool enable)
>  {
> @@ -485,6 +483,12 @@ static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
>  }
>  #endif
>  
> +#ifdef CONFIG_ACPI_SLEEP
> +u32 acpi_target_system_state(void);
> +#else
> +static inline u32 acpi_target_system_state(void) { return ACPI_STATE_S0; }
> +#endif
> +
>  static inline bool acpi_device_power_manageable(struct acpi_device *adev)
>  {
>  	return adev->flags.power_manageable;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
