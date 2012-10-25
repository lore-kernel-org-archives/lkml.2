Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2JYBc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:32:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab2JYBc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:32:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,644,1344182400"; 
   d="scan'208";a="6063114"
Message-ID: <5088967E.3060204@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 09:31:42 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mihailm@parallels.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Improve container_notify_cb() to support container
 hot-remove.
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com>  <1351058750-4275-3-git-send-email-tangchen@cn.fujitsu.com> <1351098875.19172.21.camel@misato.fc.hp.com>
In-Reply-To: <1351098875.19172.21.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 09:32:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 09:32:21,
	Serialize complete at 2012/10/25 09:32:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

On 10/25/2012 01:14 AM, Toshi Kani wrote:
> On Wed, 2012-10-24 at 14:05 +0800, Tang Chen wrote:
>> +static int container_device_remove(struct acpi_device *device)
>> +{
>> +	int ret;
>> +	struct acpi_eject_event *ej_event;
>> +
>> +	/* stop container device at first */
>> +	ret = acpi_bus_trim(device, 0);
>
> Hi Tang,
>
> Why do you need to call acpi_bus_trim(device,0) to stop the container
> device first?

This issue was introduced by Lu Yinghai, I think he could give a better
answer than me. :)
Please refer to the following url:

http://www.spinics.net/lists/linux-pci/msg17667.html

However, this is not applied into the pci tree yet.

>
>> +	printk(KERN_WARNING "acpi_bus_trim stop return %x\n", ret);
>
> Do you need this message in the normal case?  If so, I'd suggest to use
> pr_debug().
>
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* event originated from ACPI eject notification */
>> +	device->flags.eject_pending = 1;
>
> You do not need to set the eject_pending flag when the handler calls
> acpi_bus_hot_remove_device().  It was set before because the handler did
> not initiate the hot-remove operation.

I just set it to keep the logic the same as before.
And thanks for telling me this. :)

>
...
>> +		printk(KERN_WARNING "Container driver received %s event\n",
>> +			"ACPI_NOTIFY_EJECT_REQUEST");
>
> Same as other comment.  Suggest to use pr_debug().

OK. :)

>
>> +
>> +		if (!present || ACPI_FAILURE(status) || !device)
>> +			break;
>> +
>> +		result = container_device_remove(device);
>> +		if (result) {
>> +			printk(KERN_WARNING "Failed to remove container\n");
>
> Please use pr_warn().
>
> Thanks,
> -Toshi
>
>> +			break;
>>   		}
>> -		break;
>> +
>> +		return;
>>
>>   	default:
>>   		/* non-hotplug event; possibly handled by other handler */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

