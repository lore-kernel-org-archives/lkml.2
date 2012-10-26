Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2JZFoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 01:44:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19121 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2JZFoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 01:44:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,652,1344182400"; 
   d="scan'208";a="6074891"
Message-ID: <508A22EE.1000607@cn.fujitsu.com>
Date: Fri, 26 Oct 2012 13:43:10 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Jiang Liu <jiang.liu@huawei.com>, yinghai@kernel.org, bhelgaas@google.com,
        lenb@kernel.org, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mihailm@parallels.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Improve container_notify_cb() to support container
 hot-remove.
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com>   <1351058750-4275-3-git-send-email-tangchen@cn.fujitsu.com>  <1351098875.19172.21.camel@misato.fc.hp.com>  <5088967E.3060204@cn.fujitsu.com> <50889A14.9030607@huawei.com> <1351185648.19172.51.camel@misato.fc.hp.com>
In-Reply-To: <1351185648.19172.51.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 13:43:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 13:43:47,
	Serialize complete at 2012/10/26 13:43:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

On 10/26/2012 01:20 AM, Toshi Kani wrote:
...
>>>> Why do you need to call acpi_bus_trim(device,0) to stop the container
>>>> device first?
>>>
>>> This issue was introduced by Lu Yinghai, I think he could give a better
>>> answer than me. :)
>>> Please refer to the following url:
>>>
>>> http://www.spinics.net/lists/linux-pci/msg17667.html
>>>
>>> However, this is not applied into the pci tree yet.
>> We have worked out a patch set to clean up the logic for PCI/ACPI binding
>> relationship. It updates PCI/ACPI binding relationship by registering bus
>> notification onto pci_bus_type instead of hooking into the ACPI/glue.c.
>
> Thanks for the info and pointer.  Tang, I'd suggest you add such info to
> the comment so that others know that this step is needed for removing
> PCI bridges.  It helps us to know where to look at...

OK, I'll add it in the next version. :)

>
>> To accommodate that patch set, the ACPI device destroy process has been
>> split into two steps:
>> 1) acpi_bus_trim(device,0) to unbind ACPI drivers
>
> Does this step also detach PCI drivers from PCI cards as well?

Yes, it calls device_release_driver() to release the device driver.

     device_release_driver()
       |->__device_release_driver()
            |->dev->driver = NULL;

Thanks. :)

>
> Thanks,
> -Toshi
>
>

