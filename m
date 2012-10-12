Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2JLLC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:02:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42104 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab2JLLCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:02:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5990096"
Message-ID: <5077F542.3010003@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 18:47:30 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        izumi.taku@jp.fujitsu.com, jiang.liu@huawei.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a hard coding style when determining if a device
 is a container.
References: <1350024916-3628-1-git-send-email-tangchen@cn.fujitsu.com> <5077ECA6.4010302@jp.fujitsu.com>
In-Reply-To: <5077ECA6.4010302@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:48:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:48:29,
	Serialize complete at 2012/10/12 18:48:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 06:10 PM, Yasuaki Ishimatsu wrote:
> Hi Tang,
> 
> 2012/10/12 15:55, Tang Chen wrote:
>> "ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
>> container_device_ids[], so use it, but not the hard coding style.
> 
> The idea is good.
> 
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>    drivers/acpi/container.c |   10 +++++++---
>>    1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
>> index 1f9f7d7..448c0e2 100644
>> --- a/drivers/acpi/container.c
>> +++ b/drivers/acpi/container.c
>> @@ -217,6 +217,7 @@ container_walk_namespace_cb(acpi_handle handle,
>>    {
>>    	char *hid = NULL;
>>    	struct acpi_device_info *info;
>> +	struct acpi_device_id *container_id;
>>    	acpi_status status;
>>    	int *action = context;
>>
>> @@ -232,10 +233,13 @@ container_walk_namespace_cb(acpi_handle handle,
>>    		goto end;
>>    	}
>>
>> -	if (strcmp(hid, "ACPI0004")&&  strcmp(hid, "PNP0A05")&&
>> -	    strcmp(hid, "PNP0A06")) {
>> -		goto end;
>> +	for (container_id = container_device_ids;
>> +	     container_id->id[0]; container_id++) {
>> +		if (!strcmp((char *)container_id->id, hid))
>> +			break;
>>    	}
>> +	if (!container_id->id[0])
>> +		goto end;
> 
> How about prepare is_container_device() function and check whether
> the device is the container device or not as below?

Sure. :)
A new patch will be sent soon.

Thanks for the wonderful idea. :)

> 
> 	if (is_container_device())
> 		goto end;
> 
> Thanks,
> Yasuaki Ishimatsu
> 
>>
>>    	switch (*action) {
>>    	case INSTALL_NOTIFY_HANDLER:
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

