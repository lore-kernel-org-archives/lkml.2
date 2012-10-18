Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2JRBBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:01:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30053 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2JRBBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:01:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,604,1344182400"; 
   d="scan'208";a="6018721"
Message-ID: <507F54BA.2050103@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 09:00:42 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: jiang.liu@huawei.com, bhelgaas@google.com, lenb@kernel.org,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Update acpi_root_bridge_list in container hotplug
 path.
References: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQVFc9VVfWZpEfjPeGvo5pby3BQNzDei3VTXdoR048_SPg@mail.gmail.com> <507E60C2.6010104@cn.fujitsu.com> <CAE9FiQX60dOE7odBx4OC0kawesZW3w9yLHEhmLoOvASaZ7q8dw@mail.gmail.com>
In-Reply-To: <CAE9FiQX60dOE7odBx4OC0kawesZW3w9yLHEhmLoOvASaZ7q8dw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 09:01:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 09:01:27,
	Serialize complete at 2012/10/18 09:01:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 12:28 AM, Yinghai Lu wrote:
> On Wed, Oct 17, 2012 at 12:39 AM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>> On 10/17/2012 01:18 PM, Yinghai Lu wrote:
>>
>> And also, I have another 2 questions, maybe you can help me.
>> 1) Do we need to put PNP0A08 into acpi_pci_roots ?
>
> looks like we need to unify those two ids.
>
>> 2) In container_notify_cb(), when it got a ACPI_NOTIFY_EJECT_REQUEST
>>     event, it doesn't do the hot-remove things.
>>     I use your sci emulator patch to test it. I did the following thing:
>>          echo echo "\_SB_.LSB1">  /sys/kernel/debug/acpi/sci_notify
>>     where \_SB_.LSB1 is a container, it just did nothing.
>>     Do we need to support this operation ?
>
> yes, looks like need to add container_device_remove and call it under
>   container_notify_cb/ACPI_NOTIFY_EJECT_REQUEST
>
> and should look like handle_root_bridge_removal to call acpi_bus_trim two times.

Hi Yinghai,

OK, I can do that. :)
And I'll send patches for that soon. :)

>
> Thanks
>
> Yinghai
>

