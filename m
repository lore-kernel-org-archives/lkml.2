Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945989Ab2KOJSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:18:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51332 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945910Ab2KOJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:18:13 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50A4B337.6070109@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 18:17:43 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [Patch v5 4/7] acpi_memhotplug.c: free memory device if acpi_memory_enable_device()
 failed
References: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com> <1352962777-24407-5-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1352962777-24407-5-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 15:59, Wen Congyang wrote:
> If acpi_memory_enable_device() fails, acpi_memory_enable_device() will
> return a non-zero value, which means we fail to bind the memory device to
> this driver.  So we should free memory device before
> acpi_memory_device_add() returns.
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
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/acpi/acpi_memhotplug.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index c5e7b6d..e52ad5d 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -421,9 +421,11 @@ static int acpi_memory_device_add(struct acpi_device *device)
>   	if (!acpi_memory_check_device(mem_device)) {
>   		/* call add_memory func */
>   		result = acpi_memory_enable_device(mem_device);
> -		if (result)
> +		if (result) {
>   			printk(KERN_ERR PREFIX
>   				"Error in acpi_memory_enable_device\n");
> +			acpi_memory_device_free(mem_device);
> +		}
>   	}
>   	return result;
>   }
> 


