Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797Ab2JXWMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:12:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758819Ab2JXWMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:12:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Fix a hard coding style when determining if a device is a container.
Date: Thu, 25 Oct 2012 00:16:08 +0200
Message-ID: <2015066.6aPMCAtdiB@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 of October 2012 20:31:38 Tang Chen wrote:
> "ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
> container_device_ids[], so use it, but not the hard coding style.
> 
> Also, introduce a new api is_container_device() to determine if a
> device is a container device.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Applied to linux-pm.git/acpi-next as v3.8 material.

Thanks,
Rafael


> ---
>  drivers/acpi/container.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 1f9f7d7..ffd76ee 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -92,6 +92,19 @@ static int is_device_present(acpi_handle handle)
>  	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
>  }
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
>  /*******************************************************************/
>  static int acpi_container_add(struct acpi_device *device)
>  {
> @@ -232,10 +245,8 @@ container_walk_namespace_cb(acpi_handle handle,
>  		goto end;
>  	}
>  
> -	if (strcmp(hid, "ACPI0004") && strcmp(hid, "PNP0A05") &&
> -	    strcmp(hid, "PNP0A06")) {
> +	if (!is_container_device(hid))
>  		goto end;
> -	}
>  
>  	switch (*action) {
>  	case INSTALL_NOTIFY_HANDLER:
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
