Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2JQHlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:41:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2JQHk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:40:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,599,1344182400"; 
   d="scan'208";a="6015376"
Message-ID: <507E60C2.6010104@cn.fujitsu.com>
Date: Wed, 17 Oct 2012 15:39:46 +0800
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
References: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQVFc9VVfWZpEfjPeGvo5pby3BQNzDei3VTXdoR048_SPg@mail.gmail.com>
In-Reply-To: <CAE9FiQVFc9VVfWZpEfjPeGvo5pby3BQNzDei3VTXdoR048_SPg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 15:40:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 15:40:34,
	Serialize complete at 2012/10/17 15:40:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 01:18 PM, Yinghai Lu wrote:
>
> no, we don't need that.
>
> after closely looking, it seems we can dump acpi_root_bridge.
>
> please check if attached patch could work with container path.

Hi Yinghai,

Your patch seems working well.

BTW, I actually found that the two lists, acpi_root_bridge and
acpi_pci_roots in drivers/acpi/pci_root.c were similar, except
your acpi_root_bridge included PNP0A08.

In the beginning, I thought you would use it in some other situations,
and now it is clear that it can be removed.
Thanks. :)

And also, I have another 2 questions, maybe you can help me.
1) Do we need to put PNP0A08 into acpi_pci_roots ?
2) In container_notify_cb(), when it got a ACPI_NOTIFY_EJECT_REQUEST
    event, it doesn't do the hot-remove things.
    I use your sci emulator patch to test it. I did the following thing:
	echo echo "\_SB_.LSB1" > /sys/kernel/debug/acpi/sci_notify
    where \_SB_.LSB1 is a container, it just did nothing.
    Do we need to support this operation ?

Thanks. :)

>
> Thanks
>
> Yinghai

