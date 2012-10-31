Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab2JaQs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:48:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45366 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2JaQsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <509106E2.70008@jp.fujitsu.com>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
	<509106E2.70008@jp.fujitsu.com>
Date: Wed, 31 Oct 2012 09:48:22 -0700
X-Google-Sender-Auth: msNxu-ErFZIWMuC4g-lLf1S2ddE
Message-ID: <CAE9FiQVrMj2KunOMDvftnu=MG=t=UpKTA4-t_YTYdgVL-rg_7Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] ACPI: container hot remove support.
From: Yinghai Lu <yinghai@kernel.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 4:09 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
>> patch 2. Introduce a new function container_device_remove() to handle
>>           ACPI_NOTIFY_EJECT_REQUEST event for container.
>
> If container device contains memory device, the function is
> very danger. As you know, we are developing a memory hotplug.
> If memory has kernel memory, memory hot remove operations fails.
> But container_device_remove() cannot realize it. So even if
> the memory hot remove operation fails, container_device_remove()
> keeps hot remove operation. Finally, the function sends _EJ0
> to firmware. In this case, if the memory is accessed, kernel
> panic occurs.
> The example is as follows:
>
>  https://lkml.org/lkml/2012/9/26/318

so what is the overall status memory hot-remove?
how are following memory get processed ?
1. memory for kernel text, module
2. page table
3. vmemmap
4. memory for kmalloc, for dma
