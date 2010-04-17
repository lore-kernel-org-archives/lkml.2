Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0DQAdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 20:33:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:18897 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab0DQAdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 20:33:12 -0400
Date: Fri, 16 Apr 2010 17:31:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: platform-driver-x86@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Make WMI be selected automatically when needed
Message-Id: <20100416173127.6b968fd4.randy.dunlap@oracle.com>
In-Reply-To: <4BC8FF9D.7050500@tremplin-utc.net>
References: <4BC8FF9D.7050500@tremplin-utc.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC901AB.014D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Apr 2010 02:23:57 +0200 Éric Piel wrote:

> Many different modules depend on WMI. In Kconfig, some used to "depend"
> on it, while others "selected" it. As WMI by itself is useless and more
> like a library, it's easier for the user to have it automatically
> selected whenever needed. It's especially true for options in completely
> different places (like LEDS_DELL_NETBOOKS). So we consistently "select"
> it.
> 
> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

config ACPI_WMI
	tristate "WMI"
	depends on ACPI

so what happens when one of these configs selects ACPI_WMI
but ACPI is not enabled?  Hint:  that will not enable ACPI.

Did you test that kconfig combination?


> ---
>  drivers/leds/Kconfig         |    3 ++-
>  drivers/platform/x86/Kconfig |    8 ++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 505eb64..71e8a51 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -280,7 +280,8 @@ config LEDS_ADP5520
>  
>  config LEDS_DELL_NETBOOKS
>  	tristate "External LED on Dell Business Netbooks"
> -	depends on X86 && ACPI_WMI
> +	depends on X86
> +	select ACPI_WMI
>  	help
>  	  This adds support for the Latitude 2100 and similar
>  	  notebooks that have an external LED.
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 7bec458..9808ef3 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -89,8 +89,8 @@ config DELL_LAPTOP
>  
>  config DELL_WMI
>  	tristate "Dell WMI extras"
> -	depends on ACPI_WMI
>  	depends on INPUT
> +	select ACPI_WMI
>  	---help---
>  	  Say Y here if you want to support WMI-based hotkeys on Dell laptops.
>  
> @@ -136,9 +136,9 @@ config TC1100_WMI
>  
>  config HP_WMI
>  	tristate "HP WMI extras"
> -	depends on ACPI_WMI
>  	depends on INPUT
>  	depends on RFKILL || RFKILL = n
> +	select ACPI_WMI
>  	help
>  	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
>  	 to read data from WMI such as docking or ambient light sensor state.
> @@ -387,9 +387,9 @@ config EEEPC_LAPTOP
>  
>  config EEEPC_WMI
>  	tristate "Eee PC WMI Hotkey Driver (EXPERIMENTAL)"
> -	depends on ACPI_WMI
>  	depends on INPUT
>  	depends on EXPERIMENTAL
> +	select ACPI_WMI
>  	---help---
>  	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
>  
> @@ -419,9 +419,9 @@ config ACPI_WMI
>  
>  config MSI_WMI
>  	tristate "MSI WMI extras"
> -	depends on ACPI_WMI
>  	depends on INPUT
>  	depends on BACKLIGHT_CLASS_DEVICE
> +	select ACPI_WMI
>  	select INPUT_SPARSEKMAP
>  	help
>  	 Say Y here if you want to support WMI-based hotkeys on MSI laptops.
> -- 


---
~Randy
