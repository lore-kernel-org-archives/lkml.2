Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2JDClU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:41:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50240 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2JDClR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <506CEADA.9060108@jp.fujitsu.com>
References: <506CE9F5.8020809@jp.fujitsu.com>
	<506CEADA.9060108@jp.fujitsu.com>
Date: Wed, 3 Oct 2012 19:41:16 -0700
X-Google-Sender-Auth: 02G7pitTjAc7ym-ZfnihvgHKSWQ
Message-ID: <CAE9FiQWaESFEBp+7w+E-ZfjgG4YFSTREoKfjNWNiOyhntf=uzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] acpi,memory-hotplug : call acpi_bus_remo() to remove
 memory device
From: Yinghai Lu <yinghai@kernel.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, len.brown@intel.com, wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:48 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> The memory device has been ejected and powoffed, so we can call
> acpi_bus_remove() to remove the memory device from acpi bus.
>
> CC: Len Brown <len.brown@intel.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-3.6/drivers/acpi/acpi_memhotplug.c
> ===================================================================
> --- linux-3.6.orig/drivers/acpi/acpi_memhotplug.c       2012-10-03 18:17:47.802249170 +0900
> +++ linux-3.6/drivers/acpi/acpi_memhotplug.c    2012-10-03 18:17:52.471250299 +0900
> @@ -424,8 +424,9 @@ static void acpi_memory_device_notify(ac
>                 }
>
>                 /*
> -                * TBD: Invoke acpi_bus_remove to cleanup data structures
> +                * Invoke acpi_bus_remove() to remove memory device
>                  */
> +               acpi_bus_remove(device, 1);

why not using acpi_bus_trim instead?

Yinghai
