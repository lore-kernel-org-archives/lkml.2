Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2JSBoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:44:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2JSBoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:44:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,610,1344182400"; 
   d="scan'208";a="6026596"
Message-ID: <5080B1CD.6030008@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 09:50:05 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, len.brown@intel.com
Subject: Re: [PATCH 2/2] acpi,memory-hotplug : call acpi_bus_remo() to remove
 memory device
References: <506CE9F5.8020809@jp.fujitsu.com>	<506CEADA.9060108@jp.fujitsu.com> <CAE9FiQWaESFEBp+7w+E-ZfjgG4YFSTREoKfjNWNiOyhntf=uzg@mail.gmail.com>
In-Reply-To: <CAE9FiQWaESFEBp+7w+E-ZfjgG4YFSTREoKfjNWNiOyhntf=uzg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 09:44:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 09:44:05,
	Serialize complete at 2012/10/19 09:44:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/04/2012 10:41 AM, Yinghai Lu Wrote:
> On Wed, Oct 3, 2012 at 6:48 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> The memory device has been ejected and powoffed, so we can call
>> acpi_bus_remove() to remove the memory device from acpi bus.
>>
>> CC: Len Brown <len.brown@intel.com>
>> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  drivers/acpi/acpi_memhotplug.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> Index: linux-3.6/drivers/acpi/acpi_memhotplug.c
>> ===================================================================
>> --- linux-3.6.orig/drivers/acpi/acpi_memhotplug.c       2012-10-03 18:17:47.802249170 +0900
>> +++ linux-3.6/drivers/acpi/acpi_memhotplug.c    2012-10-03 18:17:52.471250299 +0900
>> @@ -424,8 +424,9 @@ static void acpi_memory_device_notify(ac
>>                 }
>>
>>                 /*
>> -                * TBD: Invoke acpi_bus_remove to cleanup data structures
>> +                * Invoke acpi_bus_remove() to remove memory device
>>                  */
>> +               acpi_bus_remove(device, 1);
> 
> why not using acpi_bus_trim instead?

Sorry for late reply. It's OK to use acpi_bus_trim(), and I will
update this patch soon.

Thanks
Wen Congyang

> 
> Yinghai
> 

