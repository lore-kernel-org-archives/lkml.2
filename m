Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2JWMG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:06:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab2JWMG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:06:28 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344182400"; 
   d="scan'208";a="6052469"
Message-ID: <508687FB.9080701@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 20:05:15 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Fix a hard coding style when determining if a device
 is a container.
References: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 20:05:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 20:05:49,
	Serialize complete at 2012/10/23 20:05:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would somebody give some comments ?

Thanks. :)

On 10/12/2012 08:31 PM, Tang Chen wrote:
> "ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
> container_device_ids[], so use it, but not the hard coding style.
>
> Also, introduce a new api is_container_device() to determine if a
> device is a container device.
>
> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> ---
>   drivers/acpi/container.c |   17 ++++++++++++++---
>   1 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 1f9f7d7..ffd76ee 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -92,6 +92,19 @@ static int is_device_present(acpi_handle handle)
>   	return ((sta&  ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
>   }
>
> +static int is_container_device(const char *hid)
> +{
> +	const struct acpi_device_id *container_id;
> +
> +	for (container_id = container_device_ids;
> +	     container_id->id[0]; container_id++) {
> +		if (!strcmp((char *)container_id->id, hid))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>   /*******************************************************************/
>   static int acpi_container_add(struct acpi_device *device)
>   {
> @@ -232,10 +245,8 @@ container_walk_namespace_cb(acpi_handle handle,
>   		goto end;
>   	}
>
> -	if (strcmp(hid, "ACPI0004")&&  strcmp(hid, "PNP0A05")&&
> -	    strcmp(hid, "PNP0A06")) {
> +	if (!is_container_device(hid))
>   		goto end;
> -	}
>
>   	switch (*action) {
>   	case INSTALL_NOTIFY_HANDLER:

