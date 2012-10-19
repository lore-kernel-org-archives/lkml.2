Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab2JSS1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:27:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64631 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2JSS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:27:00 -0400
MIME-Version: 1.0
In-Reply-To: <1350641040-19434-2-git-send-email-wency@cn.fujitsu.com>
References: <1350641040-19434-1-git-send-email-wency@cn.fujitsu.com> <1350641040-19434-2-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 14:26:39 -0400
X-Google-Sender-Auth: JjmgYywGCm-IeBHgrfFW2nysyyQ
Message-ID: <CAHGf_=pHQKqL+uSsHbcBe5Jy_NqabUTWFauaPVwN_B6JUn+VBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] acpi,memory-hotplug: call acpi_bus_trim() to
 remove memory device
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, liuj97@gmail.com, len.brown@intel.com,
        akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        muneda.takahiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 6:03 AM,  <wency@cn.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> The memory device has been ejected and powoffed, so we can call
> acpi_bus_trim() to remove the memory device from acpi bus.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 24c807f..1e90e8f 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -401,8 +401,9 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>                 }
>
>                 /*
> -                * TBD: Invoke acpi_bus_remove to cleanup data structures
> +                * Invoke acpi_bus_trim() to remove memory device
>                  */
> +               acpi_bus_trim(device, 1);

I'm happy we removed mysterious acpi_bus_remove().
