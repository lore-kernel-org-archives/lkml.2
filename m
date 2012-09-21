Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2IUBTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:19:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40219 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2IUBTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:19:52 -0400
Message-ID: <505BC0B4.4010306@mvista.com>
Date: Thu, 20 Sep 2012 20:19:48 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: yakui.zhao@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ACPI: Reorder IPMI driver before any other ACPI drivers
References: <1348177573-7537-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1348177573-7537-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 04:46 PM, Matthew Garrett wrote:
> Drivers may make calls that require the ACPI IPMI driver to have been
> initialised already, so make sure that it appears earlier in the build
> order.

The IPMI driver uses the ACPI namespace as an option to know the address 
and characteristics of the device.  Does that still work?

-corey

>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>   drivers/acpi/Makefile | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 47199e2..82422fe 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -47,6 +47,10 @@ acpi-y				+= video_detect.o
>   endif
>   
>   # These are (potentially) separate modules
> +
> +# IPMI may be used by other drivers, so it has to initialise before them
> +obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
> +
>   obj-$(CONFIG_ACPI_AC) 		+= ac.o
>   obj-$(CONFIG_ACPI_BUTTON)	+= button.o
>   obj-$(CONFIG_ACPI_FAN)		+= fan.o
> @@ -70,6 +74,5 @@ processor-y			+= processor_idle.o processor_thermal.o
>   processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
>   
>   obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
> -obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
>   
>   obj-$(CONFIG_ACPI_APEI)		+= apei/

