Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2JRFxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:53:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23314 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2JRFx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:53:29 -0400
X-IronPort-AV: E=Sophos;i="4.80,605,1344182400"; 
   d="scan'208";a="6020972"
Message-ID: <507F9915.2080409@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 13:52:21 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: lenb@kernel.org, yinghai@kernel.org, jiang.liu@huawei.com,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PNP0A08 into acpi_pci_roots array.
References: <1350526971-9427-1-git-send-email-tangchen@cn.fujitsu.com> <CAErSpo6ehw1JHMyE27MuX2VR89+1zC48QJe9Udih88N-W-73Wg@mail.gmail.com>
In-Reply-To: <CAErSpo6ehw1JHMyE27MuX2VR89+1zC48QJe9Udih88N-W-73Wg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 13:53:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 13:53:05,
	Serialize complete at 2012/10/18 13:53:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 11:55 AM, Bjorn Helgaas wrote:
> On Wed, Oct 17, 2012 at 8:22 PM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>> acpi_pci_roots array doesn't include PNP0A08, which is PCI Express
>> Root Bridge.
>
> You need to explain why this change is necessary.  PNP0A08 devices
> will have a PNP0A03 _CID, so the driver already claims PNP0A08 devices
> because the _CID matches.

Hi Bjorn,

Here is my reason, but just my personal opinion. :)

1) There is no code to handle a pcie host bridge hotplug in kernel now.
    And when this happens,  pci host bridge related code will be
    executed, which makes me think that PNP0A03 and PNP0A08 are seen as
    the same devices. At least for now they are.
    So, acpi_pci_roots doesn't include PNP0A08 seems a little strange to
    me.

2) When I was reading Liu Jiang's "ACPI based hotplug framework"
    patches, I happened to see that he defined the following:

         static char *acpihp_dev_pcihb_ids[] = {
	        "PNP0A03",
                 "PNP0A08",
                 NULL
         };

    And also, Lu Yinghai defined the following in his own patch:

         static const struct acpi_device_id root_device_ids[] = {
                 {"PNP0A03", 0},
                 {"PNP0A08", 0},
                 {NULL, 0}
         };

    I think all these arraies should represent the same things, and we
    need only one of them.
    For now, it is root_device_ids[] in drivers/acpi/pci_root.c.

Well, all above is my own opinion. And you are right, even if we don't
change it, there won't be any problem.

Thanks. :)



>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   drivers/acpi/pci_root.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index 037b59c..dedc4d6 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -56,6 +56,7 @@ static int acpi_pci_root_start(struct acpi_device *device);
>>
>>   static const struct acpi_device_id root_device_ids[] = {
>>          {"PNP0A03", 0},
>> +       {"PNP0A08", 0},
>>          {"", 0},
>>   };
>>   MODULE_DEVICE_TABLE(acpi, root_device_ids);
>> --
>> 1.7.1
>>
>

