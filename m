Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2JQQ2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:28:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64591 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2JQQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <507E60C2.6010104@cn.fujitsu.com>
References: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com>
	<CAE9FiQVFc9VVfWZpEfjPeGvo5pby3BQNzDei3VTXdoR048_SPg@mail.gmail.com>
	<507E60C2.6010104@cn.fujitsu.com>
Date: Wed, 17 Oct 2012 09:28:09 -0700
X-Google-Sender-Auth: g-0yTC4c-Csf_nThCrdvkN5Mr1Y
Message-ID: <CAE9FiQX60dOE7odBx4OC0kawesZW3w9yLHEhmLoOvASaZ7q8dw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Update acpi_root_bridge_list in container hotplug path.
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: jiang.liu@huawei.com, bhelgaas@google.com, lenb@kernel.org,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:39 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> On 10/17/2012 01:18 PM, Yinghai Lu wrote:
>
> And also, I have another 2 questions, maybe you can help me.
> 1) Do we need to put PNP0A08 into acpi_pci_roots ?

looks like we need to unify those two ids.

> 2) In container_notify_cb(), when it got a ACPI_NOTIFY_EJECT_REQUEST
>    event, it doesn't do the hot-remove things.
>    I use your sci emulator patch to test it. I did the following thing:
>         echo echo "\_SB_.LSB1" > /sys/kernel/debug/acpi/sci_notify
>    where \_SB_.LSB1 is a container, it just did nothing.
>    Do we need to support this operation ?

yes, looks like need to add container_device_remove and call it under
 container_notify_cb/ACPI_NOTIFY_EJECT_REQUEST

and should look like handle_root_bridge_removal to call acpi_bus_trim two times.

Thanks

Yinghai
